;; === core-lsp.el ===
;; language server settings
;; latex lsp is managed separately in `core-auctex.el` instead

(require 'corfu) ;; completion ui
(require 'corfu-popupinfo)
(require 'eglot)

;; --- general eglot configuration ---
(setq eglot-sync-connect nil) ;; do not freeze editor when loading lsp!
(setq eglot-connect-timeout 5) ;; fail faster if the server is stuck
(setq eglot-autoshutdown t) ;; shut down unused servers
(setq eglot-send-changes-idle-time 1.0) ;; wait a second before updating lsp
(setq read-process-output-max (* 1024 1024)) ;; better lsp throughput
;; allow emacs to read bigger blocks from lsp, which may improve performance

;; --- general corfu configuration ---
(setq corfu-auto t) ;; show completions automatically
(setq corfu-auto-prefix 1)  ;; start completing immediately
(setq corfu-auto-delay 0.1) ;; popup delay in seconds
(setq corfu-quit-no-match t) ;; close popup when there is no match
(setq corfu-cycle t) ;; wrap around completion list
(global-corfu-mode 1) ;; enable corfu completion globally

;; popup documentation settings
;; M-n to scroll down ("next"), M-p to scroll up ("previous")
(setq corfu-popupinfo-delay '(0.1 . 0.1)) ;; docs popup timing
;; wait 0.1s before showing documentation
;; wait 0.1s before updating after selection changes
(setq corfu-popupinfo-max-width 60) ;; docs popup size
(setq corfu-popupinfo-max-height 25)
(add-hook 'corfu-mode-hook #'corfu-popupinfo-mode) ;; enable docs popup
(with-eval-after-load 'corfu ;; keybinds
    (define-key corfu-map (kbd "M-d") #'corfu-popupinfo-toggle)
    (define-key corfu-map (kbd "M-p") #'corfu-popupinfo-scroll-down)
    (define-key corfu-map (kbd "M-n") #'corfu-popupinfo-scroll-up))

;; --- python configuration ---
;; use jedi
(setq-default eglot-workspace-configuration
    '(:pylsp
        (:plugins
            (:jedi_completion (:enabled t)
             :jedi_hover (:enabled t)
             :jedi_signature_help (:enabled t)
             :rope_completion (:enabled nil))))) ;; disable rope

;; point to anaconda installation
(with-eval-after-load 'eglot
    (add-to-list
        'eglot-server-programs
        '((python-mode python-ts-mode)
            . ("/home/cs/anaconda3/bin/python" "-m" "pylsp"))))

;; ensure eglot starts in python mode
(defun python-lsp-mode-setup ()
    (eglot-ensure))
(add-hook 'python-mode-hook #'python-lsp-mode-setup)
(add-hook 'python-ts-mode-hook #'python-lsp-mode-setup)