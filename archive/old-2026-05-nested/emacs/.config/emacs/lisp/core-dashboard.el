;; board
(require 'dashboard)
(require 'recentf)
(recentf-mode 1)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
(setq dashboard-items '((recents  . 10)
                        (bookmarks . 5)
                        (projects  . 5)))
(dashboard-setup-startup-hook)

;; evil snap j/k to dashboard entries
(with-eval-after-load 'evil
    (with-eval-after-load 'dashboard
        (evil-define-key 'normal dashboard-mode-map (kbd "j") 'widget-forward)
        (evil-define-key 'normal dashboard-mode-map (kbd "k") 'widget-backward)))