;; === early-init.el ===

;; --- startup performance ---
;; set garbage collection to 64mb (default is 800kb)
(setq gc-cons-threshold (* 64 1024 1024))

;; increases maximum per chunk read size to 4mb (from 4kb)
(setq read-process-output-max (* 4 1024 1024))

;; --- frame and ui ---
;; disable gui elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tab-bar-mode -1)

;; launch maximised, windowed fullscreen, placed here for speed
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; --- package startup ---
;; do not load packages before init.el
(setq package-enable-at-startup nil)

;; disable package archives
(setq package-archives nil)
