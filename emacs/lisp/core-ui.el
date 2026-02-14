;; remove scroll bars
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))

;; further cosmetic tweaks
(setq frame-title-format nil)        ;; no title in window bar
(setq use-dialog-box nil)            ;; no GUI pop-ups
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; smooth scrolling
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      scroll-step 1
      scroll-margin 0
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(2 ((shift) . 1)))

;; set a built-in theme
(load-theme 'wombat t)

;; disable all sounds
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

;; --- Visual 80-column guide ----------------------------------
;(setq-default fill-column 80)  ; set the limit itself

;(defun my/enable-fill-column-indicator ()
;  "Enable a subtle fill column indicator at column 80."
;  (setq display-fill-column-indicator-column 80)
;  ;; Choose your favorite symbol (╎, │, ·, or nil for default)
;  (setq display-fill-column-indicator-character ?╎)
;  (display-fill-column-indicator-mode 1))

;(add-hook 'text-mode-hook #'my/enable-fill-column-indicator)
;(add-hook 'prog-mode-hook #'my/enable-fill-column-indicator)
;(add-hook 'latex-mode-hook #'my/enable-fill-column-indicator)

;; global default
(setq-default fill-column 80)

;; use a thin guide instead of a harsh bar
(global-display-fill-column-indicator-mode 1)