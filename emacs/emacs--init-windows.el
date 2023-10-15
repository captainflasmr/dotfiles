;;
;; -> packages
;;
(setq gc-cons-threshold 100000000)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("elpa" . "https://elpa.gnu.org/packages/")
                          ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-compute-statistics t)
;; and run use-package-report after init.
(setq use-package-always-ensure t)
(setq use-package-verbose t)
(setq warning-minimum-level :emergency)

(require 'dired-x)

;;
;; -> packages (extra)
;;
(use-package fd-find
  :load-path "~/emacs-pkgs/new/fd-find")

;; (add-to-list 'load-path "~/emacs-pkgs/new/fd-find")
;; (require 'fd-find)

;;
;; -> windows specific
;;
(setq home-dir "c:/users/jimbo")
(let ((xPaths
        '(
           "c:/GnuWin32/bin"
           "c:/GNAT/2021/bin"
           )))
  (setenv "PATH" (mapconcat 'identity xPaths ";"))
  (setq exec-path (append xPaths (list "." exec-directory))))

;;
;; -> calendar
;;
(setq calendar-date-display-form
  '((format "%s-%.2d-%.2d" year
      (string-to-number month)
      (string-to-number day))))
(setq calendar-date-style 'iso)
(setq icalendar-export-hidden-diary-entries nil)
(setq icalendar-export-sexp-enumerate-all t)

;;
;; -> use-package one liner
;;
(use-package ahk-mode)
(use-package kbd-mode
  :load-path "~/.config/emacs/elisp/")
(use-package sxhkdrc-mode)
(add-to-list 'auto-mode-alist `(,(rx "sxhkdrc" string-end) . sxhkdrc-mode))
(use-package company)
(use-package ada-mode)
(use-package highlight-indentation)
(use-package yaml-mode)
(use-package toml-mode)
(use-package indent-tools)
(use-package embark-consult)
(use-package lorem-ipsum)
(use-package ztree)
(use-package find-file-rg)
(use-package gruvbox-theme)
(use-package ef-themes)
(use-package doom-themes)
(use-package dwim-shell-command)

;;
;; -> use-package
;;
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

(use-package hydra
  :ensure t ;; only if it's not already installed
  :bind (("C-q" . hydra-jump-to-somewhere/body))
  :config
  (defhydra hydra-jump-to-somewhere
    (:exit t)
    "Jump to somewhere"
    ("a" emms-browse-by-album "albums")
    ("p" emms "playing")
    ("n" (find-file "\\captainflasmr\Drive") "nas")
    ("d" (find-file deft-directory) "content")
    ("j" (find-file home-dir) "home")
    ("e" (find-file (concat home-dir "/.emacs.d/init.el")) ".init.el")
    ("C-q" (quoted-insert 1) "quoted-insert")
    ("q" nil "Quit" :color blue)))

(use-package rainbow-mode
  :ensure t
  :hook (prog-mode . rainbow-mode))

(use-package visual-fill-column
  :config
  (setq-default visual-fill-column-center-text t))

(use-package ox-hugo
  :config
  (setq org-hugo-front-matter-format "yaml")
  )
(use-package embark
  :bind
  ("C-c ," . embark-act))

(use-package deadgrep
  :custom
  (deadgrep-max-buffers 1))

(use-package dired-rainbow
  :defer 0
  :config
  (dired-rainbow-define-chmod directory "#6aa3dc" "d.*")
  (dired-rainbow-define html "#eb5286"
    ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht"
      "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024"
    ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg"
      "pgn" "rss" "yaml" "yml" "rdata" "sln" "csproj"
      "meta" "unity" "tres" "tscn" "import" "godot"))
  (dired-rainbow-define document "#8180f0"
    ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps"
      "rtf" "djvu" "epub" "odp" "ppt" "pptx" "xls" "xlsx"
      "vsd" "vsdx" "plantuml"))
  (dired-rainbow-define markdown "#bbbbbb"
    ("org" "org_archive" "etx" "info" "markdown" "md"
      "mkd" "nfo" "pod" "rst" "tex" "texi" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd"
    ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#b0681f"
    ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv"
      "ogg" "mov" "mid" "midi" "wav" "aiff" "flac" "mkv"))
  (dired-rainbow-define image "#b6688f"
    ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png"
      "psd" "eps" "svg"))
  (dired-rainbow-define shell "#f6993f"
    ("awk" "bash" "bat" "fish" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define compiled "#6cb2eb"
    ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp"
      "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn"
      "f90" "f95" "f03" "f08" "s" "rs" "active" "hs"
      "pyc" "java"))
  (dired-rainbow-define compressed "#b4342f"
    ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar"
      "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar" "rar"))
  (dired-rainbow-define encrypted "#f2d024"
    ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12"
      "pem"))
  (dired-rainbow-define vc "#6cb2eb"
    ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define config "#7260e2"
    ("cfg" "conf"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")

  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (equal major-mode 'dired-mode)
        (font-lock-refresh-defaults)))))

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
  :custom
  (completion-styles '(substring orderless basic))
  :init
  (setq completion-styles '(orderless basic)
    completion-category-defaults nil
    completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;;
;; -> hydra
;;
(use-package hydra
  :ensure t ;; only if it's not already installed
  :bind (("C-q" . hydra-jump-to-somewhere/body))
  :config
  (defhydra hydra-jump-to-somewhere
    (:exit t)
    "Jump to somewhere"
    ("a" emms-browse-by-album "albums")
    ("p" emms "playing")
    ("j" (find-file home-dir) "home")
    ("e" (find-file (concat home-dir "/.emacs.d/init.el")) ".init.el")
    ("C-q" (quoted-insert 1) "quoted-insert")
    ("q" nil "Quit" :color blue)))

;;
;; -> magit
;;
;; (use-package magit
;;   :init
;;   (defhydra hydra-magit (:exit t)
;;     "Magit"
;;     ("s" magit-status "status")
;;     ("c" magit-clone "clone")
;;     ("l" magit-list-repositories "list all")
;;     ("q" nil "quit"))
;;   :bind
;;   ("C-c g" . hydra-magit/body)
;;   :config
;;   (unbind-key "M-1" magit-mode-map)
;;   (unbind-key "M-2" magit-mode-map)
;;   (unbind-key "M-3" magit-mode-map)
;;   (unbind-key "M-4" magit-mode-map)
;;   (magit-add-section-hook
;;     'magit-status-sections-hook 'magit-insert-tracked-files nil 'append)
;;   :custom
;;   (magit-section-initial-visibility-alist (quote ((untracked . hide))))
;;   (magit-repolist-column-flag-alist
;;     '((magit-untracked-files . "N")
;;        (magit-unstaged-files . "U")
;;        (magit-staged-files . "S")))
;;   (magit-repolist-columns
;;     '(
;;        ("Name" 25 magit-repolist-column-ident nil)
;;        ("" 3 magit-repolist-column-flag)
;;        ("Version" 25 magit-repolist-column-version
;;          ((:sort magit-repolist-version<)))
;;        ("B<U" 3 magit-repolist-column-unpulled-from-upstream
;;          ((:right-align t)
;;            (:sort <)))
;;        ("B>U" 3 magit-repolist-column-unpushed-to-upstream
;;          ((:right-align t)
;;            (:sort <)))
;;        ("Path" 99 magit-repolist-column-path nil))
;;     )
;;   (magit-repository-directories
;;     '(
;;        ("/home/jdyer/.config" . 0)
;;        ("/home/jdyer/repos" . 2)
;;        ("/home/jdyer/emacs-pkgs/new" . 2)
;;        ("/home/jdyer/DCIM/Art/Content" . 2)
;;        ("/home/jdyer/DCIM/themes" . 2)
;;        ("/home/jdyer/DCIM/content" . 0)
;;        ("/home/jdyer/publish" . 0)
;;        )
;;     )
;;   )

;;
;; -> emms
;;
(use-package emms
  :init (emms-all)
  :hook
  (emms-browser-mode . turn-on-follow-mode)
  (emms-browser-mode . hl-line-mode)
  :bind
  ("S-<return>" . emms-next)
  ("C-M-<return>" . emms-random)
  :custom
  (emms-player-list '(emms-player-vlc))
  (emms-browser-covers 'emms-browser-cache-thumbnail-async)
  (emms-source-file-default-directory "/home/jdyer/MyMusicLibrary")
  (emms-volume-amixer-card 1)
  (emms-volume-change-function 'emms-volume-pulse-change))

;;
;; -> elfeed
;;
(use-package elfeed
  :bind
  ("C-x w" . elfeed)
  (:map elfeed-search-mode-map
    ("n" . (lambda () (interactive) (next-line) (call-interactively 'elfeed-search-show-entry)))
    ("p" . (lambda () (interactive) (previous-line) (call-interactively 'elfeed-search-show-entry)))
    ("m" . (lambda () (interactive) (apply 'elfeed-search-toggle-all '(star)))))
  :custom
  (elfeed-search-remain-on-entry t)
  (elfeed-search-title-min-width 60)
  (elfeed-search-title-max-width 60)
  (elfeed-search-filter "@2-months-ago")
  (elfeed-feeds
    '("https://www.dyerdwelling.family/index.xml"
       "https://www.emacs.dyerdwelling.family/index.xml"
       "https://www.emacs.dyerdwelling.family/tags/emacs/index.xml"
       "http://emacsninja.com/feed.atom"
       "http://www.omgubuntu.co.uk/feed"
       "http://feeds.feedburner.com/XahsEmacsBlog"
       "https://emacsair.me/feed.xml"
       "https://www.ghacks.net/feed/"
       "https://linuxstoney.com/feed"
       "http://emacsredux.com/atom.xml"
       "https://www.creativebloq.com/feed"
       "https://feeds.howtogeek.com/HowToGeek"
       "http://planet.emacslife.com/atom.xml"
       "http://irreal.org/blog/?feed=rss2"
       "https://itsfoss.com/feed/"
       "https://9to5linux.com/feed/atom"
       "https://opensource.com/feed"
       "http://www.masteringemacs.org/feed/"
       "https://jao.io/blog/rss.xml")))

(setq elfeed-show-mode-hook
  (lambda ()
    (set-face-attribute 'variable-pitch (selected-frame) :font (font-spec :family "Source Code Pro" :size 18))
    (setq elfeed-show-entry-switch #'my-show-elfeed)))

;;
;; -> save-desktop
;;
(desktop-save-mode 1)
(push '(foreground-color . :never) frameset-filter-alist)
(push '(background-color . :never) frameset-filter-alist)
;;(push '(font . :never) frameset-filter-alist)
;; (push '(cursor-color . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)
(push '(ns-appearance . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)

;;
;; -> keybinding
;;
(bind-key* (kbd "C-x C-v") 'revert-buffer)
(bind-key* (kbd "M-S") 'consult-org-heading)
(bind-key* (kbd "M-g i") 'imenu)
(global-set-key (kbd "C-M-'") 'indent-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c d") (lambda()(interactive)(dired deft-directory)))
(global-set-key (kbd "M->") (lambda()(interactive)(end-of-buffer)(recenter)))
(global-set-key (kbd "C-c j") 'winner-undo)
(global-set-key (kbd "C-c k") 'winner-redo)
(global-set-key (kbd "M-<backspace>") (lambda()(interactive)(delete-region (point)(progn (backward-word) (point)))))
(global-set-key (kbd "M-d") (lambda()(interactive)(delete-region (point)(progn (forward-word) (point)))))
(bind-key* (kbd "C-v") (lambda()(interactive)(scroll-up-command)(recenter)))
(bind-key* (kbd "M-v") (lambda()(interactive)(scroll-down-command)(recenter)))
(bind-key* (kbd "M-j") (lambda()(interactive)(next-line (/ (window-height) 12))(recenter)))
(bind-key* (kbd "M-k") (lambda()(interactive)(previous-line (/ (window-height) 12))(recenter)))
(bind-key* (kbd "M-n") (lambda()(interactive)(next-line (/ (window-height) 6))(recenter)))
(bind-key* (kbd "M-p") (lambda()(interactive)(previous-line (/ (window-height) 6))(recenter)))
(bind-key* (kbd "M-l") (lambda()(interactive)(select-window (next-window (selected-window)))))
(bind-key* (kbd "M-h") (lambda()(interactive)(select-window (previous-window (selected-window)))))
(bind-key* (kbd "M-i") '(lambda ()(interactive)(my/resize-window 4 t)))
(bind-key* (kbd "M-u") '(lambda ()(interactive)(my/resize-window -4 t)))
;; (global-set-key (kbd "C-M-n") '(lambda ()(interactive)(my/resize-window 2)))
;; (global-set-key (kbd "C-M-p") '(lambda ()(interactive)(my/resize-window -2)))
(global-set-key (kbd "C-S-<right>") '(lambda ()(interactive)(my/resize-window 4 t)))
(global-set-key (kbd "C-S-<left>") '(lambda ()(interactive)(my/resize-window -4 t)))
(global-set-key (kbd "C-S-<down>") '(lambda ()(interactive)(my/resize-window 2)))
(global-set-key (kbd "C-S-<up>") '(lambda ()(interactive)(my/resize-window -2)))
(global-set-key (kbd "C-c b") '(lambda ()(interactive)(async-shell-command "do_backup home" "*backup*")))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c f") 'my/fold)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-emacs)
(global-set-key (kbd "C-x j") 'previous-buffer)
(global-set-key (kbd "C-x k") 'next-buffer)
(global-set-key (kbd "C-x l") 'scroll-lock-mode)
(global-set-key (kbd "C-x p") 'gud-print)
(global-set-key (kbd "C-x t") 'customize-themes)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-;") 'my/comment-or-uncomment)
(global-set-key [S-f1] 'font-lock-mode)
(global-set-key [f1] 'display-line-numbers-mode)
(global-set-key [f2] 'whitespace-mode)
(global-set-key [f3] 'variable-pitch-mode)
(global-set-key [f4] 'my/eshell)
(global-set-key (kbd "C-`") 'my/eshell)
(global-set-key [f5] 'gud-cont)
;; (global-set-key [f6] 'find-file-vanilla)
(global-set-key [f6] 'find-file-rg)
;;  (global-set-key [f6] 'fd-find-complete)
(global-set-key [f7] 'display-fill-column-indicator-mode)
(global-set-key [f8] 'next-error)
(global-set-key [S-f8] 'find-file-rg-at-point)
(global-set-key [f9] 'gud-break)
(global-set-key [f10] 'gud-next)
(global-set-key [f11] 'gud-step)
(global-set-key [f12] 'xref-find-definitions)
(global-set-key [S-f12] 'my/grep)
(global-set-key (kbd "M-?") 'my/grep)
(global-set-key (kbd "C-c i d") '(lambda () (interactive)(insert (format-time-string "<%Y-%m-%d>"))))
(global-set-key (kbd "C-c i t") '(lambda () (interactive)(insert (format-time-string "%Y%m%d%H%M%S"))))
(define-key dired-mode-map (kbd "C") 'my/rsync)
(define-key dired-mode-map (kbd "?") 'my/get-file-size)
(define-key dired-mode-map (kbd "C-<return>") 'browse-url-of-dired-file)
(define-key dired-mode-map (kbd "C-t d") 'my/image-dired-sort)
(define-key dired-mode-map (kbd "C-c d") 'my/dired-duplicate-file)
(bind-key* (kbd "C-M-SPC") 'window-toggle-side-windows)
(global-unset-key (kbd "C-z"))

;;
;; -> modes
;;
(savehist-mode 1)
(global-ede-mode t)
(global-prettify-symbols-mode t)
(auto-fill-mode -1)
(blink-cursor-mode -1)
(column-number-mode 1)
(display-time-mode 1)
(global-auto-revert-mode 1)
(global-font-lock-mode 1)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(set-fringe-mode '(20 . 20))
(show-paren-mode 1)
(setq tooltip-mode nil)
(transient-mark-mode 1)
(winner-mode 1)
;;(pixel-scroll-precision-mode 1)

;;
;; -> bell
;;
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; -> auto mode alist
;;
(add-to-list 'auto-mode-alist `(,(rx "sxhkdrc" string-end) . sxhkdrc-mode))
(add-to-list 'auto-mode-alist `(,(rx "dunstrc" string-end) . toml-mode))
(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;;
;; -> setqs
;;
(setq dired-guess-shell-alist-user
  '(
     ("\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" "gthumb")
     ("\\.\\(mp4\\|mkv\\|avi\\|mov\\|wmv\\|flv\\|mpg\\)$" "mpv")
     ("\\.\\(mp3\\|wav\\|ogg\\|\\)$" "mpv")
     ("\\.\\(odt\\|ods\\)$" "libreoffice")
     ("\\.\\(html\\|htm\\)$" "firefox")
     ("\\.\\(pdf\\|epub\\)$" "okular")
     ))
(setq dired-dwim-target t)
(setq dired-listing-switches "-alGgh")
(setq dired-auto-revert-buffer t)
(setq wdired-allow-to-change-permissions t)
(setq image-dired-external-viewer "/usr/bin/gwenview")
(setq image-dired-show-all-from-dir-max-files 999)
(setq image-dired-thumbs-per-row 999)
(setq image-dired-thumb-margin 5)
(setq image-dired-thumb-size 10)
(setq image-dired-thumb-height 100)
(setq image-dired-thumb-width 100)
(setq image-dired-thumb-size 100)
(setq eshell-scroll-to-bottom-on-input 'this)
(setq window-persistent-parameters
  '((parent-id . nil)
     (outer-window-id . nil)
     (window-id . nil)
     (clone-of . t)))
(setq debug-on-error t)
(setq tramp-default-method "ssh")
(setq enable-local-variables :all)
(setq proced-auto-update-interval 1)
(setq compilation-always-kill t)
(setq compilation-context-lines 3)
(setq compilation-scroll-output nil)
(setq isearch-lazy-count t)
(setq shr-max-image-proportion 0.5)
(setq shr-max-width 80)
(setq shr-width 70)
(setq truncate-partial-width-windows t)
(setq tooltip-hide-delay 0)
(setq-default fill-column 75)
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
(set-display-table-slot standard-display-table 0 ?\ )
(set-default 'truncate-lines t)
(setq kill-buffer-query-functions nil)
(setq use-dialog-box nil)
(setq deft-directory (concat home-dir "/DCIM/content"))
(setq switch-to-buffer-obey-display-actions t)
(setq ediff-split-window-function 'split-window-horizontally)
(setq disabled-command-function nil)
(setq auto-revert-use-notify nil)
(setq auto-revert-verbose nil)
(setq compilation-skip-threshold 2)
(setq confirm-kill-emacs 'yes-or-no-p)
(setq create-lockfiles nil)
(setq use-short-answers t)
(setq delete-by-moving-to-trash t)
(setq european-calendar-style t)
(setq esup-depth 0)
(setq frame-inhibit-implied-resize t)
(setq gdb-display-io-nopopup 1)
(setq gdb-many-windows t)
(setq global-auto-revert-non-file-buffers t)
(setq grep-command "grep -ni ")
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
;; (setq inhibit-message -1)
(setq kill-whole-line t)
(setq large-file-warning-threshold nil)
(setq reb-re-syntax 'string)
(setq require-final-newline t)
(setq truncate-lines t)
(setq diary-show-holidays-flag nil)
(setq suggest-key-bindings nil)
(setq image-use-external-converter t)
(setq-default display-line-numbers-width 0)
(setq-default abbrev-mode t)
(setq diary-file (concat home-dir "/DCIM/content/diary.org"))
(setq frame-title-format "%f")

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
;; -> indentation
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq-default lisp-indent-offset 2)
(add-hook 'sh-mode-hook
  (lambda () (setq sh-basic-offset 3)))

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
  ;; (add-hook 'dired-mode-hook #'dired-hide-details-mode)
;;  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'calendar-mode-hook 'diary-mark-entries)
  (add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
  (add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
  (add-hook 'proced-mode-hook 'proced-settings)
  ;;  (add-hook 'prog-mode-hook #'hl-line-mode)
  ;;  (add-hook 'text-mode-hook #'hl-line-mode)
  (add-hook 'eshell-mode-hook '(lambda ()(interactive)
                                 (define-key eshell-mode-map
                                   (kbd
                                     "TAB") 'pcomplete-expand-and-complete)))
  (add-hook 'shell-mode-hook '(lambda ()(interactive)
                                (define-key shell-mode-map
                                  (kbd
                                    "TAB") 'pcomplete-expand-and-complete)))

;;
;; -> custom settings
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
 '(custom-enabled-themes '(misterioso))
 '(custom-safe-themes t)
 '(delete-selection-mode nil)
 '(ede-project-directories
    '("/home/jdyer/DCIM/content" "/home/jdyer/nas" "/home/jdyer/examples" "/home/jdyer/bin" "/home/jdyer/DCIM"))
 '(eshell-banner-message "")
 '(eshell-directory-name "~/DCIM/Backup/eshell")
 '(fit-window-to-buffer-horizontally t)
 '(hippie-expand-try-functions-list
    '(try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol))
 '(package-selected-packages
    '(ahk-mode ztree yaml-mode visual-fill-column vertico use-package toml-mode toc-org sxhkdrc-mode rainbow-mode powerthesaurus ox-hugo org-rainbow-tags org-bullets orderless marginalia magit lorem-ipsum jinx indent-tools highlight-indentation gruvbox-theme find-file-rg emms embark-consult elfeed ef-themes dwim-shell-command doom-themes dired-rainbow deadgrep company ada-mode))
 '(warning-suppress-log-types '((frameset)))
 '(warning-suppress-types '((frameset))))

;;
;; -> defuns
;;
(defun my/eshell ()
  "Toggle shell."
  (interactive)
  (if (window-live-p (get-buffer-window "*eshell*"))
    (delete-window (get-buffer-window "*eshell*"))
    (eshell)))

(defun my/org-sort-tags ()
  "On a heading sort the tags."
  (interactive)
  (when (org-at-heading-p)
    (org-set-tags (sort (org-get-tags) #'string<))))

(defun proced-settings()
  (proced-toggle-auto-update 1))

(defun my-show-elfeed (buffer)
  (display-buffer buffer))

(defun my/resize-window (delta &optional horizontal)
  "Resize window back and forth."
  (interactive)
  (let ((edge (if horizontal
                (car (window-edges))
                (car (cdr (window-edges))))))
    (if (= edge 0)
      (enlarge-window delta horizontal)
      (shrink-window delta horizontal))))

(defun my/index ()
  "Generate occur index."
  (interactive)
  (beginning-of-buffer)
  (occur ";;[[:space:]]->"))

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
         (command "rsync -arvz --progress "))
    (dolist (file files)
      (setq command (concat command (shell-quote-argument file) " ")))
    (setq command (concat command (shell-quote-argument dest)))
    (async-shell-command command "*rsync*")
    (other-window 1)))

(defun my/image-dired-sort (arg)
  "Sort images in various ways."
  (interactive "p")
  (cond
    ((equal current-prefix-arg nil)   ; no C-u
      (setq dired-actual-switches "-lGghat"))
    ((equal current-prefix-arg '(4))  ; C-u
      (setq dired-actual-switches "-lGgha"))
    ((equal current-prefix-arg 1)     ; C-u 1
      (setq dired-actual-switches "-lGgha"))
    )
  (setq w (selected-window))
  (delete-other-windows)
  (revert-buffer)
  (image-dired ".")
  (setq idw (selected-window))
  (select-window w)
  (dired-unmark-all-marks)
  (select-window idw)
  (image-dired-display-thumbnail-original-image)
  (image-dired-line-up-dynamic))

(defun my/comment-or-uncomment ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
    (comment-or-uncomment-region
      (region-beginning)(region-end))
    (comment-or-uncomment-region
      (line-beginning-position)(line-end-position))))

(defun my/get-file-size ()
  "Calculate files size for all the marked files."
  (interactive)
  (let ((files (dired-get-marked-files)) command)
    (setq command (concat "du -hc "))
    (dolist (file files)
      (setq command (concat command (shell-quote-argument file) " ")))
    (async-shell-command command "*file size*")))

(defun dired-get-size ()
  "Get total size of Dired."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
        (progn
          (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
          (match-string 1))))))

(defun my/fold ()
  "Fold text indented same of more than the cursor."
  (interactive)
  (if (eq selective-display (1+ (current-column)))
    (set-selective-display 0)
    (set-selective-display (1+ (current-column)))))

(defun my/project-root ()
  "Return project root defined by user."
  (interactive)
  "Guess the project root of the given FILE-PATH."
  (let ((root default-directory)
         (project (project-current)))
    (when project
      (cond ((fboundp 'project-root)
              (setq root (project-root project)))))))

(defun my/grep (arg)
  "Wrapper to grep."
  (interactive "p")
  (let ((search-term
          (if (equal major-mode 'dired-mode)
            (read-from-minibuffer "Search : ")
            (read-from-minibuffer "Search : " (thing-at-point 'symbol)))))
    (if (> arg 1)
      (progn
        (setq current-prefix-arg nil)
        (deadgrep search-term "~")
        )
      (deadgrep search-term default-directory))
    )
  )

;;
;; -> window positioning
;;
(add-to-list 'display-buffer-alist
  `(,(rx(or "elfeed-entry"))
     display-buffer-in-direction
     (direction . right)
     (window . root)
     (window-width . 0.45)))

(add-to-list 'display-buffer-alist
  `(,(rx(or "image-dired"))
     display-buffer-in-direction
     (direction . right)
     (window . root)
     (window-width . 0.75)))

(add-to-list 'display-buffer-alist
  `(,(rx(or "image-dired-display-image"))
     display-buffer-in-direction
     (direction . right)
     (window . root)
     (window-width . 0.4)))

(defvar right-repl-regexp
  (rx bos "*" (or"Occur"
                "deadgrep"
                "dictionary"
                "compilation"
                "Org"
                "Proced")
    (zero-or-more nonl))
  "Regexp for matching the buffer name of terminal or related tools.")

(defvar btm-repl-regexp
  (rx bos "*" (or (and (? "e") "shell")
                (and (? "v") "term")
                "calendar"
                "Grep")
    (zero-or-more nonl))
  "Regexp for matching the buffer name of terminal or related tools.")

(defvar go-away-repl-regexp
  (rx bos "*" (or "Async" "rsync")
    (zero-or-more nonl))
  "Regexp for matching windows to disappear")

(add-to-list 'display-buffer-alist
  `(,go-away-repl-regexp
     display-buffer-no-window
     (inhibit-same-window . t)))

(add-to-list 'display-buffer-alist
  `(,btm-repl-regexp
     display-buffer-in-direction
     (direction . bottom)
     (window-height . 0.2)
     (preserve-size (t . nil))
     (body-function . select-window)))

(add-to-list 'display-buffer-alist
  `(,right-repl-regexp
     display-buffer-in-direction
     (direction . right)
     (window-width . 0.4)
     (preserve-size (t . nil))
     (body-function . select-window)))

(add-to-list 'display-buffer-alist
  `(,right-repl-regexp
     display-buffer-reuse-window))

;;
;; -> skeletons
;;
(define-skeleton hugo-image-size-skel
  "Org properties skeleton."
  "\n"
  "#+attr_org: :width 300px\n"
  "#+attr_html: :width 100%")

(define-skeleton hugo-image-emacs-banner-skel
  "Org properties skeleton."
  "\n"
  "#+attr_org: :width 300px\n"
  "#+attr_html: :class emacs-img")

(define-skeleton hugo-video-skel
  "Video hugo link."
  "\n"
  "\n#+begin_export md\n"
  "{{\< video src=\"\/art--videos\/\" \>}}"
  "\n#+end_export\n")

(define-abbrev-table 'global-abbrev-table
  '(
     ("jdimg" "" hugo-image-size-skel)
     ("jdvid" "" hugo-video-skel)
     ("jdemb" "" hugo-image-emacs-banner-skel)
     ("btw" "by the way" nil)
     )
  )

;;
;; -> org capture
;;
(setq org-capture-templates
  `(
     ("p" "Post" plain
       (file+headline
         ,(concat home-dir "/DCIM/content/posts--all.org")
         "Posts")
       "** TODO %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-posts--%\\1
:EXPORT_HUGO_SECTION: posts
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /posts/%<%Y%m%d%H%M%S>-posts--%\\1.jpg
:END:
#+begin_export md
%?
" :prepend t :jump-to-captured t)

     ("e" "Emacs" plain
       (file+headline
         ,(concat home-dir "/DCIM/content/emacs--all.org")
         "Emacs")
       "** TODO %^{title} :emacs:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-emacs--%\\1
:EXPORT_HUGO_SECTION: emacs
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /emacs/%<%Y%m%d%H%M%S>-emacs--%\\1.jpg
:END:
%?
" :prepend t :jump-to-captured t)

     ("l" "Linux" plain
       (file+headline
         ,(concat home-dir "/DCIM/content/linux--all.org")
         "Linux")
       "** TODO %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-linux--%\\1
:EXPORT_HUGO_SECTION: linux
:EXPORT_HUGO_LASTMOD: %<%Y-%m-%d>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /linux/%<%Y%m%d%H%M%S>-emacs--%\\1.jpg
:END:
%?
" :prepend t :jump-to-captured t)

     ("a" "Art")

     ("av" "Art Videos" plain
       (file+headline
         ,(concat home-dir "/DCIM/content/art--2018-now.org")
         "Art")
       "** TODO %^{title} Video :videos:painter:krita:artrage:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>--%\\1-%\\2
:EXPORT_HUGO_SECTION: art--videos
:EXPORT_HUGO_LASTMOD: %<%Y-%m-%d>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /art--videos/%<%Y%m%d%H%M%S>--%\\1-%\\2.jpg
:VIDEO:
:END:
#+begin_export md
{{< youtube %^{youtube} >}}
#+end_export
%?
" :prepend t :jump-to-captured t)

     ("aa" "Art" plain
       (file+headline
         ,(concat home-dir "/DCIM/content/art--2018-now.org")
         "Art")
       "** TODO %^{title} :painter:krita:artrage:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %\\1
:EXPORT_HUGO_SECTION: art--all
:EXPORT_HUGO_LASTMOD: %<%Y-%m-%d>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /art--all/%\\1.jpg
:VIDEO:
:END:
#+attr_org: :width 300px
#+attr_html: :width 100%
#+begin_export md
#+end_export
%?
" :prepend t :jump-to-captured t)
     )
  )

;;
;; -> org
;;
(setq org-hide-leading-stars t)
(setq org-hide-emphasis-markers t)
(setq org-tags-sort-function 'org-string-collate-greaterp)
(setq org-agenda-include-diary nil)
(setq org-export-with-sub-superscripts nil)
(setq org-hugo-base-dir "~/DCIM")
(setq org-image-actual-width (list 50))
(setq org-startup-indented t)
(setq org-todo-keywords
  '((sequence "TODO" "DOIN" "WAIT" "ORDR" "SENT" "|" "CANCELLED" "DONE")))
(setq org-todo-keyword-faces
  '(("TODO" . "#ee5566")
     ("DOIN" . "#5577aa")
     ("WAIT" . "#bb7744")
     ("ORDR" . "#bb44ee")
     ("SENT" . "#bb44ee")
     ("CANCELLED" . "#426b3e")
     ("DONE" . "#77aa66")))

;;
;; -> dwim
;;
(defvar my/dwim-convert-commands
  '(
     "ConvertNoSpace" "AudioConvert" "AudioInfo" "AudioNormalise"
     "AudioTrimSilence" "PictureAutoColour" "PictureConvert" "PictureCrush"
     "PictureInfo" "PictureMontage" "PictureOrganise" "PictureRotateFlip"
     "PictureRotateLeft" "PictureRotateRight" "PictureScale" "PictureUpscale"
     "PictureGetText" "PictureOrientation" "VideoConcat" "VideoConvert"
     "VideoCut" "VideoDouble" "VideoExtractAudio" "VideoExtractFrames"
     "VideoFilter" "VideoFromFrames" "VideoInfo" "VideoRemoveAudio"
     "VideoReplaceVideoAudio" "VideoRescale" "VideoReverse" "VideoRotate"
     "VideoRotateLeft" "VideoRotateRight" "VideoShrink" "VideoSlowDown"
     "VideoSpeedUp" "VideoZoom" "WhatsAppConvert" "PictureCorrect" "Picture2pdf"
     "OtherTagDate"
     )
  "List of commands for dwim-convert.")

(defun my/dwim-convert-generic (command)
  "Execute a dwim-shell-command-on-marked-files with the given COMMAND."
  (interactive "MCommand: ")
  (dwim-shell-command-on-marked-files
    command
    (format "%s '<<*>>'" command) :silent-success t))

(defun my/dwim-convert-with-selection ()
  "Prompt the user to choose a command and execute dwim-shell-command-on-marked-files."
  (interactive)
  (let ((chosen-command (completing-read "Choose command: " my/dwim-convert-commands)))
    (my/dwim-convert-generic chosen-command)))

(global-set-key (kbd "C-c c") 'my/dwim-convert-with-selection)

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
;; -> custom set-faces
;;
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#ffffff" :inverse-video t))))
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
 '(vertical-border ((t (:foreground "#666666")))))

;;
;; -> visual
;;
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook '(lambda () (visual-line-mode)))
(setq truncate-partial-width-windows 140)
(set-frame-parameter nil 'alpha-background 85)
(add-to-list 'default-frame-alist '(alpha-background . 85))

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
      '(
         (nil "^;;[[:space:]]+-> \\(.*\\)$" 1)
         ("defun" "^.*([[:space:]]*defun[[:space:]]+\\([[:word:]-/]+\\)" 1)
         ("use-package" "^.*([[:space:]]*use-package[[:space:]]+\\([[:word:]-]+\\)" 1)
         )
      )
    (imenu-add-menubar-index)))

(add-hook 'conf-space-mode-hook
  (lambda ()
    (setq imenu-sort-function 'imenu--sort-by-name)
    (setq imenu-generic-expression
      '(
         (nil "^#[[:space:]]+-> \\(.*\\)$" 1)
         )
      )
    (imenu-add-menubar-index)))

;;
;; -> modeline
;;
;; (setq-default mode-line-format
;;   '("%e"
;;      (:eval
;;        (if (and (buffer-file-name) (buffer-modified-p))
;;          (propertize "* Modified "
;;            'face '(:background "#e20023" :foreground "#ffffff"))))
;;      (:eval
;;        (if (buffer-file-name)
;;          (if (mode-line-window-selected-p)
;;            (propertize (format " %s " (abbreviate-file-name (buffer-file-name)))
;;              'face '(:background "#9cc277" :foreground "#000000" :inherit bold))
;;            (format " %s " (abbreviate-file-name (buffer-file-name)))
;;            )
;;          )
;;        )
;;      (:eval
;;        (if (mode-line-window-selected-p)
;;          (propertize " %4l %2c %o %b "
;;            'face '(:background "#b8b8b8" :foreground "#000000"))
;;          " %4l %2c %o %b "))
;;      (:eval
;;        (if (mode-line-window-selected-p)
;;          (propertize (capitalize
;;                        (concat " " (string-trim-right
;;                                      (symbol-name major-mode) "-mode") " "))
;;            'face '(:background "#bf967e" :foreground "#000000" :inherit bold))
;;          (capitalize
;;            (concat " " (string-trim-right
;;                          (symbol-name major-mode) "-mode") " "))))
;;      (:eval
;;        (if (mode-line-window-selected-p)
;;          (propertize "%-"
;;            'face '(:background "#429c52" :foreground "#a8a8a8"))
;;          (propertize "%-"
;;            'face '(:background "#202025" :foreground "#646464"))
;;          )
;;        )
;;      )
;;   )

(set-face-attribute 'mode-line nil :height 130)
(set-face-attribute 'mode-line-inactive nil :height 130)

;;
;; -> spelling
;;
;; (use-package jinx
;;   :hook (emacs-startup . global-jinx-mode)
;;   :bind (("M-$" . my/jinx-correct)))

;; (global-dictionary-tooltip-mode 1)
;; (setq flyspell-issue-message-flag nil)
;; (setq ispell-local-dictionary "en_GB")
;; (setq ispell-program-name "hunspell")
;; (setq dictionary-default-dictionary "*")
;; (setq dictionary-server "dict.org")
;; (setq dictionary-use-single-buffer t)

;; (defun my/jinx-correct ()
;;   "Move to the end of the word after correcting"
;;   (interactive)
;;   (jinx-correct)
;;   (forward-word))

;; (use-package powerthesaurus
;;   :init
;;   (defhydra hydra-powerthesaurus (:exit t)
;;     "Dictionary"
;;     ("s" my/jinx-correct "spell")
;;     ("y" powerthesaurus-lookup-synonyms-dwim "synonyms")
;;     ("a" powerthesaurus-lookup-antonyms-dwim "antonyms")
;;     ("l" dictionary-lookup-definition "lookup")
;;     ("q" nil "quit"))
;;   :bind
;;   ("C-c s" . hydra-powerthesaurus/body))

;;
;; -> hugo processing
;;
(defun my/hugo-org-export-subtree ()
  "Hugo export processing."
  (interactive)
  (org-hugo-export-wim-to-md)
  (shell-command "web rsync emacs")
  )

(global-set-key (kbd "C-c x") #'my/hugo-org-export-subtree)

;;
;; -> development
;;
(defun tab-predicate-exclusion-p (dir)
  "
                Exclusion of directories to convert to spaces."
  (not
    (or
      (string-match "/home/jdyer/DCIM/static" dir)
      (string-match "/home/jdyer/DCIM/Camera" dir)
      )
    )
  )

(defun my/cleanup-files (my/tab-width &optional to-tabs)
  "Cleanup source file formatting."
  (setq-default tab-width my/tab-width)
  (setq-default ada-indent my/tab-width)
  (setq-default c-default-style "linux")
  (setq-default c-basic-offset my/tab-width)

  (if to-tabs
    (setq-default indent-tabs-mode t)
    (setq-default indent-tabs-mode nil))

  (setq-default make-backup-files nil)

  (message all-files nil)
  (setq all-files nil)
  (setq all-files
    (append
      (directory-files-recursively
        "/home/jdyer/DCIM" "\\(?:.cpp$\\|\\.c$\\)" nil 'tab-predicate-exclusion-p)
      (directory-files-recursively
        "/home/jdyer/DCIM" "\\(?:.ads$\\|\\.adb$\\)" nil 'tab-predicate-exclusion-p)
      )
    )
  (message "----------------------------------------")
  (message "\nNow cleaning up (may take some time)...")
  (message "----------------------------------------")

  (dolist (file all-files)
    (message file)
    (with-current-buffer (find-file-noselect file)
      (whitespace-cleanup)

      (if to-tabs
        (tabify (point-min) (point-max))
        (untabify (point-min) (point-max)))

      (font-lock-set-defaults)
      (indent-region (point-min) (point-max))
      (save-buffer)
      (kill-buffer)
      )
    )
  (message (concat "Finished Doing : " (number-to-string (length all-files)) " files!")))

(setq-default mode-line-buffer-identification
  '(:eval
     (propertized-buffer-identification "%b")))

(defun find-file-vanilla ()
  "Simple find file from current directory using the linux find command."
  (interactive)

  ;; (setq find-command "find -type f -printf \"$PWD/%p\\0\"")
  ;; (setq find-command "rg --files --null")
  (setq find-command "fd --absolute-path --type f -0")

  (setq file-list
    (mapcar
      (lambda (path)
        (file-relative-name path default-directory))
      (split-string
        (shell-command-to-string find-command)
        "\0" t)))

  (setq file
    (completing-read
      (format "Find file in %s: " (default-directory))
      file-list))
  (when file (find-file (expand-file-name file default-directory))))

(add-to-list 'auto-mode-alist '("\\.org_archive\\'" . org-mode))

(setq ada-eglot-gpr-file "/home/jdyer/examples/gnat-examples/menace/menace.gpr")

;;
;; —> Pattern exclusions
;;
(defun predicate-exclusion-p (dir)
  "Exclusion of directories."
  (not
    (or
      (string-match "/home/jdyer/examples/CPPrograms/nil" dir)
      )
    )
  )

(defun my/generate-etags ()
  "Generate etags for relevant source code files."
  (interactive)
  ;;
  ;; —> getting the files
  ;;
  (message "Getting file list...")
  (setq all-files nil)
  (setq all-files
    (append
      (directory-files-recursively
        "/home/jdyer/examples" "\\(?:\\.cpp$\\|\\.c$\\|\\.h$\\)" nil 'predicate-exclusion-p)
      (directory-files-recursively
        "/home/jdyer/examples" "\\(?:\\.ads$\\|\\.adb$\\)" nil 'predicate-exclusion-p)
      )
    )

  (dolist (file all-files)
    (shell-command (concat "etags \"" file "\"g --append -o \"/home/jdyer/examples/TAGS\""))
    )
  )

(defun my/dired-duplicate-file (arg)
  "Duplicate the current file in Dired."
  (interactive "p")
  (let ((filename (dired-get-filename)))
    (setq target (concat (file-name-sans-extension filename)
                   "-old"
                   (if (> arg 1) (number-to-string arg))
                   (file-name-extension filename t)))
    (if (file-directory-p filename)
      (copy-directory filename target)
      (copy-file filename target t))
    (revert-buffer)
    )
  )

(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(add-hook 'yaml-mode-hook
  '(lambda ()
     (define-key yaml-mode-map "\C-m" 'newline-and-indent)
     (highlight-indentation-mode)
     ))

;; (global-set-key (kbd "C-c >") 'indent-tools-hydra/body)

;; (set-face-background 'highlight-indentation-face "#e3e3d3")
;; (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

(defvar my/uniq-log-word "poop")

(defun my/insert-uniq-log-word (prefix)
  "Inserts `my/uniq-log-word' incrementing counter.
            With PREFIX, change `my/uniq-log-word'."
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
             (t "Reached")
             )
           )
          (config
            (cond
              ((equal major-mode 'sh-mode)
                (cons (format "echo \"%s: \\([0-9]+\\)\"" word)
                  (format "echo \"%s: %%s\"" word)))
              ((equal major-mode 'emacs-lisp-mode)
                (cons (format "(message \"%s: \\([0-9]+\\)\")" word)
                  (format "(message \"%s: %%s\")" word)))
              ((equal major-mode 'swift-mode)
                (cons (format "print(\"%s: \\([0-9]+\\)\")" word)
                  (format "print(\"%s: %%s\")" word)))
              ((equal major-mode 'ada-mode)
                (cons (format "Ada.Text_Io.Put_Line (\"%s: \\([0-9]+\\)\");" word)
                  (format "Ada.Text_Io.Put_Line (\"%s: %%s\");" word)))
              ((equal major-mode 'c++-mode)
                (cons (format "std::cout << \"%s: \\([0-9]+\\)\" << std::endl;" word)
                  (format "std::cout << \"%s: %%s\" << std::endl;" word)))
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

    (unless (looking-at-p "^ *$")
      (end-of-line))

    (insert (concat
              (if (looking-at-p "^ *$") "" "\n")
              (format format-string
                (if my/uniq-log-word
                  (number-to-string (1+ max-num))
                  (string-trim
                    (shell-command-to-string
                      "grep -E '^[a-z]{6}$' /usr/share/dict/words | shuf -n 1"))))))
    (call-interactively 'indent-for-tab-command)))

(global-set-key (kbd "C-M-j") 'my/insert-uniq-log-word)

(defun test (arg)
  (interactive "p")
  (when (re-search-backward "#\\([[:xdigit:]]\\{6\\}\\)" nil t)
    (let* ((value (string-to-number (match-string 1) 16))
            (new-value
              (if (> arg 1)
                (+ value (string-to-number "010101" 16))
                (- value (string-to-number "010101" 16))
                )))
      (message (number-to-string arg))
      (replace-match (message (format "%06x" new-value)) nil nil nil 1)
      )
    )
  )

(defun colour-shift (delta type)
  (let ((old-pos (point)))
    (forward-word)
    (search-backward-regexp "#\\([[:xdigit:]]\\{6\\}\\)" nil t)
    (setq str (match-string-no-properties 1))
    (setq hsl (color-rgb-to-hsl
                (/ (float (string-to-number (substring-no-properties str 0 2) 16)) (float 255))
                (/ (float (string-to-number (substring-no-properties str 2 4) 16)) (float 255))
                (/ (float (string-to-number (substring-no-properties str 4 6) 16)) (float 255))))
    (cond
      ((= type 1) ;; value
        (setq hslmod (list (nth 0 hsl) (nth 1 hsl) (+ (nth 2 hsl) delta)))
        (setq hslmod (mapcar (lambda (x) (if (> x 1.0) 1.0 (if (< x 0.0) 0.0 x))) hslmod)))
      ((= type 4) ;; saturation
        (setq hslmod (list (nth 0 hsl) (+ (nth 1 hsl) delta) (nth 2 hsl) delta))
        (setq hslmod (mapcar (lambda (x) (if (> x 1.0) 1.0 (if (< x 0.0) 0.0 x))) hslmod)))
      ((= type 16) ;; hue
        (setq hslmod (list (+ (nth 0 hsl) delta) (nth 1 hsl) (nth 2 hsl))))
      ((= type 64) ;; random
        (setq hslmod (list (/ (random 256) 255.0) (/ (random 256) 255.0) (/ (random 256) 255.0)))
        (setq hslmod (mapcar (lambda (x) (if (> x 1.0) 1.0 (if (< x 0.0) 0.0 x))) hslmod)))
      (t ;; value
        (setq hslmod (list (nth 0 hsl) (nth 1 hsl) (+ (nth 2 hsl) delta)))
        (setq hslmod (mapcar (lambda (x) (if (> x 1.0) 1.0 (if (< x 0.0) 0.0 x))) hslmod)))
      )
    (setq rgb (color-hsl-to-rgb (nth 0 hslmod) (nth 1 hslmod) (nth 2 hslmod)))
    (setq hex (substring-no-properties (color-rgb-to-hex (nth 0 rgb) (nth 1 rgb) (nth 2 rgb) 2) 1))
    (replace-match (format "%06x" (string-to-number hex 16)) nil nil nil 1)
    (goto-char old-pos)
    )
  )

(global-set-key (kbd "C-j") '(lambda (arg)(interactive "p")(colour-shift 0.005 arg)))
(global-set-key (kbd "C-M-j") '(lambda (arg)(interactive "p")(colour-shift -0.005 arg)))

(seq-doseq (fn (list #'split-window #'delete-window)) (advice-add fn :after #'(lambda (&rest args) (balance-windows))))

(defun display-year-agenda (&optional year)
  "Display an agenda entry for a whole year."
  (interactive (list (read-string "Enter the year: "
                       (format-time-string "%Y" (current-time)))))
  (setq year (string-to-number year))
  (org-agenda-list)
  (org-agenda-year-view year)
  (setq this-year (string-to-number (format-time-string "%Y" (current-time))))
  (when (= year this-year)
    (org-agenda-goto-today)
    (recenter-top-bottom 10)))

;; Bind a key for easy access
(global-set-key (kbd "C-c y") 'display-year-agenda)

(setq org-agenda-files
  '("~/DCIM/content/aaa--todo.org"
     "/home/jdyer/DCIM/content/kate--health.org"))

(defun my/copy-background-to-faves ()
  "Copy the current background in sway to faves folder"
  (interactive)
  (let* ((source-folder "/home/jdyer/")
          (faves-folder "/home/jdyer/wallpaper/wallpaper-faves/")
          (image-files (directory-files source-folder nil "^wallpaper-faves.*\\.\\(jpg\\|jpeg\\|png\\|gif\\)$" nil nil)))
    (dolist (image-file image-files)
      (rename-file (concat source-folder image-file) (concat faves-folder image-file) t)
      (message (concat "Wallpaper " (concat faves-folder image-file)))
      )
    )
  )