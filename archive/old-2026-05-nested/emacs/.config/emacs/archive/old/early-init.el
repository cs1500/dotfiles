;; -----------------------------------------------------------------------------
;; faster startup
;; -----------------------------------------------------------------------------
(setq
    ;; set garbage collection to 64mb (default is 800kb)
    gc-cons-threshold (* 64 1024 1024)

    ;; increases maximum per chunk read size to 4mb (from 4kb)
    read-process-output-max (* 4 1024 1024)
)

;; disable gui elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tab-bar-mode -1)

;; launch maximised, windowed fullscreen, placed here for speed
(add-to-list 'default-frame-alist '(fullscreen . maximized))