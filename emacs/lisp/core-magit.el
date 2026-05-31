;; === core-magit.el ===

(require 'magit)
(global-set-key (kbd "C-x g") #'magit-status)
(provide 'core-magit)

;; --- overleaf settings ---
;; after open .git folder always pull from git repo

;; push to repo upon save (C-c C-c)

;; dashboard shortcut to clone overleaf repo