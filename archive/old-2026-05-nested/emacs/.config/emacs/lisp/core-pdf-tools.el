;; pdf-tools for document reading
(require 'pdf-tools)

;; performance and rendering tweaks
(setq pdf-view-use-scaling t) ;; instant zoom (requires emacs 27 or later)
(setq pdf-view-use-imagemagick nil) ;; use native rendering (faster)
(setq pdf-cache-image-limit 300) ;; cache more pages
(setq pdf-cache-prefetch-delay 0.1) ;; render next page in background

;; set pdf-tools to be default for .pdf
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
;;(setq-default pdf-view-display-size 'fit-page)
(setq-default pdf-view-display-size 'fit-width)

;; live reload
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(setq global-auto-revert-non-file-buffers t)

;; get pdf-tools to be evil
(with-eval-after-load 'pdf-view
    (evil-set-initial-state 'pdf-view-mode 'normal)
    (evil-define-key 'normal pdf-view-mode-map
        ;; j and k moves half page
        (kbd "j") #'pdf-view-scroll-up-or-next-page
        (kbd "k") #'pdf-view-scroll-down-or-previous-page

        ;; h and l moves entire page
        (kbd "h") #'pdf-view-previous-page-command
        (kbd "l") #'pdf-view-next-page-command

        ;; some other vim like motions
        (kbd "gg") #'pdf-view-first-page
        (kbd "G") #'pdf-view-last-page
        (kbd "=") #'pdf-view-enlarge
        (kbd "-") #'pdf-view-shrink
        (kbd "w") #'pdf-view-fit-width-to-window))

;; hide cursor in this mode
(add-hook 'pdf-view-mode-hook
    (lambda ()
        (pdf-sync-minor-mode 1)
        (setq-local cursor-type nil)
        (setq-local evil-normal-state-cursor '(nil))))