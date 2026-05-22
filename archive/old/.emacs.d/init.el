(add-to-list 'load-path (locate-user-emacs-file "lisp/"))
(load "core-ui" t)
(load "core-editing" t)

;; built-in packages only
(load "pkg-viper" t)

;===============================================================================
; latex settings
;===============================================================================
; docview autoreload
;(add-hook 'doc-view-mode-hook 'auto-revert-mode)
;; --- DocView: continuous + mouse + vim-style keys -----------------
(with-eval-after-load 'doc-view
  ;; Always continuous + auto-refresh on rebuilds
  (add-hook 'doc-view-mode-hook
            (lambda ()
              (setq-local doc-view-continuous t)
              (auto-revert-mode 1)))

  ;; Make scrolling smooth if available (Emacs 29+)
  (when (fboundp 'pixel-scroll-precision-mode)
    (add-hook 'doc-view-mode-hook #'pixel-scroll-precision-mode))

  ;; Global keybindings for DocView buffers
  (let ((m doc-view-mode-map))
    ;; Mouse wheel / touchpad
    (define-key m (kbd "<wheel-down>") #'doc-view-scroll-up-or-next-page)
    (define-key m (kbd "<wheel-up>")   #'doc-view-scroll-down-or-previous-page)
    ;; Some systems send mouse-4/5 instead of wheel events
    (define-key m (kbd "<mouse-5>")    #'doc-view-scroll-up-or-next-page)
    (define-key m (kbd "<mouse-4>")    #'doc-view-scroll-down-or-previous-page)
    ;; Shift + wheel = page-wise navigation
    (define-key m (kbd "<S-wheel-down>") #'doc-view-next-page)
    (define-key m (kbd "<S-wheel-up>")   #'doc-view-previous-page)

    ;; Vim-style keys
    (define-key m (kbd "j") #'doc-view-scroll-up-or-next-page)
    (define-key m (kbd "k") #'doc-view-scroll-down-or-previous-page)
    (define-key m (kbd "l") #'doc-view-next-page)
    (define-key m (kbd "h") #'doc-view-previous-page)

    ;; Optional: faster page jumps with H/L (shifted)
    (define-key m (kbd "L")
      (lambda () (interactive) (doc-view-next-page 5)))
    (define-key m (kbd "H")
      (lambda () (interactive) (doc-view-previous-page 5)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;