(setq viper-mode t          ;; must be set BEFORE require
      viper-expert-level 5) ;; optional: fewer prompts
(require 'viper)

;; -----------------------------------------------------------------------------
;; vim keybinds
;; -----------------------------------------------------------------------------
;; implement gg keystroke
(with-eval-after-load 'viper
    (define-key viper-vi-global-user-map "gg"
        (lambda ()
            (interactive)
            (goto-char (point-min))
        )
    )
)

;; mass yank
(with-eval-after-load 'viper
  ;; Yank selection (visual) like Vim: copy region, exit visual, clear mark.
  (defun my/viper-visual-yank ()
    (interactive)
    (if (region-active-p)
        (progn
          (copy-region-as-kill (region-beginning) (region-end))
          ;; exit any visual/selection state
          (when (boundp 'viper-visual-mode) (setq viper-visual-mode nil))
          (deactivate-mark t)
          (when (fboundp 'viper-update-cursor) (viper-update-cursor))
          (message "Yanked selection"))
      (message "No active selection")))

  ;; Bind `y` in visual mode if its map exists…
  (when (boundp 'viper-visual-mode-map)
    (define-key viper-visual-mode-map "y" #'my/viper-visual-yank))

  ;; …and add a safety fallback in normal (vi) mode:
  ;; if a region is active, `y` yanks it; otherwise do nothing special.
  (define-key viper-vi-global-user-map "y"
    (lambda ()
      (interactive)
      (when (region-active-p)
        (my/viper-visual-yank)))))

;; mass delete
(with-eval-after-load 'viper
  ;; Delete selected region (visual delete)
  (defun my/viper-visual-delete ()
    "Delete the current visual selection and exit visual mode."
    (interactive)
    (if (region-active-p)
        (progn
          (kill-region (region-beginning) (region-end))  ;; cut text into kill-ring
          (when (boundp 'viper-visual-mode) (setq viper-visual-mode nil))
          (deactivate-mark t)
          (when (fboundp 'viper-update-cursor) (viper-update-cursor))
          (message "Deleted selection"))
      (message "No active selection")))

  ;; Bind `d` in visual mode map, if available
  (when (boundp 'viper-visual-mode-map)
    (define-key viper-visual-mode-map "d" #'my/viper-visual-delete))

  ;; Also, as a fallback, make normal-mode `d` delete the region if active
  (define-key viper-vi-global-user-map "d"
    (lambda ()
      (interactive)
      (if (region-active-p)
          (my/viper-visual-delete)
        (message "No active selection")))))

;; --- Vim-like shifting for Viper: >> and << by 4 spaces ---
(defvar my/vim-shift-width 4
  "Columns to shift for >> and <<.")

(defun my/shift-lines (beg end cols)
  "Shift whole lines covering [beg,end) by COLS columns."
  (let ((rbeg (save-excursion (goto-char beg) (line-beginning-position)))
        (rend (save-excursion (goto-char end) (line-end-position))))
    (indent-rigidly rbeg rend cols)))

(defun my/viper-shift-right ()
  "Shift current line or active region right by `my/vim-shift-width`."
  (interactive)
  (if (use-region-p)
      (progn
        (my/shift-lines (region-beginning) (region-end) my/vim-shift-width)
        ;; keep selection if you were in a visual-like selection
        (when (boundp 'viper-visual-mode)
          (setq deactivate-mark nil)))
    (my/shift-lines (line-beginning-position) (line-end-position) my/vim-shift-width)))

(defun my/viper-shift-left ()
  "Shift current line or active region left by `my/vim-shift-width`."
  (interactive)
  (if (use-region-p)
      (progn
        (my/shift-lines (region-beginning) (region-end) (- my/vim-shift-width))
        (when (boundp 'viper-visual-mode)
          (setq deactivate-mark nil)))
    (my/shift-lines (line-beginning-position) (line-end-position) (- my/vim-shift-width))))

(with-eval-after-load 'viper
  ;; Normal (vi) mode: >> and <<
  (define-key viper-vi-global-user-map ">>" #'my/viper-shift-right)
  (define-key viper-vi-global-user-map "<<" #'my/viper-shift-left)
  ;; Visual-like behavior: > and < to shift selection
  (when (boundp 'viper-visual-mode-map)
    (define-key viper-visual-mode-map ">" #'my/viper-shift-right)
    (define-key viper-visual-mode-map "<" #'my/viper-shift-left)))

;; dired stuff
;; Put Dired in vi-state
(setq viper-emacs-state-mode-list (delq 'dired-mode viper-emacs-state-mode-list))
(add-to-list 'viper-vi-state-mode-list 'dired-mode)
(add-hook 'dired-mode-hook #'viper-change-state-to-vi)(setq TeX-parse-self t) ; Parse file for macros and environments
;; Allow Dired to handle RET (unbind Viper's grab)
(with-eval-after-load 'viper
  (define-key viper-vi-global-user-map (kbd "RET") nil)
  (define-key viper-vi-global-user-map (kbd "<return>") nil))

(with-eval-after-load 'viper
  (define-key viper-vi-global-user-map "v" 'set-mark-command))

;; Dired: open in-place
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
  (let ((map dired-mode-map))
    (define-key map (kbd "RET") #'dired-find-alternate-file)
    (define-key map (kbd "<return>") #'dired-find-alternate-file)
    (define-key map (kbd "l") #'dired-find-alternate-file)
    (define-key map (kbd "^")
      (lambda () (interactive) (find-alternate-file "..")))))
(setq dired-kill-when-opening-new-dired-buffer t)

;; Never treat single-click as "follow link" in Dired
(setq mouse-1-click-follows-link nil)

;; Dired: open directories/files in the SAME window/buffer
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
  ;; Single-click opens in the same window & reuses buffer
  (define-key dired-mode-map [mouse-1] #'dired-find-alternate-file)
  ;; (Optional) also remap middle-click and RET
  (define-key dired-mode-map [mouse-2] #'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)
  ;; Go up one dir in the same buffer
  (define-key dired-mode-map (kbd "^")
    (lambda () (interactive) (find-alternate-file ".."))))

;; Kill old Dired buffers when you open a new directory (keeps buffer list tidy)
(setq dired-kill-when-opening-new-dired-buffer t)

;; --- Silent latexmk: no buffers, no messages --------------------
(defun my/viper-latex-compile ()
  "Save and compile current TeX file with latexmk silently into ./build."
  (interactive)
  (when (buffer-file-name)
    (save-buffer)
    (let* ((file      (buffer-file-name))
           (dir       (file-name-directory file))
           (build-dir (expand-file-name "build" dir)))
      ;; Make sure ./build exists
      (unless (file-directory-p build-dir)
        (make-directory build-dir t))
      (let* ((cmd (format
                   "latexmk -pdf -interaction=nonstopmode -outdir=%s %s >/dev/null 2>&1"
                   (shell-quote-argument build-dir)
                   (shell-quote-argument file))))
        ;; Run quietly in background; no *compilation* buffer
        (let ((process-connection-type nil))    ; use pipe, not pty
          (start-process "latexmk-silent" nil "sh" "-c" cmd))))))

;; Keep your existing requires and hooks
(require 'tex-mode)
(add-hook 'latex-mode-hook
          (lambda ()
            (define-key viper-vi-local-user-map (kbd "C-c C-c") #'my/viper-latex-compile)
            (local-set-key (kbd "C-c C-c") #'my/viper-latex-compile)))
  
(add-hook 'latex-mode-hook
          (lambda ()
            (electric-indent-local-mode -1)))