;; === core-auctex.el ===
;; auctex installed through apt, and is automatically loaded

;; --- global setup: runs once ---
(with-eval-after-load 'tex
    (setq TeX-parse-self t) ;; parse document automatically after opening
    (setq TeX-auto-save t) ;; then save information into cache
    (setq TeX-output-dir "build") ;; generated pdf folder
    (setq TeX-debug-warnings t)
    (setq TeX-debug-bad-boxes t)

    (defun save-all-before-tex-command (&rest _)
        "Save all modified file buffers before running an AUCTeX command."
        (save-some-buffers t))

    (advice-add 'TeX-command-master :before #'save-all-before-tex-command)

    ;; add new command `latex-build`
    (add-to-list
        'TeX-command-list
        (list
            "latex-build"
            (concat
                "latexmk -pdf -bibtex -cd " ;; bibtex citations
                "-shell-escape " ;; for minted package
                "-interaction=nonstopmode " ;; compile even with errors
                "-file-line-error -synctex=1 "
                "-outdir=build %t")
            'TeX-run-TeX
            nil t
            :help "Run latexmk with build directory")))

;; --- lsp setup for latex ---
;; eglot with texlab
(with-eval-after-load 'eglot
    ;; ensure all latex modes use texlab...
    (add-to-list 'eglot-server-programs
        '((latex-mode LaTeX-mode tex-mode) . ("texlab"))))

;; --- local buffer setup ---
(defun latex-mode-setup ()
    (display-line-numbers-mode -1) ;; no line numbers
    (display-fill-column-indicator-mode -1) ;; no vertical ruler
    (setq-local fill-column 80) ;; 80 characters per line preferred
    (auto-fill-mode 1) ;; wrap after preferred text width

    ;;(TeX-PDF-mode 1) ;; ISSUE: auctex thinks pdf is postscript?
    (setq-local TeX-PDF-mode t) ;; proposed fix

    (TeX-source-correlate-mode 1)
    (setq-local TeX-command-default "latex-build")
    (eglot-ensure))
(add-hook 'LaTeX-mode-hook #'latex-mode-setup)
