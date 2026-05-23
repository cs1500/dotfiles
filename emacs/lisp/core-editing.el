;; === core-editing.el ===
;; controls how emacs behaves

;; --- general editor settings ---
(electric-pair-mode 1) ;; autocomplete stuff like `(` with `)`

;; tab settings
(setq-default indent-tabs-mode nil ;; spaces instead of tabs
              tab-width 4)
(setq tab-always-indent t)
(setq-default backward-delete-char-untabify-method 'hungry) ;; delete all spaces

;; --- dired settings ---
;; file management with C-c C-f
;; the following ensures mouse clicks mirror keyboard behaviour
(with-eval-after-load 'dired
  (define-key dired-mode-map [mouse-2] #'dired-mouse-find-file)
  (define-key dired-mode-map [mouse-1] #'dired-mouse-find-file))

(add-hook 'dired-mode-hook
          (lambda ()
            (evil-define-key 'normal dired-mode-map
              (kbd "j") #'dired-next-line
              (kbd "k") #'dired-previous-line)))

;; sort hidden folders first
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil) ;; stop using external `ls`
(setq ls-lisp-dirs-first t) ;; sort folders first
(setq ls-lisp-ignore-case t) ;; ignore uppercase and sort alphabetically
(setq ls-lisp-use-string-collate nil) ;; strict character sorting
;; so that the dired `.` and `..` always appear on top

;; --- window manager motions ---
;; move between windows using alt + hjkl
(global-set-key (kbd "M-h") #'windmove-left)
(global-set-key (kbd "M-j") #'windmove-down)
(global-set-key (kbd "M-k") #'windmove-up)
(global-set-key (kbd "M-l") #'windmove-right)

;; split screen using alt + arrowkeys
(global-set-key (kbd "M-<right>")
                (lambda ()
                  (interactive)
                  (split-window-right)
                  (windmove-right)))

(global-set-key (kbd "M-<left>")
                (lambda ()
                  (interactive)
                  (split-window-right)))

(global-set-key (kbd "M-<down>")
                (lambda ()
                  (interactive)
                  (split-window-below)
                  (windmove-down)))

(global-set-key (kbd "M-<up>")
                (lambda ()
                  (interactive)
                  (split-window-below)))

