#!/usr/bin/env python3
import sys
import os
import io
import time
import json
import socket
import threading
import fitz  # PyMuPDF
from base64 import standard_b64encode
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# --- Configuration ---
SOCKET_PATH = "/tmp/kpdf_sync.sock"
CHUNK_SIZE = 4096

# --- Kitty Graphics Protocol Helper ---
def _write_chunked(cmd, data):
    """Sends graphics data to Kitty in chunks to avoid buffer overflows."""
    sys.stdout.write(f"\x1b_G{cmd};")
    if data:
        # Loop over data in chunks
        while len(data) > CHUNK_SIZE:
            chunk = data[:CHUNK_SIZE]
            data = data[CHUNK_SIZE:]
            sys.stdout.write(chunk.decode('ascii'))
            sys.stdout.write("\x1b\\") # End chunk
            sys.stdout.write("\x1b_Gm=1;") # Start new chunk
        # Write last chunk
        sys.stdout.write(data.decode('ascii'))
    sys.stdout.write("\x1b\\")
    sys.stdout.flush()

def write_chunked(cmd, data):
    data = standard_b64encode(data)
    first = True

    while data:
        chunk, data = data[:CHUNK_SIZE], data[CHUNK_SIZE:]
        m = 1 if data else 0

        header = f"{cmd},m={m}" if first else f"m={m}"
        first = False

        sys.stdout.buffer.write(b"\x1b_G" + header.encode("ascii") + b";" + chunk + b"\x1b\\")
        sys.stdout.flush()

def clear_screen():
    sys.stdout.write("\x1b[2J\x1b[H")
    sys.stdout.flush()

# --- The Viewer Logic ---
class PDFViewer:
    def __init__(self, pdf_path):
        self.pdf_path = pdf_path
        self.doc = None
        self.current_page_idx = 0
        self.zoom = 1.5 # DPI scale
        self.scroll_y = 0
        self.image_id = 100 # Arbitrary ID for GPU texture
        self.lock = threading.Lock()
        self.needs_reload = True
        
        # Load initially
        self.reload_doc()

    def reload_doc(self):
        with self.lock:
            try:
                if self.doc: self.doc.close()
                self.doc = fitz.open(self.pdf_path)
                self.needs_reload = True
            except Exception as e:
                print(f"Error loading PDF: {e}")

    def get_current_page_height(self):
        # Return height in screen pixels (approx)
        if not self.doc: return 0
        page = self.doc[self.current_page_idx]
        return int(page.rect.height * self.zoom)

    def _render_and_upload(self):
        """
        Renders the page to a buffer and uploads it to Kitty's GPU memory.
        We do NOT display it yet, just store it with a=T (Transmit).
        """
        if not self.doc: return
        
        with self.lock:
            page = self.doc[self.current_page_idx]
            mat = fitz.Matrix(self.zoom, self.zoom)
            # alpha=False is faster and we don't need transparency for PDFs usually
            pix = page.get_pixmap(matrix=mat, alpha=False)
            
            # Format logic: f=32 (RGBA), s=width, v=height
            fmt = f"f=32,s={pix.width},v={pix.height},a=T,i={self.image_id},q=2"
            
            # Pymupdf samples are raw bytes, we need base64 for standard transmission
            # (Note: RGB transmission is faster but requires specific implementation details)
            data = standard_b64encode(pix.samples)
            
            # Send to Kitty
            write_chunked(fmt, data)
            self.needs_reload = False
        
    def render_and_upload(self):
        if not self.doc:
            return

        with self.lock:
            page = self.doc[self.current_page_idx]
            mat = fitz.Matrix(self.zoom, self.zoom)

            pix = page.get_pixmap(matrix=mat, alpha=False)

            fmt = f"f=24,s={pix.width},v={pix.height},a=T,i={self.image_id}"
            write_chunked(fmt, pix.samples)

            self.needs_reload = False

    def draw_viewport(self):
        """
        Tells Kitty to display the image stored at self.image_id,
        but cropped to the current scroll position.
        """
        if self.needs_reload:
            self.render_and_upload()

        # a=p (place), C=1 (do not move cursor)
        # We use standard scrolling interaction. 
        # But for 'smooth' feel we can manipulate 'y' (source y) and 'Y' (height to show)
        # For simplicity in this script, we place the whole image and let the terminal scroll,
        # OR we just clear and redraw the placement.
        
        # Let's do the static placement strategy:
        # Clear screen, Place image at x=0, y=0 minus scroll_offset
        clear_screen()
        
        # We can use the 'c', 'r' (columns/rows) or pixel offsets.
        # i=<id> refers to the texture we uploaded.
        sys.stdout.write(f"\x1b_Ga=p,i={self.image_id},x=0,y={-self.scroll_y},C=1\x1b\\")
        sys.stdout.flush()

    def scroll(self, amount):
        max_h = self.get_current_page_height()
        self.scroll_y += amount
        # Bounds check
        if self.scroll_y < 0: 
            if self.current_page_idx > 0:
                self.current_page_idx -= 1
                self.needs_reload = True
                self.scroll_y = 0 # logic to go to bottom of prev page omitted for brevity
            else:
                self.scroll_y = 0
        
        # Simple page flip logic
        # If we scroll past the bottom, go to next page
        # Note: This is a simplification.
        if self.scroll_y > max_h: # If we scrolled past image
             if self.current_page_idx < len(self.doc) - 1:
                 self.current_page_idx += 1
                 self.scroll_y = 0
                 self.needs_reload = True
             else:
                 self.scroll_y = max_h 

        self.draw_viewport()

    def sync_to_line(self, line_num, source_file):
        """Uses SyncTeX to find the page and Y-coordinate."""
        # This requires the pdf to have been compiled with -synctex=1
        # We invoke the synctex binary.
        import subprocess
        
        # Construct synctex command
        # synctex view -i "line:0:source_file" -o "pdf_path"
        cmd = ["synctex", "view", "-i", f"{line_num}:0:{source_file}", "-o", self.pdf_path]
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            output = result.stdout
            
            # Parse synctex output (it's multiline)
            # We look for "Page:N" and "y:N"
            t_page = 0
            t_y = 0
            
            for line in output.splitlines():
                if "Page:" in line:
                    t_page = int(line.split(":")[1])
                if "y:" in line:
                    t_y = float(line.split(":")[1])
            
            if t_page > 0:
                with self.lock:
                    self.current_page_idx = t_page - 1
                    # SyncTeX Y is usually from top of page in pts. Convert to pixels.
                    self.scroll_y = int(t_y * self.zoom) 
                    self.needs_reload = True
                self.draw_viewport()
                
        except Exception as e:
            pass # SyncTeX failed

# --- File Watcher for Auto-Reload ---
class ReloadHandler(FileSystemEventHandler):
    def __init__(self, viewer):
        self.viewer = viewer
    def on_modified(self, event):
        if event.src_path.endswith(".pdf"):
            time.sleep(0.1) # Wait for write to finish
            self.viewer.reload_doc()
            self.viewer.draw_viewport()

# --- Socket Server for Neovim ---
def socket_server(viewer):
    if os.path.exists(SOCKET_PATH):
        os.remove(SOCKET_PATH)
    
    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.bind(SOCKET_PATH)
    server.listen(1)
    
    while True:
        conn, _ = server.accept()
        try:
            data = conn.recv(1024)
            if data:
                cmd = json.loads(data.decode('utf-8'))
                if cmd['action'] == 'sync':
                    viewer.sync_to_line(cmd['line'], cmd['file'])
        except Exception as e:
            pass
        finally:
            conn.close()

# --- Main Entry Point ---
def main(args):
    if len(args) < 2:
        print("Usage: kpdf <file.pdf>")
        return

    pdf_path = os.path.abspath(args[1])
    viewer = PDFViewer(pdf_path)

    # 1. Start File Watcher
    observer = Observer()
    observer.schedule(ReloadHandler(viewer), path=os.path.dirname(pdf_path), recursive=False)
    observer.start()

    # 2. Start Socket Server
    t_sock = threading.Thread(target=socket_server, args=(viewer,), daemon=True)
    t_sock.start()

    # 3. Interactive Loop (Raw mode handling would go here)
    # For this prototype, we'll use a simple blocking input or just 
    # rely on Kitty's kitten keyboard handler if we were fully integrating.
    # To make this script standalone runnable:
    
    import tty, termios
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    
    try:
        tty.setraw(sys.stdin.fileno())
        viewer.draw_viewport()
        
        while True:
            ch = sys.stdin.read(1)
            if ch == 'q': break
            elif ch == 'j': viewer.scroll(50) # Scroll down
            elif ch == 'k': viewer.scroll(-50) # Scroll up
            elif ch == 'r': 
                viewer.reload_doc()
                viewer.draw_viewport()
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        observer.stop()
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)
        clear_screen()

if __name__ == "__main__":
    main(sys.argv)