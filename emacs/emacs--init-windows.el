;;
;; -> requires
;;
(require 'package)
(require 'org)
(require 'dired-x)

;;
;; -> package-archives
;;
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("elpa" . "https://elpa.gnu.org/packages/")
                          ("org" . "https://orgmode.org/elpa/")))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(setq load-prefer-newer t)

;;
;; -> windows specific
;;
(setq home-dir "c:/users/jimbo")
(let ((xPaths
        '("c:/GnuWin32/bin"
           "c:/GNAT/2021/bin")))
  (setenv "PATH" (mapconcat 'identity xPaths ";"))
  (setq exec-path (append xPaths (list "." exec-directory))))

;;
;; -> use-package
;;
(use-package i3wm-config-mode)
(use-package git-timemachine)
(use-package ox-gfm)
(use-package gnuplot)
(use-package ahk-mode)
(use-package embark-consult)
(use-package lorem-ipsum)
(use-package find-file-rg)
(use-package gruvbox-theme)
(use-package ef-themes)
(use-package doom-themes)
(use-package dwim-shell-command)

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-rainbow-tags
  :hook
  (org-mode . org-rainbow-tags-mode)
  :config
  (setq org-rainbow-tags-mode 1))

(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

(use-package embark
  :bind
  ("C-c ," . embark-act))

(use-package deadgrep
  :custom
  (deadgrep-max-buffers 1))

;;
;; -> completion
;;
(use-package vertico
  :custom
  (vertico-cycle t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  (vertico-resize nil)
  (vertico-count 10)
  :init
  (vertico-mode))

(use-package orderless
  :init
  (setq completion-styles '(basic orderless)
    completion-category-defaults nil
    completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators
    '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;;
;; -> navigation
;;
(defvar my-jump-keymap (make-sparse-keymap))
(define-key my-jump-keymap (kbd "e") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))
(define-key my-jump-keymap (kbd "j") (lambda () (interactive) (find-file "~")))
(define-key my-jump-keymap (kbd "n") (lambda () (interactive) (find-file "\\captainflasmr\Drive")))
(define-key my-jump-keymap (kbd "o") (lambda () (interactive) (find-file "~/.emacs.d/emacs--init.org")))
(define-key my-jump-keymap (kbd "C-q") 'quoted-insert)
(global-set-key (kbd "C-q") my-jump-keymap)

;;
;; -> unbinding
;;
(use-package diff-mode
  :hook
  (diff-mode . (lambda ()
                 (define-key diff-mode-map (kbd "M-0") nil)
                 (define-key diff-mode-map (kbd "M-1") nil)
                 (define-key diff-mode-map (kbd "M-2") nil)
                 (define-key diff-mode-map (kbd "M-3") nil)
                 (define-key diff-mode-map (kbd "M-4") nil))))

;;
;; -> save-desktop
;;
(setq desktop-save t
  desktop-restore-eager t
  desktop-lazy-idle-delay 1
  desktop-lazy-verbose nil
  desktop-files-not-to-save "^$"
  desktop-auto-save-timeout 30)
(push '(foreground-color . :never) frameset-filter-alist)
(push '(background-color . :never) frameset-filter-alist)
(push '(font . :never) frameset-filter-alist)
(push '(cursor-color . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)
(push '(ns-appearance . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)

(desktop-save-mode -1)

;;
;; -> expansion
;;
(setq-default abbrev-mode t)

(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list
  '(try-complete-file-name-partially try-complete-file-name
     try-expand-all-abbrevs try-expand-dabbrev
     try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill
     try-complete-lisp-symbol-partially try-complete-lisp-symbol))

;;
;; -> keybinding
;;
;;  (global-set-key (kbd "C-x v =") 'vc-ediff)
(global-set-key (kbd "M-H") 'mark-paragraph)
(global-set-key (kbd "M-=") 'count-words)
(define-key minibuffer-local-map (kbd "C-c e") 'embark-collect)
(global-set-key (kbd "C-M-S") 'consult-outline)
(bind-key* (kbd "M-g i") 'imenu)
(global-set-key (kbd "M-\'") 'indent-region)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c j") 'winner-undo)
(global-set-key (kbd "C-c k") 'winner-redo)
(bind-key* (kbd "M-j") (lambda()(interactive)(next-line (/ (window-height) 8))))
(bind-key* (kbd "M-k") (lambda()(interactive)(previous-line (/ (window-height) 8))))
;; (bind-key* (kbd "M-n") (lambda()(interactive)(next-line (/ (window-height) 6))))
;; (bind-key* (kbd "M-p") (lambda()(interactive)(previous-line (/ (window-height) 6))))
(bind-key* (kbd "M-l") (lambda()(interactive)(select-window (next-window (selected-window)))))
(bind-key* (kbd "M-h") (lambda()(interactive)(select-window (previous-window (selected-window)))))
(bind-key* (kbd "M-i") (lambda ()(interactive)(my/resize-window 4 t)))
(bind-key* (kbd "M-u") (lambda ()(interactive)(my/resize-window -4 t)))
(global-set-key (kbd "C-c b") (lambda ()(interactive)(async-shell-command "do_backup home" "*backup*")))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c f") 'my/fold)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x j") 'previous-buffer)
(global-set-key (kbd "C-x k") 'next-buffer)
(global-set-key (kbd "C-x l") 'scroll-lock-mode)
(global-set-key (kbd "C-x t") 'customize-themes)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-;") 'my/comment-or-uncomment)
(global-set-key (kbd "S-<f1>") 'font-lock-mode)
(global-set-key (kbd "<f1>") 'display-line-numbers-mode)
(global-set-key (kbd "<f2>") 'whitespace-mode)
(global-set-key (kbd "<f3>") 'variable-pitch-mode)
(global-set-key (kbd "<f6>") 'find-file-rg)
(global-set-key (kbd "<f7>") 'display-fill-column-indicator-mode)
(global-set-key (kbd "M-?") 'my/grep)
(define-key dired-mode-map (kbd "C") 'my/rsync)
(define-key dired-mode-map (kbd "C-c r") 'my/image-dired-sort)
(define-key dired-mode-map (kbd "C-c d") 'my/dired-duplicate-file)
(global-unset-key (kbd "C-z"))

;;
;; -> inserts
;;
(global-set-key (kbd "C-c i d") (lambda ()
                                  (interactive)
                                  (insert (format-time-string "<%Y-%m-%d>"))))
(global-set-key (kbd "C-c i t") (lambda ()
                                  (interactive)
                                  (insert (format-time-string "%Y%m%d%H%M%S"))))

(define-key prog-mode-map (kbd "C-c i b") 'my/insert-uniq-log-word)

;;
;; -> modes
;;
;;
;; -> modes
;;
(global-font-lock-mode 1)
(savehist-mode 1)
(global-ede-mode t)
(global-prettify-symbols-mode t)
(auto-fill-mode -1)
(blink-cursor-mode -1)
(column-number-mode 1)
(global-auto-revert-mode 1)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled -1)
(show-paren-mode 1)
(setq tooltip-mode nil)
(transient-mark-mode 1)
(winner-mode 1)
;; (pixel-scroll-precision-mode 1)
(repeat-mode -1)

;;
;; -> bell
;;
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; -> setqs
;;
(setq dired-guess-shell-alist-user
  '(("\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" "gthumb")
     ("\\.\\(mp4\\|mkv\\|avi\\|mov\\|wmv\\|flv\\|mpg\\)$" "mpv")
     ("\\.\\(mp3\\|wav\\|ogg\\|\\)$" "mpv")
     ("\\.\\(kra\\)$" "org.kde.krita")
     ("\\.\\(odt\\|ods\\)$" "libreoffice")
     ("\\.\\(html\\|htm\\)$" "firefox")
     ("\\.\\(pdf\\|epub\\)$" "okular")))
(setq dired-dwim-target t)
(setq dired-listing-switches "-alGgh")
(setq fit-window-to-buffer-horizontally t)
(setq case-fold-search t)
(setq custom-safe-themes t)
(setq dired-auto-revert-buffer t)
(setq eshell-scroll-to-bottom-on-input 'this)
(setq tramp-default-method "ssh")
(setq enable-local-variables :all)
(setq proced-auto-update-interval 1)
(setq isearch-lazy-count t)
(setq shr-max-image-proportion 0.5)
(setq shr-max-width 80)
(setq shr-width 70)
(setq truncate-partial-width-windows t)
(setq tooltip-hide-delay 0)
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
(setq kill-buffer-query-functions nil)
(setq use-dialog-box nil)
(setq switch-to-buffer-obey-display-actions t)
(setq ediff-split-window-function 'split-window-horizontally)
(setq disabled-command-function nil)
(setq auto-revert-use-notify nil)
(setq auto-revert-verbose nil)
(setq create-lockfiles nil)
(setq use-short-answers t)
(setq delete-by-moving-to-trash t)
(setq european-calendar-style t)
(setq esup-depth 0)
(setq frame-inhibit-implied-resize t)
(setq global-auto-revert-non-file-buffers t)
(setq grep-command "grep -ni ")
(setq kill-whole-line t)
(setq large-file-warning-threshold nil)
(setq reb-re-syntax 'string)
(setq truncate-lines t)
(setq suggest-key-bindings nil)
(setq diary-file "~/DCIM/content/diary.org")

;;
;; -> confirm
;;
(setq dired-clean-confirm-killing-deleted-buffers nil)
(setq dired-confirm-shell-command nil)
(setq dired-no-confirm t)
(setq dired-recursive-deletes (quote always))
(setq dired-deletion-confirmer '(lambda (x) t))
(setq dired-recursive-deletes 'always)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'y-or-n-p)
(setq confirm-kill-processes nil)
(setq confirm-nonexistent-file-or-buffer nil)
(set-buffer-modified-p nil)

;;
;; -> backups
;;
(setq make-backup-files 1)
(setq backup-directory-alist '(("." . "~/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t          ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 10   ; how many of the newest versions to keep
  kept-old-versions 5)    ; and how many of the old

;;
;; -> hooks
;;
(add-hook 'before-save-hook 'time-stamp)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'calendar-mode-hook 'diary-mark-entries)
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
(add-hook 'proced-mode-hook 'proced-settings)

;;
;; -> custom-settings
;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(case-fold-search t)
  '(connection-local-criteria-alist
     '(((:application eshell)
         eshell-connection-default-profile)) t)
  '(connection-local-profile-alist
     '((eshell-connection-default-profile
         (eshell-path-env-list))) t)
  '(custom-enabled-themes '(doom-outrun-electric))
  '(custom-safe-themes t)
  '(delete-selection-mode nil)
  '(eshell-banner-message "")
  '(eshell-directory-name "~/DCIM/Backup/eshell")
  '(fit-window-to-buffer-horizontally t)
  '(warning-suppress-log-types '((frameset)))
  '(warning-suppress-types '((frameset))))

;;
;; -> defuns
;;
(defun proced-settings()
  (proced-toggle-auto-update 1))

(defun my/resize-window (delta &optional horizontal)
  "Resize window back and forth."
  (interactive)
  (let ((edge (if horizontal
                (car (window-edges))
                (car (cdr (window-edges))))))
    (if (= edge 0)
      (enlarge-window delta horizontal)
      (shrink-window delta horizontal))))

(defun save-macro (name)
  "Save a macro."
  (interactive "SName of the macro: ")
  (kmacro-name-last-macro name)
  (find-file user-init-file)
  (goto-char (point-max))
  (newline)
  (insert-kbd-macro name)
  (newline))

(defun my/rsync (dest)
  "Rsync copy."
  (interactive
    (list
      (expand-file-name (read-file-name "rsync to:"
                          (dired-dwim-target-directory)))))
  (let ((files (dired-get-marked-files nil current-prefix-arg))
         (command "rsync -arvz --progress --no-g "))
    (dolist (file files)
      (setq command (concat command (shell-quote-argument file) " ")))
    (setq command (concat command (shell-quote-argument dest)))
    (async-shell-command command "*rsync*")
    (other-window 1)))

(defun my/comment-or-uncomment ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
    (comment-or-uncomment-region
      (region-beginning)(region-end))
    (comment-or-uncomment-region
      (line-beginning-position)(line-end-position))))

(defun my/fold ()
  "Fold text indented same of more than the cursor."
  (interactive)
  (if (eq selective-display (1+ (current-column)))
    (set-selective-display 0)
    (set-selective-display (1+ (current-column)))))

(defun my/grep (arg)
  "Wrapper to grep."
  (interactive "p")
  (print arg)
  (let ((search-term
          (if (equal major-mode 'dired-mode)
            (read-from-minibuffer "Search : ")
            (read-from-minibuffer "Search : " (thing-at-point 'symbol)))))
    (if (= arg 1)
      (deadgrep search-term default-directory)
      (progn
        (setq current-prefix-arg nil)
        (deadgrep search-term "~")))))

(defun my/dired-duplicate-file (arg)
  "Duplicate a file from dired with an incremented number.
  If ARG is provided, it sets the counter."
  (interactive "p")
  (let* ((file (dired-get-file-for-visit))
          (dir (file-name-directory file))
          (name (file-name-nondirectory file))
          (base-name (file-name-sans-extension name))
          (extension (file-name-extension name t))
          (counter (if arg (prefix-numeric-value arg) 1))
          (new-file))
    (while (and (setq new-file
                  (format "%s%s_%03d%s" dir base-name counter extension))
             (file-exists-p new-file))
      (setq counter (1+ counter)))
    (if (file-directory-p file)
      (copy-directory file new-file)
      (copy-file file new-file))
    (dired-revert)))

;;
;; -> window-positioning
;;
(add-to-list 'display-buffer-alist
  '("\\*\\(?:Async\\|xref\\)"
     display-buffer-no-window
     (inhibit-same-window . t)))

(add-to-list 'display-buffer-alist
  '("\\*eshell\\*"
     display-buffer-in-direction
     (direction . bottom)
     (window . root)
     (window-height . 0.4)))

;; (add-to-list 'display-buffer-alist
;;   `(,right-repl-regexp
;;      display-buffer-reuse-window))

;;
;; -> skeletons
;;
(define-skeleton jd-skel-hugo-image-size
  "Org properties skeleton."
  "\n"
  "#+attr_org: :width 300px\n"
  "#+attr_html: :width 100%")

(define-skeleton jd-skel-hugo-image-emacs-banner
  "Org properties skeleton."
  "\n"
  "#+attr_org: :width 300px\n"
  "#+attr_html: :class emacs-img")

(define-skeleton jd-skel-hugo-video
  "Video hugo link."
  "\n"
  "\n#+begin_export md\n"
  "{{\< video src=\"\/art--videos\/\" \>}}"
  "\n#+end_export\n")

(define-skeleton jd-skel-make-always
  "Always make targets in a Makefile."
  "\n"
  "MAKEFLAGS += --always-make")

(define-skeleton jd-skel-make-source
  "Always make targets in a Makefile."
  "\n"
  "%.adb %.ads:\n"
  "\tgprbuild -c $@ -P default.gpr")

(define-abbrev-table 'global-abbrev-table
  '(("jdimg" "" jd-skel-hugo-image-size)
     ("jdvid" "" jd-skel-hugo-video)
     ("jdemb" "" jd-skel-hugo-image-emacs-banner)
     ("jdmka" "" jd-skel-make-always)
     ("jdmks" "" jd-skel-make-source)
     ("btw" "by the way" nil)))

;;
;; -> org
;;
(use-package org
  :config
  (setq org-src-tab-acts-natively t ;; commenting better in org src blocks
    org-src-preserve-indentation nil
    org-hide-leading-stars t
    org-tags-sort-function 'org-string-collate-greaterp
    org-export-with-sub-superscripts nil
    org-hugo-base-dir "~/DCIM"
    org-image-actual-width (list 50)
    org-startup-indented t
    org-todo-keywords
    '((sequence "TODO" "DOIN" "WAIT" "ORDR" "SENT" "|" "CANCELLED" "DONE"))
    org-todo-keyword-faces
    '(("TODO" . "#ee5566")
       ("DOIN" . "#5577aa")
       ("WAIT" . "#bb7744")
       ("ORDR" . "#bb44ee")
       ("SENT" . "#bb44ee")
       ("CANCELLED" . "#426b3e")
       ("DONE" . "#77aa66"))
    org-cycle-separator-lines 2)
  :bind
  (:map org-mode-map
    ("M-n" . org-metadown)
    ("M-p" . org-metaup)))

;;
;; -> scroll
;;
(setq scroll-margin 20)
(setq scroll-preserve-screen-position t)

;;
;; -> font
;;
;; (setq font-general "Noto Sans Mono 14")
;; (setq font-general "MesloLGS Nerd Font Mono 12")
;; (setq font-general "Source Code Pro 14")
;; (setq font-general "Nimbus Mono PS 14")
;; (setq font-general "MesloLGS Nerd Font Mono 14")
(setq font-general "Monospace 14")
;; (setq font-general "Hack Nerd Font Mono 14")

(set-frame-font font-general nil t)

;; the set-frame-font doesn't seem to work in server / client mode
(add-to-list 'default-frame-alist `(font . ,font-general))

;;
;; -> custom-set-faces
;;
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(cursor ((t (:background "#ffffff" :inverse-video t))))
  '(ediff-current-diff-A ((t (:extend t :background "#b5daeb" :foreground "#000000"))))
  '(ediff-even-diff-A ((t (:background "#bafbba" :foreground "#000000" :extend t))))
  '(ediff-fine-diff-A ((t (:background "#f4bd92" :foreground "#000000" :extend t))))
  '(ediff-odd-diff-A ((t (:background "#b8fbb8" :foreground "#000000" :extend t))))
  '(elfeed-search-title-face ((t (:foreground "#4E4E4E" :height 1.2 :family "Source Code Pro"))))
  '(fixed-pitch ((t (:family "Source Code Pro" :height 130))))
  '(org-block ((t (:inherit fixed-pitch))))
  '(org-code ((t (:inherit (shadow fixed-pitch)))))
  '(org-date ((t (:inherit fixed-pitch))))
  '(org-document-info ((t (:foreground "dark orange"))))
  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
  '(org-link ((t (:foreground "royal blue" :underline t))))
  '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  '(org-property-value ((t (:inherit fixed-pitch))) t)
  '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
  '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
  '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  '(variable-pitch ((t (:family "Source Sans Pro" :height 140))))
  '(vertical-border ((t (:foreground "#666666"))))
  '(whitespace-missing-newline-at-eof ((t (:foreground "#888888888888"))))
  '(whitespace-newline ((t (:foreground "#888888888888"))))
  '(whitespace-space ((t (:foreground "#888888888888"))))
  '(whitespace-space-after-tab ((t (:foreground "#888888888888"))))
  '(whitespace-space-before-tab ((t (:foreground "#888888888888"))))
  '(whitespace-tab ((t (:foreground "#888888888888"))))
  '(whitespace-trailing ((t (:foreground "#888888888888"))))
  '(ztreep-diff-model-add-face ((t (:foreground "#e38d5a"))))
  '(ztreep-diff-model-diff-face ((t (:foreground "#7cb0f2")))))

;;
;; -> visuals
;;
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq frame-title-format "%f")
(setq inhibit-startup-screen t)

(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook '(lambda () (visual-line-mode)))
(setq truncate-partial-width-windows 140)
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))
(set-fringe-mode '(10 . 10))
(set-display-table-slot standard-display-table 0 ?\ )

(setq window-divider-default-bottom-width 6)
(setq window-divider-default-right-width 6)
(setq window-divider-default-places t)

(window-divider-mode -1)

(setq-default left-margin-width 1 right-margin-width 1)

;;
;; -> imenu
;;
(defun my-imenu-create-index ()
  "Create an index using definitions starting with ';; ->'."
  (let ((index-alist '())
         (regex "^;;[[:space:]]->\\(.+\\)$"))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward regex nil t)
        (let ((name (s-trim (match-string 1)))
               (pos (match-beginning 0)))
          (push (cons name (set-marker (make-marker) pos)) index-alist))))
    (setq imenu--index-alist (sort
                               index-alist
                               (lambda (a b)
                                 (string< (car a) (car b)))))))

;; (setq imenu-create-index-function #'my-imenu-create-index)

(add-hook 'emacs-lisp-mode-hook
  (lambda ()
    (setq imenu-sort-function 'imenu--sort-by-name)
    (setq imenu-generic-expression
      '((nil "^;;[[:space:]]+-> \\(.*\\)$" 1)
         ("defun" "^.*([[:space:]]*defun[[:space:]]+\\([[:word:]-/]+\\)" 1)
         ("use-package" "^.*([[:space:]]*use-package[[:space:]]+\\([[:word:]-]+\\)" 1)))
    (imenu-add-menubar-index)))

(add-hook 'conf-space-mode-hook
  (lambda ()
    (setq imenu-sort-function 'imenu--sort-by-name)
    (setq imenu-generic-expression
      '((nil "^#[[:space:]]+-> \\(.*\\)$" 1)))
    (imenu-add-menubar-index)))

;;
;; -> recentf
;;
(recentf-mode 1)

(setq recentf-max-menu-items 200)
(setq recentf-max-saved-items 200)
(global-set-key (kbd "C-x m") 'consult-recent-file)

;;
;; -> modeline
;;
(setq-default mode-line-modified
  '(:eval (if (and (buffer-file-name) (buffer-modified-p))
            (propertize " * Modified " 'face
              '(:background "#ff0000" :foreground "#ffffff")) "")))

;; (set-face-attribute 'mode-line-active nil :height 130 :underline nil :overline nil :box nil
;;   :background "#afb4bc" :foreground "#000000")
;; (set-face-attribute 'mode-line-inactive nil :height 130 :underline nil :overline nil
;;   :background "#3c4a5d" :foreground "#323232")

(setq-default mode-line-format
  '("%e"
     mode-line-modified
     (:eval
       (propertize (format "%s" (abbreviate-file-name default-directory))
         'face '(:inherit bold))
       )
     (:eval
       (if (not (equal major-mode 'dired-mode))
         (propertize (format "%s " (buffer-name))
           'face '(:inherit bold))
         " "))
     mode-line-position
     mode-line-modes
     "-%-"))

;;
;; -> find
;;
(setq find-dired-refine-function 'find-dired-sort-by-filename)
(setq find-dired-refine-function 'nil)
(setq find-ls-option (cons "-exec ls -lSh {} +" "-lSh"))

;;
;; -> grep
;;
(require 'grep)

(eval-after-load 'grep
  '(progn
     (dolist (dir '("nas" ".cache" "cache" "elpa" "chromium"
                     ".local/share" "syncthing" ".mozilla" ".local/lib" "Games"
                     ".wine" ".thunderbird" ".gnupg"))
       (push dir grep-find-ignored-directories))
     (dolist (file '(".cache" "*cache*" "*.iso" "*.xmp" "*.jpg" "*.mp4" "*.dll" "*.mp3"))
       (push file grep-find-ignored-files))))

(setq-default deadgrep--search-case 'ignore)

(defun deadgrep--arguments (search-term search-type case context)
  "Return a list of command line arguments that we can execute in a shell
      to obtain ripgrep results."
  (let (args)
    (push "--color=ansi" args)
    (push "--line-number" args)
    (push "--no-heading" args)
    (push "--no-column" args)
    (push "--with-filename" args)
    (push "--no-config" args)
    ;; (push "--no-ignore" args)
    (push "--no-ignore-vcs" args)

    (cond
      ((eq search-type 'string)
        (push "--fixed-strings" args))
      ((eq search-type 'words)
        (push "--fixed-strings" args)
        (push "--word-regexp" args))
      ((eq search-type 'regexp))
      (t
        (error "Unknown search type: %s" search-type)))

    (cond
      ((eq case 'smart)
        (push "--smart-case" args))
      ((eq case 'sensitive)
        (push "--case-sensitive" args))
      ((eq case 'ignore)
        (push "--ignore-case" args))
      (t
        (error "Unknown case: %s" case)))

    (cond
      ((eq deadgrep--file-type 'all))
      ((eq (car-safe deadgrep--file-type) 'type)
        (push (format "--type=%s" (cdr deadgrep--file-type)) args))
      ((eq (car-safe deadgrep--file-type) 'glob)
        (push (format "--type-add=custom:%s" (cdr deadgrep--file-type)) args)
        (push "--type=custom" args))
      (t
        (error "Unknown file-type: %S" deadgrep--file-type)))

    (when context
      (push (format "--before-context=%s" (car context)) args)
      (push (format "--after-context=%s" (cdr context)) args))

    (push "--" args)
    (push search-term args)
    (push "." args)

    (nreverse args)))

;;
;; -> spelling
;;
(use-package jinx
  :config
  (dolist (hook '(text-mode-hook org-mode-hook))
    (add-hook hook #'jinx-mode)))

(use-package powerthesaurus)

(global-set-key (kbd "M-(")
  (lambda () (interactive)
    ;; (backward-word)
    (jinx-correct)
    (forward-word)))

(global-set-key (kbd "M-)") 'dictionary-lookup-definition)
(global-set-key (kbd "M-*") 'powerthesaurus-lookup-synonyms-dwim)

(setq ispell-local-dictionary "en_GB")
(setq ispell-program-name "hunspell")
(setq dictionary-default-dictionary "*")
(setq dictionary-server "dict.org")
(setq dictionary-use-single-buffer t)

;;
;; -> auto-mode-alist
;;
(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))
(add-to-list 'auto-mode-alist '("config.rasi\\'" . js-json-mode))
(add-to-list 'auto-mode-alist '("theme.rasi\\'" . css-mode))
(add-to-list 'auto-mode-alist '("waybar/config\\'" . js-json-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.gpr\\'" . gpr-ts-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode))
(add-to-list 'auto-mode-alist '("CMakeLists.txt\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))
(add-to-list 'auto-mode-alist '("/sway/.*config.*/" . i3wm-config-mode))
(add-to-list 'auto-mode-alist '("/sway/config\\'" . i3wm-config-mode))
(cl-loop for ext in '("\\.gpr$" "\\.ada$" "\\.ads$" "\\.adb$")
  do (add-to-list 'auto-mode-alist (cons ext 'ada-mode)))

;;
;; -> programming
;;
(use-package eglot
  :hook
  (ada-mode . eglot-ensure)
  (c++-mode . eglot-ensure))

(use-package company
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.05)
  :hook (prog-mode . company-mode))

(use-package yaml-mode)
(use-package qml-mode)

(add-hook 'yaml-mode-hook
  '(lambda ()
     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(setq eldoc-echo-area-use-multiline-p nil)

(defvar my/uniq-log-word "poop")

(defun my/insert-uniq-log-word (prefix)
  "Inserts my/uniq-log-word' incrementing counter."
  (interactive "P")
  (let* ((word
           (cond
             (prefix
               (setq my/uniq-log-word (read-string "Log word: ")))
             ((region-active-p)
               (setq my/uniq-log-word
                 (buffer-substring (region-beginning)
                   (region-end))))
             (my/uniq-log-word my/uniq-log-word)
             (t "Reached")))
          (config
            (cond
              ((equal major-mode 'sh-mode)
                (cons
                  (format "echo \"%s: \\([0-9]+\\)\"" word)
                  (format "echo \"%s: %%s\"" word)))
              ((equal major-mode 'emacs-lisp-mode)
                (cons
                  (format "(message \"%s: \\([0-9]+\\)\")" word)
                  (format "(message \"%s: %%s\")" word)))
              ((equal major-mode 'swift-mode)
                (cons
                  (format "print(\"%s: \\([0-9]+\\)\")" word)
                  (format "print(\"%s: %%s\")" word)))
              ((equal major-mode 'ada-mode)
                (cons
                  (format "Ada.Text_Io.Put_Line (\"%s: \\([0-9]+\\)\");" word)
                  (format "Ada.Text_Io.Put_Line (\"%s: %%s\");" word)))
              ((equal major-mode 'c++-mode)
                (cons
                  (format "std::cout << \"%s: \\([0-9]+\\)\" << std::endl;" word)
                  (format "std::cout << \"%s: %%s\" << std::endl;" word)))
              ((equal major-mode 'c-mode)
                (cons
                  (format "fprintf(stderr, \"%s: \\([0-9]+\\)\");" word)
                  (format "fprintf(stderr, \"%s: %%s\");" word)))
              (t
                (error "%s not supported" major-mode))))
          (match-regexp (car config))
          (format-string (cdr config))
          (max-num 0)
          (case-fold-search nil))

    (when my/uniq-log-word
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward match-regexp nil t)
          (when (> (string-to-number (match-string 1)) max-num)
            (setq max-num (string-to-number (match-string 1)))))))

    (unless (looking-at-p "^ *$")(end-of-line))

    (insert (concat
              (if (looking-at-p "^ *$") "" "\n")
              (format format-string
                (if my/uniq-log-word
                  (number-to-string (1+ max-num))
                  (string-trim
                    (shell-command-to-string
                      "grep -E '^[a-z]{6}$' /usr/share/dict/words | shuf -n 1")
                    )))))

    (call-interactively 'indent-for-tab-command)))

(global-set-key (kbd "C-c C-j") 'my/insert-uniq-log-word)

;;
;; -> diff
;;
(use-package ztree)

(setq-default ztree-diff-filter-list
  '(
     "build" "\.dll" "\.iso" "\.xmp" "\.cache" "\.gnupg" "\.local"
     "\.mozilla" "\.thunderbird" "\.wine" "\.mp3" "\.mp4" "\.arpack"
     "\.git" "^Volume$" "^Games$" "^cache$" "^chromium$" "^elpa$" "^nas$"
     "^syncthing$" "bin"
     ))

;; (setq-default ztree-diff-additional-options '("-w" "-i"))
(setq-default ztree-diff-consider-file-size t)
(setq-default ztree-diff-consider-file-permissions nil)
(setq-default ztree-diff-show-equal-files nil)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-prepare-buffer-hook #'org-show-all)
(setq-default ediff-highlight-all-diffs t)

;;
;; -> whitespace
;;
;; Define the whitespace style.
(setq-default whitespace-style
  '(face spaces empty tabs newline trailing space-mark tab-mark
     newline-mark tab-width indentation::space))

;; Whitespace color corrections.
(require 'color)
(let* ((ws-lighten 20) ;; Amount in percentage to lighten up black.
        (ws-color (color-lighten-name "#555555" ws-lighten)))
  (custom-set-faces
    `(whitespace-newline                ((t (:foreground ,ws-color))))
    `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
    `(whitespace-space                  ((t (:foreground ,ws-color))))
    `(whitespace-space-after-tab        ((t (:foreground ,ws-color))))
    `(whitespace-space-before-tab       ((t (:foreground ,ws-color))))
    `(whitespace-tab                    ((t (:foreground ,ws-color))))
    `(whitespace-trailing               ((t (:foreground ,ws-color))))))

;; Make these characters represent whitespace.
(setq-default whitespace-display-mappings
  '(
     ;; space -> Â· else .
     (space-mark 32 [183] [46])
     ;; new line -> Â¬ else $
     (newline-mark ?\n [172 ?\n] [36 ?\n])
     ;; carriage return (Windows) -> Â¶ else #
     (newline-mark ?\r [182] [35])
     ;; tabs -> Â» else >
     (tab-mark ?\t [187 ?\t] [62 ?\t])))

;; Don't enable whitespace for.
(setq-default whitespace-global-modes
  '(not shell-mode
     help-mode
     magit-mode
     magit-diff-mode
     ibuffer-mode
     dired-mode
     occur-mode))

;; Set whitespace actions.
(setq-default whitespace-action
  '(cleanup auto-cleanup))

;;
;; -> dashboard
;;
(setq dashboard-projects-backend 'project-el)
(setq dashboard-projects-switch-function (lambda (dir) (dired dir)))

(use-package dashboard
  :ensure t
  :hook
  (dashboard-after-initialize . (lambda ()
                                  (dashboard-jump-to-recents)))
  :config
  (setq dashboard-banner-logo-title "Welcome James!")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents . 20)
                           (projects . 10)
                           (bookmarks . 5)
                           (agenda . 5)
                           (registers . 5)))
  (setq dashboard-set-init-info t)
  (setq dashboard-set-footer nil)
  (setq dashboard-center-content t)
  (dashboard-insert-startupify-lists)
  (dashboard-setup-startup-hook))

;;
;; -> indentation
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq-default lisp-indent-offset 2)
(add-hook 'sh-mode-hook
  (lambda () (setq sh-basic-offset 3)))

;;
;; -> colour-shift
;;
(defun colour-shift (delta type)
  "Shift the hex text value colour by the desired delta for the defined type"
  (save-excursion
    ;; find the colour in the form #ff4400
    (forward-word)
    (search-backward-regexp "#\\([[:xdigit:]]\\{6\\}\\)" nil t)
    (setq str (match-string-no-properties 1))
    (setq hsl (color-rgb-to-hsl
                (/ (float
                     (string-to-number
                       (substring-no-properties str 0 2) 16)) (float 255))
                (/ (float
                     (string-to-number
                       (substring-no-properties str 2 4) 16)) (float 255))
                (/ (float
                     (string-to-number
                       (substring-no-properties str 4 6) 16)) (float 255))))
    (cond
      ((= type 1) ;; value
        (setq hslmod
          (list (nth 0 hsl) (nth 1 hsl) (+ (nth 2 hsl) delta))))
      ((= type 4) ;; hue C-u
        (setq hslmod
          (list (+ (nth 0 hsl) delta) (nth 1 hsl) (nth 2 hsl))))
      ((= type 16) ;; saturation C-u C-u
        (setq hslmod
          (list (nth 0 hsl) (+ (nth 1 hsl) delta) (nth 2 hsl) delta)))
      ((= type 64) ;; random C-u C-u C-u
        (setq hslmod
          (list (/ (random 256) 255.0) (/ (random 256) 255.0) (/ (random 256) 255.0))))
      (t ;; value
        (setq hslmod
          (list (nth 0 hsl) (nth 1 hsl) (+ (nth 2 hsl) delta)))))

    ;; normalise hsl values
    (setq hslmod (mapcar (lambda (x) (if (> x 1.0) 1.0 (if (< x 0.0) 0.0 x))) hslmod))
    ;; convert back to hex
    (setq rgb
      (color-hsl-to-rgb (nth 0 hslmod) (nth 1 hslmod) (nth 2 hslmod)))
    (setq hex
      (substring-no-properties(color-rgb-to-hex (nth 0 rgb) (nth 1 rgb) (nth 2 rgb) 2) 1))
    (replace-match (format "%06x" (string-to-number hex 16)) nil nil nil 1)))

(define-minor-mode colour-shift-mode
  "Toggle colour-shift minor mode."
  :init-value nil
  :lighter " CS"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "M-<home>") (lambda () (interactive) (colour-shift 0.005 64)))
            (define-key map (kbd "M-<prior>") (lambda () (interactive) (colour-shift 0.005 16)))
            (define-key map (kbd "M-<next>") (lambda () (interactive) (colour-shift -0.005 16)))
            (define-key map (kbd "M-<up>") (lambda () (interactive) (colour-shift 0.005 1)))
            (define-key map (kbd "M-<down>") (lambda () (interactive) (colour-shift -0.005 1)))
            (define-key map (kbd "M-<left>") (lambda () (interactive) (colour-shift -0.005 4)))
            (define-key map (kbd "M-<right>") (lambda () (interactive) (colour-shift 0.005 4)))
            map))

(defun activate-colour-shift-mode ()
  "Activate colour-shift-mode if rainbow-mode is active."
  (if rainbow-mode
    (colour-shift-mode 1)
    (colour-shift-mode -1)))

(add-hook 'rainbow-mode-hook 'activate-colour-shift-mode)

;;
;; -> development
;;
(defun my/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                    default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-c w") 'my/copy-file-name-to-clipboard)

(use-package org
  :hook (org-mode . org-indent-mode)
  :config
  (setq org-indent-indentation-per-level 2)
  (setq org-edit-src-content-indentation 0)
  (setq org-src-preserve-indentation t))

(use-package eshell
  :after xterm-color
  :config
  (setq eshell-scroll-to-bottom-on-input t)
  (define-key eshell-mode-map (kbd "<tab>") #'company-complete)
  (define-key eshell-hist-mode-map (kbd "M-r") #'consult-history)
  (add-hook 'eshell-mode-hook
    (lambda ()
      (setenv "TERM" "xterm-256color")))
  (add-hook 'eshell-before-prompt-hook (setq xterm-color-preserve-properties t))
  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
  (setq eshell-output-filter-functions
    (remove 'eshell-handle-ansi-color eshell-output-filter-functions)))
