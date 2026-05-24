;; === core-dashboard.el ===
;; emacs startup page settings

(require 'dashboard)
(require 'recentf)
(recentf-mode 1)

;; --- dashboard customisations ---
(setq inhibit-startup-screen t) ;; disable default emacs startup screen
(setq initial-buffer-choice ;; set emacs to always start dashboard
    (lambda () (get-buffer-create "*dashboard*")))
(setq dashboard-items '((recents  . 10) ;; show 10 recent files, and etc
                        (bookmarks . 10)))
(dashboard-setup-startup-hook)
;;(with-eval-after-load 'dashboard ;; get dashboard to always reload
;;  (add-hook 'dashboard-mode-hook #'dashboard-refresh-buffer)) ;; PROBLEMATIC!

;; evil snap j/k to dashboard entries
(with-eval-after-load 'evil
  (with-eval-after-load 'dashboard
    (evil-define-key 'normal dashboard-mode-map
      (kbd "j") #'widget-forward
      (kbd "k") #'widget-backward)))

;; --- latex template ---
;; creates entry in dashboard to make new latex document from a template
(defvar latex-default-dir "~/Sync/Projects/academic/")
(defvar latex-template-dir "~/.config/emacs/templates/latex-notes/")
    
(defun copy-src-files (src dst)
  "Copy from `src' directory to `dst' directory."
  (make-directory dst t) ;; create destination directory
  (dolist (entry (directory-files src t directory-files-no-dot-files-regexp))
    ;; loop over every file in `src' directory, ignoring dotfiles
    ;; `t' means to return full paths, not just filenames
    (let* ((name (file-name-nondirectory entry)) ;; file name of `entry'
           (target (expand-file-name name dst)) ;; destination path
           (real-entry (file-truename entry))) ;; true resolved path of `entry'
      ;; `let*' here creates local variables sequentially to be used later
      ;; e.g. if `src' folder has one file named `t.py', then we have:
      ;; `entry' = `/home/...<src>.../t.py'
      ;; `name' = `t.py'
      ;; `target' = `/home/...<dst>.../t.py'
      ;; `real-entry' = `/home/...<no-symlink-src>.../t.py'
      ;; the `real-entry' is important when the `entry' file in the `src'
      ;; directory is a symlink, but we want to copy the original file

      ;; if else block
      (cond ((file-directory-p real-entry) ;; if `real-entry' is a directory
             (copy-src-files real-entry target)) ;; recursively copy contents
            (t ;; otherwise copy file to `dst'
             (copy-file real-entry target nil t t t))))))

(defun new-latex-folder ()
  "Create new latex folder from a premade template folder."
  (interactive) ;; this function can be called with M-x
  (let* ((root-dir (file-name-as-directory
                    (expand-file-name latex-default-dir)))
         (temp-dir (file-name-as-directory
                    (expand-file-name latex-template-dir)))
         (targ-dir (file-name-as-directory ;; prompt for tex directory
                    (read-directory-name
                     "New LaTeX folder: "
                     root-dir
                     nil
                     nil)))
         (main-dir (expand-file-name "main.tex" targ-dir)))
    (unless (file-directory-p temp-dir)
      (user-error "Template directory does not exist: %s" temp-dir))
    (make-directory root-dir t)
    (when (file-exists-p targ-dir)
      (user-error "Directory already exists: %s" targ-dir))
    (make-directory targ-dir t)
    (copy-src-files temp-dir targ-dir)
    (find-file main-dir)))

(with-eval-after-load 'dashboard
  (add-to-list 'dashboard-item-generators
               '(latex-template . dashboard-insert-tex-template))
  (defun dashboard-insert-tex-template (_list-size)
    (dashboard-insert-heading "Templates:")
    (insert "\n    ") ;; additional spaces to match standard dashboard
    (widget-create 'push-button
                   :tag "LaTeX project"
                   :action (lambda (&rest _)
                             (new-latex-folder)))
    (insert "\n"))
  (add-to-list 'dashboard-items '(latex-template) t))
