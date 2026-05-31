;; === init.el ===
;; load configurations
;; all elpa external packages are installed from apt
(add-to-list 'load-path (locate-user-emacs-file "lisp/"))
(load "core-evil" t) ;; core-editing depends on this
(load "core-ui" t) ;; ui settings
(load "core-dashboard" t)
(load "core-editing" t) ;; editor settings
(load "core-pdf-tools" t)
(load "core-auctex" t)
(load "core-lsp" t)
(load "core-magit")