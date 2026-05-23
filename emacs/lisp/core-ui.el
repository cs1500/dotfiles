;; === core-ui.el ===
;; controls how emacs looks

;; font settings
(add-to-list 'default-frame-alist '(font . "Fira Code-11"))

;; remove scroll bars
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))

;; further cosmetic tweaks
(setq frame-title-format nil) ;; no title in window bar
(setq use-dialog-box nil) ;; no gui pop ups
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; set built in wombat dark theme
(load-theme 'wombat t)

;; disable all sounds
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

;; show absolute line numbering
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-width 3) ;; reserve spacing for up to three digits
(setq display-line-numbers-grow-only t)
(global-display-line-numbers-mode 1)

;; red cursor
(setq-default cursor-type 'box)
(setq evil-normal-state-cursor '(box "red")
      evil-insert-state-cursor '(bar "red")
      evil-visual-state-cursor '(hollow "red"))

;; 80 column block ruler, no line glyph inside
(setq-default fill-column 80)
(setq-default display-fill-column-indicator-column 80)
(setq-default display-fill-column-indicator-character ?\s)
(global-display-fill-column-indicator-mode 1)
(set-face-background 'fill-column-indicator "gray25")
(set-face-foreground 'fill-column-indicator "gray25")

;; line scrolling
(setq scroll-step 1) ;; scroll one line at a time
(setq scroll-conservatively 10000) ;; do not recenter window
(setq scroll-margin 3) ;; keep three lines above/below cursor aways
(setq auto-window-vscroll nil) ;; reduces jumps when scrolling
(pixel-scroll-precision-mode 1) ;; precise pixel scrolling
(setq pixel-scroll-precision-use-momentum nil) ;; no momentum in scrolling
