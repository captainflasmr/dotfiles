;;
;; -> early-init
;;

(setq package-enable-at-startup t)

;; avaid default theme flash of light when starting up
(setq mode-line-format nil)
(set-face-attribute 'default nil :background "#222222" :foreground "#ffffff")
(set-face-attribute 'mode-line nil :background "#222222" :foreground "#ffffff" :box 'unspecified)
