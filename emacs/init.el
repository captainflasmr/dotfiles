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

;; (setq package-archives '(("melpa" . "~/emacs-pkgs/melpa")
;;                           ("elpa" . "~/emacs-pkgs/elpa")
;;                           ("org" . "~/emacs-pkgs/org-mode/lisp")))


(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(setq load-prefer-newer t)

;; (when init-file-debug
(setq use-package-verbose t
  use-package-expand-minimally nil
  use-package-compute-statistics t
  debug-on-error nil)
;; )

;;
;; -> top-level-variables
;;
(setq my/accent-color "#5d8400")

;;
;; -> package-local
;;
(use-package fd-find
  :load-path "~/repos/fd-find")

;;
;; -> package-remote
;;
;; will be able to remove the following package-vc-install as of emacs 30
;; as this will be built-in
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

;; now use-package has the :vc keyword!
(use-package org-ql
  :defer t
  :vc (:fetcher github :repo "alphapapa/org-ql"))

;;
;; -> use-package
;;
(use-package diminish)
(use-package diredfl
  :init (diredfl-global-mode 1)
  :diminish diredfl-mode)
(use-package i3wm-config-mode)
(use-package git-timemachine)
(use-package gnuplot)
(use-package ahk-mode)
(use-package kbd-mode
  :vc (:fetcher github :repo "kmonad/kbd-mode"))
(use-package embark-consult)
(use-package find-file-rg)
(use-package gruvbox-theme)
(use-package ef-themes)
(use-package doom-themes)

(use-package toc-org
  :commands
  toc-org-enable
  :init
  (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package rainbow-mode
  :diminish rainbow-mode colour-shift-mode
  :hook
  (prog-mode . rainbow-mode)
  (conf-space-mode . rainbow-mode)
  (org-mode . rainbow-mode))

(use-package visual-fill-column
  :config
  (setq-default visual-fill-column-center-text t))

(use-package ox-hugo
  :defer t
  :config
  (setq org-hugo-front-matter-format "yaml"))

(use-package embark)

(use-package deadgrep
  :custom
  (deadgrep-max-buffers 1))

;;
;; -> completion
;;
(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect 'prompt)      ;; Preselect the prompt
  (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  :hook ((shell-mode . corfu-mode)
          (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  ;; :init
  ;; (global-corfu-mode)
  )

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

;; Configure Tempel
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")
  :diminish tempel-abbrev-mode global-tempel-abbrev-mode abbrev-mode
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
          ("M-*" . tempel-insert))

  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
      (cons #'tempel-expand
        completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  (global-tempel-abbrev-mode))

;;
;; -> modeline-completion-advanced
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
  (completion-styles '(basic orderless))
  (completion-category-overrides '((file (styles basic partial-completion)))))

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

(define-key my-jump-keymap (kbd "1") (lambda () (interactive)(tab-select 1)))
(define-key my-jump-keymap (kbd "2") (lambda () (interactive)(tab-select 2)))
(define-key my-jump-keymap (kbd "3") (lambda () (interactive)(tab-select 3)))
(define-key my-jump-keymap (kbd "4") (lambda () (interactive)(tab-select 4)))
(define-key my-jump-keymap (kbd "5") (lambda () (interactive)(tab-select 5)))
(define-key my-jump-keymap (kbd "6") (lambda () (interactive)(tab-select 6)))
(define-key my-jump-keymap (kbd "a") 'emms-browse-by-album)
(define-key my-jump-keymap (kbd "b") (lambda () (interactive) (find-file "~/bin")))
(define-key my-jump-keymap (kbd "c") (lambda () (interactive) (find-file "~/DCIM/Camera")))
(define-key my-jump-keymap (kbd "d") (lambda () (interactive) (find-file "/run/media/jdyer/")))
(define-key my-jump-keymap (kbd "e") (lambda () (interactive) (find-file "~/.config/emacs/init.el")))
(define-key my-jump-keymap (kbd "f") 'find-file-rg)
(define-key my-jump-keymap (kbd "g") (lambda () (interactive) (find-file "~/.config")))
(define-key my-jump-keymap (kbd "h") (lambda () (interactive) (find-file "~")))
(define-key my-jump-keymap (kbd "i") 'tab-close)
(define-key my-jump-keymap (kbd "j") (lambda () (interactive) (find-file "~/DCIM/content/aaa--todo.org")))
(define-key my-jump-keymap (kbd "k") (lambda () (interactive) (find-file "~/.config/emacs/emacs--init.org")))
(define-key my-jump-keymap (kbd "l") 'consult-recent-file)
(define-key my-jump-keymap (kbd "m") 'consult-theme)
(define-key my-jump-keymap (kbd "n") (lambda () (interactive) (find-file "~/nas")))
(define-key my-jump-keymap (kbd "o") (lambda () (interactive) (tab-bar-new-tab-to -1)))
(define-key my-jump-keymap (kbd "p") 'proced)
(define-key my-jump-keymap (kbd "s") (lambda () (interactive) (find-file "~/DCIM/Screenshots")))
(define-key my-jump-keymap (kbd "t") 'customize-themes)
(define-key my-jump-keymap (kbd "u") 'tab-undo)
(define-key my-jump-keymap (kbd "w") (lambda () (interactive) (find-file "~/DCIM/content/")))
(define-key my-jump-keymap (kbd "y") 'emms)

(global-set-key (kbd "M-o") my-jump-keymap)

(defvar my-win-keymap (make-sparse-keymap))
(define-key my-win-keymap (kbd "a") 'selected-window-accent-mode)
(define-key my-win-keymap (kbd "b") '(lambda () (interactive)(tab-bar-mode 'toggle)))
(define-key my-win-keymap (kbd "c") 'display-fill-column-indicator-mode)
(define-key my-win-keymap (kbd "d") 'window-divider-mode)
(define-key my-win-keymap (kbd "f") 'font-lock-mode)
(define-key my-win-keymap (kbd "g") 'my/toggle-scroll-margin)
(define-key my-win-keymap (kbd "i") 'highlight-indent-guides-mode)
(define-key my-win-keymap (kbd "l") 'display-line-numbers-mode)
(define-key my-win-keymap (kbd "m") 'toggle-menu-bar-mode-from-frame)
(define-key my-win-keymap (kbd "n") 'global-tab-line-mode)
(define-key my-win-keymap (kbd "o") 'visual-fill-column-mode)
(define-key my-win-keymap (kbd "p") 'variable-pitch-mode)
(define-key my-win-keymap (kbd "r") 'org-modern-mode)
(define-key my-win-keymap (kbd "s") 'my/toggle-internal-border-width)
(define-key my-win-keymap (kbd "t") 'org-tidy-toggle)
(define-key my-win-keymap (kbd "u") 'toggle-truncate-lines)
(define-key my-win-keymap (kbd "v") 'visual-line-mode)
(define-key my-win-keymap (kbd "w") 'whitespace-mode)
(define-key my-win-keymap (kbd "y") 'switch-selected-window-accent-style)
(global-set-key (kbd "M-m") my-win-keymap)

;;
;; -> unbinding
;;
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-h h"))

(use-package diff-mode
  :hook
  (diff-mode . (lambda ()
                 (define-key diff-mode-map (kbd "M-0") nil)
                 (define-key diff-mode-map (kbd "M-1") nil)
                 (define-key diff-mode-map (kbd "M-2") nil)
                 (define-key diff-mode-map (kbd "M-3") nil)
                 (define-key diff-mode-map (kbd "M-4") nil))))

(use-package magit
  :config
  (unbind-key "M-0" magit-mode-map)
  (unbind-key "M-1" magit-mode-map)
  (unbind-key "M-2" magit-mode-map)
  (unbind-key "M-3" magit-mode-map)
  (unbind-key "M-4" magit-mode-map))

;;
;; -> magit
;;
(use-package magit
  :config
  (magit-add-section-hook
    'magit-status-sections-hook 'magit-insert-tracked-files nil 'append)
  :custom
  (magit-section-initial-visibility-alist (quote ((untracked . hide))))
  (magit-repolist-column-flag-alist
    '((magit-untracked-files . "N")
       (magit-unstaged-files . "U")
       (magit-staged-files . "S")))
  (magit-repolist-columns
    '(("Name" 25 magit-repolist-column-ident nil)
       ("" 3 magit-repolist-column-flag)
       ("Version" 25 magit-repolist-column-version
         ((:sort magit-repolist-version<)))
       ("B<U" 3 magit-repolist-column-unpulled-from-upstream
         ((:right-align t)
           (:sort <)))
       ("B>U" 3 magit-repolist-column-unpushed-to-upstream
         ((:right-align t)
           (:sort <)))
       ("Path" 99 magit-repolist-column-path nil)))
  (magit-repository-directories
    '(("~/.config" . 0)
       ("~/repos" . 2)
       ("~/DCIM/Art/Content" . 2)
       ("~/DCIM/themes" . 2))))

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
  (emms-source-file-default-directory "~/MyMusicLibrary")
  (emms-volume-amixer-card 1)
  (emms-volume-change-function 'emms-volume-pulse-change))

;;
;; -> elfeed
;;
(use-package elfeed
  :bind
  ("C-x w" . elfeed)
  (:map elfeed-search-mode-map
    ("n" . (lambda () (interactive)
             (next-line) (call-interactively 'elfeed-search-show-entry)))
    ("p" . (lambda () (interactive)
             (previous-line) (call-interactively 'elfeed-search-show-entry)))
    ("m" . (lambda () (interactive)
             (apply 'elfeed-search-toggle-all '(star)))))
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
    (set-face-attribute 'variable-pitch (selected-frame)
      :font (font-spec :family "Source Code Pro" :size 16))
    (setq elfeed-show-entry-switch #'my/show-elfeed)))

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
(global-set-key (kbd "M-s e") 'my/push-block)
(global-set-key (kbd "M-s g") 'my/text-browser-search)
(global-set-key (kbd "M-=") 'count-words)
(define-key minibuffer-local-map (kbd "C-c e") 'embark-collect)
(global-set-key (kbd "M-L") 'tab-next)
(global-set-key (kbd "M-H") 'tab-previous)
(bind-key* (kbd "M-g o") 'consult-outline)
(bind-key* (kbd "M-g i") 'consult-imenu)
(global-set-key (kbd "C-c a") 'org-agenda)
(bind-key* (kbd "M-j") (lambda()(interactive)(next-line (/ (window-height) 8))))
(bind-key* (kbd "M-k") (lambda()(interactive)(previous-line (/ (window-height) 8))))
(bind-key* (kbd "M-l") (lambda()(interactive)(select-window (next-window (selected-window)))))
(bind-key* (kbd "M-h") (lambda()(interactive)(select-window (previous-window (selected-window)))))
(bind-key* (kbd "M-I") (lambda ()(interactive)(my/resize-window 4 t)))
(bind-key* (kbd "M-U") (lambda ()(interactive)(my/resize-window -4 t)))
(global-set-key (kbd "C-c b") (lambda ()(interactive)(async-shell-command "do_backup home" "*backup*")))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c f") 'my/fold)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x j") 'previous-buffer)
(global-set-key (kbd "C-x k") 'next-buffer)
(global-set-key (kbd "C-x l") 'scroll-lock-mode)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-;") 'my/comment-or-uncomment)
(global-set-key (kbd "M-?") 'my/grep)
(bind-key* (kbd "C-c ,") 'embark-act)

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
(pixel-scroll-precision-mode 1)
(repeat-mode -1)

;;
;; -> bell
;;
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; -> setqs
;;
(setq fit-window-to-buffer-horizontally t)
(setq case-fold-search t)
(setq custom-safe-themes t)
(setq tramp-default-method "ssh")
(setq enable-local-variables :all)
(setq proced-auto-update-interval 1)
(setq isearch-lazy-count t)
(setq shr-max-image-proportion 0.5)
(setq shr-max-width 80)
(setq shr-width 70)
(setq tooltip-hide-delay 0)
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))
(setq kill-buffer-query-functions nil)
(setq use-dialog-box nil)
(setq switch-to-buffer-obey-display-actions t)
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
(add-hook 'next-error-hook #'org-show-all)

;;
;; -> custom-settings
;;
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(custom-enabled-themes '(gruvbox))
  '(warning-suppress-log-types '((frameset)))
  '(warning-suppress-types '((frameset))))

;;
;; -> defun
;;
(defun proced-settings()
  (proced-toggle-auto-update 1))

(defun my/show-elfeed (buffer)
  (display-buffer buffer))

(defun my/resize-window (delta &optional horizontal)
  "Resize window back and forth."
  (interactive)
  (cond
    ((< (nth 0 (window-edges)) 2)
      (enlarge-window delta horizontal))
    (t (select-window (windmove-left (selected-window)))
      (enlarge-window delta horizontal)
      (select-window (windmove-right (selected-window))))))

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
    (dired-unmark-all-marks)
    (other-window 1)
    (sleep-for 1)
    (dired-revert)
    (revert-buffer nil t nil)))

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

(defun convert-weight (weight)
  (let* ((parts (split-string weight ":"))
          (stone (string-to-number (car parts)))
          (pounds (string-to-number (cadr parts))))
    (+ (* stone 14) pounds)))

(defun my/copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                    default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

(global-set-key (kbd "C-c w") 'file-info-show)

(defun my/mark-word ()
  "redefinition of mark-word"
  (interactive)
  (if (not (looking-at "\\<"))
    (backward-word))
  (when (not (region-active-p))
    (push-mark))
  (forward-word)
  (setq mark-active t))

(defun my/mark-word ()
  "redefinition of mark-word"
  (interactive)
  (when (not (region-active-p))
    (backward-to-word 1))
  (forward-to-word 1)
  (when (not (region-active-p))
    (push-mark))
  (forward-word)
  (setq mark-active t))

(defun my/mark-block ()
   "Marking a block of text surrounded by a newline"
   (interactive)
   (when (not (region-active-p))
      (backward-char))
   (skip-chars-forward " \n\t")
   (re-search-backward "^[ \t]*\n" nil 1)
   (skip-chars-forward " \n\t")
   (when (not (region-active-p))
      (push-mark))
   (re-search-forward "^[ \t]*\n" nil 1)
   (skip-chars-backward " \n\t")
  (setq mark-active t))

(global-set-key (kbd "M-s h") 'my/mark-block)
(global-set-key (kbd "M-@") 'my/mark-block)
(global-set-key (kbd "M-'") 'my/mark-word)

;;
;; -> window-positioning
;;
;; (add-to-list 'display-buffer-alist
;;   '("\\*rsync" display-buffer-no-window
;;      (allow-no-window . t)))

(add-to-list 'display-buffer-alist
  '("\\*Async" display-buffer-no-window
     (allow-no-window . t)))

(add-to-list 'display-buffer-alist
  '("\\*Proced" display-buffer-same-window))

(add-to-list 'display-buffer-alist
  '("\\*Messages" display-buffer-same-window))

(add-to-list 'display-buffer-alist
  '("magit:" display-buffer-same-window))

(add-to-list 'display-buffer-alist
  '("\\*deadgrep"
     (display-buffer-reuse-window display-buffer-in-direction)
     (direction . leftmost)
     (dedicated . t)
     (window-width . 0.3)
     (inhibit-same-window . t)))

(add-to-list 'display-buffer-alist
  '("\\*compilation"
     (display-buffer-reuse-window display-buffer-in-direction)
     (direction . leftmost)
     (dedicated . t)
     (window-width . 0.3)
     (inhibit-same-window . t)))

(add-to-list 'display-buffer-alist
  '("\\*Help\\*"
     (display-buffer-reuse-window display-buffer-same-window)))

;;
;; -> org-capture
;;
(setq bookmark-fringe-mark nil)

(defun my-capture-top-level ()
  "Function to capture a new entry at the top level of the given file."
  (goto-char (point-min))
  (or (outline-next-heading)
      (goto-char (point-max)))
  (unless (bolp) (insert "\n")))

(setq org-capture-templates
  '(
     ("p" "Post" plain
       (file+function
         "~/DCIM/content/posts--all.org"
         my-capture-top-level)
       "* TODO %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-posts--%\\1
:EXPORT_HUGO_SECTION: posts
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /posts/%<%Y%m%d%H%M%S>-posts--%\\1.jpg
:END:
%?
" :prepend t :jump-to-captured t)

     ("e" "Emacs" plain
       (file+function
         "~/DCIM/content/emacs--all.org"
         my-capture-top-level)
       "* TODO %^{title} :emacs:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-emacs--%\\1
:EXPORT_HUGO_SECTION: emacs
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /emacs/%<%Y%m%d%H%M%S>-emacs--%\\1.jpg
:END:
%?
" :prepend t :jump-to-captured t)

     ("l" "Linux" plain
       (file+function
         "~/DCIM/content/linux--all.org"
         my-capture-top-level)
       "** TODO %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-linux--%\\1
:EXPORT_HUGO_SECTION: linux
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /linux/%<%Y%m%d%H%M%S>-emacs--%\\1.jpg
:END:
%?
" :prepend t :jump-to-captured t)

     ("a" "Art")

     ("av" "Art Videos" plain
       (file+function
         "~/DCIM/content/art--all.org"
         my-capture-top-level)
       "* TODO %^{title} Video :videos:painter:krita:artrage:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>--%\\1-%\\2
:EXPORT_HUGO_SECTION: art--videos
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /art--videos/%<%Y%m%d%H%M%S>--%\\1-%\\2.jpg
:VIDEO:
:END:
#+begin_export md
{{< youtube %^{youtube} >}}
#+end_export
%?
" :prepend t :jump-to-captured t)

     ("aa" "Art" plain
       (file+function
         "~/DCIM/content/art--all.org"
         my-capture-top-level)
       "** TODO %^{title} :painter:krita:artrage:2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %\\1
:EXPORT_HUGO_SECTION: art--all
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d %H:%M>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /art--all/%\\1.jpg
:VIDEO:
:END:
#+attr_org: :width 300px
#+attr_html: :width 100%
#+begin_export md
#+end_export
%?
" :prepend t :jump-to-captured t)))

;;
;; -> org
;;
(use-package org
  :hook
  (org-mode . (lambda ()(org-indent-mode)(diminish 'org-indent-mode)))
  ;; :diminish org-indent-mode
  :config
  (setq org-src-tab-acts-natively t ;; commenting better in org src blocks
    org-indent-indentation-per-level 2
    org-edit-src-content-indentation 0
    org-src-preserve-indentation t
    org-hide-leading-stars t
    org-reverse-note-order t
    org-log-done 'time
    org-tags-sort-function 'org-string-collate-greaterp
    org-export-with-sub-superscripts nil
    org-hugo-base-dir "~/DCIM"
    org-image-actual-width (list 50)
    org-startup-indented t
    org-todo-keywords
    '((sequence "TODO" "DOING" "WAIT" "WATCH" "ORDR" "SENT" "|" "CANCELLED" "DONE"))
    org-todo-keyword-faces
    '(("TODO" . "#ee5566")
       ("DOING" . "#5577aa")
       ("WAIT" . "#bb7744")
       ("WATCH" . "#bbad44")
       ("ORDR" . "#bb44ee")
       ("SENT" . "#bb44ee")
       ("CANCELLED" . "#426b3e")
       ("DONE" . "#77aa66"))
    org-cycle-separator-lines 0)
  :bind
  (:map org-mode-map
    ("M-n" . org-metadown)
    ("M-p" . org-metaup)
    ("M-N" . org-shiftdown)
    ("M-P" . org-shiftup)
    ("M-J" . org-shiftleft)
    ("M-K" . org-shiftright)
    ("M-[" . org-metaleft)
    ("M-]" . org-metaright)))

(use-package org-tidy)

(use-package org-modern
  :init (global-org-modern-mode -1))

(defun my/org-ql-emacs ()
  (interactive)
  (org-ql-search (org-agenda-files)
    '(and (done) (tags "2023") (tags "emacs"))
    :title "Emacs-related project tasks"
    :sort '(date priority todo)
    :super-groups '((:auto-parent t))))

(defun org-syntax-table-modify ()
  "Modify `org-mode-syntax-table' for the current org buffer."
  (modify-syntax-entry ?< "." org-mode-syntax-table)
  (modify-syntax-entry ?> "." org-mode-syntax-table))

(defun my/org-shrink-tables ()
  "Shrink all tables in the current Org buffer, skipping tables inside source blocks."
  (interactive)
  (save-excursion
    (let ((block-start (point-min))   ;; Initialize to the start of the buffer
           (block-end (point-min)))
      (goto-char (point-min))
      ;; Loop over all tables in the buffer
      (while (search-forward "|-" nil t)
        (save-excursion
          ;; Check if we're currently in a source block
          (when (org-between-regexps-p "^[ \t]*#\\+begin_src" "^[ \t]*#\\+end_src")
            ;; If yes, move block-end to the end of the current source block
            (end-of-line)
            (search-forward-regexp "^[ \t]*#\\+end_src" nil t)
            (setq block-end (point))
            ;; Jump to the end of the current source block
            (goto-char block-end)))
        ;; Ensure we're not inside a recently skipped source block
        (unless (<= (point) block-end)
          ;; Shrink table as we're outside a source block
          (org-table-shrink))))))

  (add-hook 'org-mode-hook #'my/org-shrink-tables)
  (add-hook 'org-mode-hook #'org-syntax-table-modify)
  ;; (remove-hook 'org-mode-hook #'org-syntax-table-modify)
  ;; (remove-hook 'org-mode-hook #'my/org-shrink-tables)

;;
;; -> org-agenda
;;
(defun display-year-agenda (&optional year)
  "Display an agenda entryf for a whole year."
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

(setq org-directory "~/DCIM/content/")
(setq org-agenda-files
  '(
     "~/DCIM/content/aaa--todo.org"
     "~/DCIM/content/art--all.org"
     "~/DCIM/content/dad--betting.org"
     "~/DCIM/content/emacs--all.org"
     "~/DCIM/content/gifts--james.org"
     "~/DCIM/content/gifts--others.org"
     "~/DCIM/content/kate--health.org"
     "~/DCIM/content/kate--loss.org"
     "~/DCIM/content/linux--all.org"
     "~/DCIM/content/misc--subs.org"
     "~/DCIM/content/posts--all.org"
     ))

;; (setq org-agenda-files
;;   (cl-remove-if-not #'(lambda (file) (string-suffix-p ".org" file))
;;     (directory-files org-directory t "\\.org$")))

;;
;; -> dwim
;;
(defvar my/dwim-convert-commands
  '("ConvertNoSpace" "AudioConvert" "AudioInfo" "AudioNormalise"
     "AudioTrimSilence" "PictureAutoColour" "PictureConvert"
     "PictureCrush" "PictureFrompdf" "PictureInfo" "PictureMontage"
     "PictureOrganise" "PictureCrop" "PictureRotateFlip"
     "PictureRotateLeft" "PictureRotateRight" "PictureScale"
     "PictureUpscale" "PictureGetText" "PictureOrientation"
     "PictureUpdateToCreateDate" "VideoConcat" "VideoConvert"
     "VideoCut" "VideoDouble" "VideoExtractAudio" "VideoExtractFrames"
     "VideoFilter" "VideoFromFrames" "VideoInfo" "VideoRemoveAudio"
     "VideoReplaceVideoAudio" "VideoRescale" "VideoReverse"
     "VideoRotate" "VideoRotateLeft" "VideoRotateRight" "VideoShrink"
     "VideoSlowDown" "VideoSpeedUp" "VideoZoom" "WhatsAppConvert"
     "PictureCorrect" "Picture2pdf"
     "OtherTagDate")
  "List of commands for dwim-convert.")

(defun my/dwim-convert-generic (command)
  "Execute a dwim-shell-command-on-marked-files with the given COMMAND."
  (let ((files (dired-get-marked-files nil current-prefix-arg)))
    (async-shell-command (concat command " " (mapconcat 'identity files " ")) "*convert*")))

(defun my/dwim-convert-with-selection ()
  "Prompt user to choose command and execute dwim-shell-command-on-marked-files."
  (interactive)
  (let ((chosen-command (completing-read "Choose command: "
                          my/dwim-convert-commands)))
    (my/dwim-convert-generic chosen-command)))

(global-set-key (kbd "C-c v") 'my/dwim-convert-with-selection)

;;
;; -> scroll
;;
(setq scroll-margin 20)
(setq scroll-preserve-screen-position t)

;;
;; -> font
;;
;; (setq font-general "Noto Sans Mono 14")
;; (setq font-general "MesloLGS Nerd Font Mono 11")
(setq font-general "Source Code Pro 13")
;; (setq font-general "Source Code Pro Light 14")
;; (setq font-general "Nimbus Mono PS 14")
;; (setq font-general "MesloLGS Nerd Font Mono 14")
;; (setq font-general "Droid Sans Mono 12")
;; (setq font-general "Hack Nerd Font Mono 13")

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
  '(diredfl-date-time ((t (:foreground "#8d909b"))))
  '(diredfl-dir-heading ((t (:foreground "#aa5555" :weight bold))))
  '(diredfl-dir-priv ((t (:foreground "DarkRed"))))
  '(diredfl-exec-priv ((t (:foreground "#999999"))))
  '(diredfl-file-name ((t (:foreground "#818282"))))
  '(diredfl-no-priv ((t nil)))
  '(diredfl-number ((t (:foreground "#999999"))))
  '(diredfl-read-priv ((t nil)))
  '(diredfl-write-priv ((t nil)))
  '(ediff-current-diff-A ((t (:extend t :background "#b5daeb" :foreground "#000000"))))
  '(ediff-even-diff-A ((t (:background "#bafbba" :foreground "#000000" :extend t))))
  '(ediff-fine-diff-A ((t (:background "#f4bd92" :foreground "#000000" :extend t))))
  '(ediff-odd-diff-A ((t (:background "#b8fbb8" :foreground "#000000" :extend t))))
  '(ztreep-diff-model-diff-face ((t (:foreground "#7cb0f2"))))
  '(ztreep-diff-model-add-face ((t (:foreground "#e38d5a"))))
  '(elfeed-search-title-face ((t (:foreground "#4E4E4E" :height 1.1 :family "Source Code Pro"))))
  '(org-code ((t (:inherit (shadow fixed-pitch)))))
  '(org-modern-date-active ((t (:inherit fixed-pitch))))
  '(org-date ((t (:inherit fixed-pitch))))
  '(org-document-info ((t (:foreground "#8f4800"))))
  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
  '(org-link ((t (:foreground "#5555ff" :underline t))))
  '(org-property-value ((t (:inherit fixed-pitch))) t)
  '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  '(org-tag ((t (:inherit (shadow fixed-pitch) :weight regular :height 0.8))))
  '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  '(indent-guide-face ((t (:background "#282828" :foreground "#666666"))))
  '(outline-1 ((t (:weight regular))))
  '(outline-2 ((t (:weight regular))))
  '(widget-button ((t (:inherit fixed-pitch :weight regular))))
  '(window-divider ((t (:foreground "black"))))
  '(vertical-border ((t (:foreground "#000000"))))
  '(tab-bar-tab-inactive ((t (:inherit tab-bar :box (:line-width (2 . 2) :color "#575757" :style flat)))))
  )

(custom-set-faces
 `(tab-bar-tab ((t (:inherit tab-bar :background ,my/accent-color :box (:line-width (2 . 2) :color "#9c9c9c" :style flat))))))

(custom-theme-set-faces
  'user
  '(variable-pitch ((t (:family "Sans Serif" :height 140 :weight normal))))
  '(fixed-pitch ((t ( :family "Fira Code Retina" :height 130)))))

;;
;; -> dired
;;
(use-package dired
  :ensure nil
  :diminish dired-async-mode
  :commands (dired dired-jump)
  :bind (("M-e" . dired-jump)
          (:map dired-mode-map
            ("C-c i" . my/image-dired-sort)
            ("C-c d" . my/dired-duplicate-file)))
  :custom
  (dired-async--modeline-mode 1)
  (dired-guess-shell-alist-user
    '(("\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" "gthumb")
       ("\\.\\(mp4\\|mkv\\|avi\\|mov\\|wmv\\|flv\\|mpg\\)$" "mpv")
       ("\\.\\(mp3\\|wav\\|ogg\\|\\)$" "mpv")
       ("\\.\\(kra\\)$" "org.kde.krita")
       ("\\.\\(odt\\|ods\\)$" "libreoffice")
       ("\\.\\(html\\|htm\\)$" "firefox")
       ("\\.\\(pdf\\|epub\\)$" "okular" "calibre")))
  (dired-dwim-target t)
  (dired-listing-switches "-alGgh")
  (dired-auto-revert-buffer t)
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-confirm-shell-command nil)
  (dired-no-confirm t)
  (dired-recursive-deletes 'always)
  (dired-deletion-confirmer '(lambda (x) t))
  :config
  (dired-async-mode 1))

;;
;; -> image-dired
;;
(require 'image-mode)
(require 'image-dired)

(add-to-list 'display-buffer-alist
  '("\\*image-dired\\*"
     display-buffer-in-direction
     (direction . left)
     (window . root)
     (window-width . 0.5)))

(add-to-list 'display-buffer-alist
  '("\\*image-dired-display-image\\*"
     display-buffer-in-direction
     (direction . right)
     (window . root)
     (window-width . 0.5)))

(defun my/image-dired-sort (arg)
  "Sort images in various ways."
  (interactive "p")
  (cond
    ((equal current-prefix-arg nil)   ; no C-u
      (setq dired-actual-switches "-lGghat"))
    ((equal current-prefix-arg '(4))  ; C-u
      (setq dired-actual-switches "-lGgha"))
    ((equal current-prefix-arg 1)     ; C-u 1
      (setq dired-actual-switches "-lGgha")))
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

(setq image-use-external-converter t)
(setq image-dired-external-viewer "/usr/bin/gthumb")
(setq image-dired-show-all-from-dir-max-files 999)
(setq image-dired-thumbs-per-row 999)
(setq image-dired-thumb-relief 0)
(setq image-dired-thumb-margin 5)
(setq image-dired-thumb-size 120)

(defun my/image-save-as ()
  "Save the current image buffer as a new file."
  (interactive)
  (let* ((file (buffer-file-name))
          (dir (file-name-directory file))
          (name (file-name-nondirectory file))
          (base-name (file-name-sans-extension name))
          (extension (file-name-extension name t))
          (initial_mode major-mode)
          (counter 1)
          (new-file))
    (while (and (setq new-file
                  (format "%s%s_%03d%s" dir base-name counter extension))
             (file-exists-p new-file))
      (setq counter (1+ counter)))
    (write-region (point-min) (point-max) new-file nil 'no-message)
    (revert-buffer nil t nil)
    ;; (delete-file file t)
    (if (equal initial_mode 'image-dired-image-mode)
      (progn
        (image-dired ".")
        (image-dired-display-this))
      (find-file new-file t))))

(defun my/delete-current-image-and-move-to-next ()
  "Delete the current image file and move to the next image in the directory."
  (interactive)
  (let ((current-file (buffer-file-name)))
    (when current-file
      (image-next-file 1)
      (delete-file current-file)
      (message "Deleted %s" current-file))))

(defun my/delete-current-image-thumbnails ()
  "Delete the current image file and move to the next image in the directory."
  (interactive)
  (let ((file-name (image-dired-original-file-name)))
    (delete-file file-name)
    (image-dired-delete-char)
    (image-dired-display-this)))

(eval-after-load 'image-mode
  '(progn
     (define-key image-mode-map (kbd "C-d") 'my/delete-current-image-and-move-to-next)
     (define-key image-mode-map (kbd "C-x C-s") 'my/image-save-as)))

(eval-after-load 'image-dired
  '(progn
     (define-key image-dired-thumbnail-mode-map (kbd "C-d") 'my/delete-current-image-thumbnails)
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-f")
     ;;   (lambda ()(interactive)(image-dired-forward-image)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-b")
     ;;   (lambda ()(interactive)(image-dired-backward-image)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-n")
     ;;   (lambda ()(interactive)(image-dired-next-line)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-p")
     ;;   (lambda ()(interactive)(image-dired-previous-line)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-a")
     ;;   (lambda ()(interactive)(image-dired-move-beginning-of-line)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "C-e")
     ;;   (lambda ()(interactive)(image-dired-move-end-of-line)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "M-<")
     ;;   (lambda ()(interactive)(image-dired-beginning-of-buffer)(image-dired-display-this)))
     ;; (define-key image-dired-thumbnail-mode-map (kbd "M->")
     ;;   (lambda ()(interactive)(image-dired-end-of-buffer)(image-dired-display-this)))
     ))

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
(setq-default truncate-partial-width-windows 120)
(set-frame-parameter nil 'alpha-background 97)
(add-to-list 'default-frame-alist '(alpha-background . 97))
(set-fringe-mode '(0 . 0))
(set-display-table-slot standard-display-table 0 ?\ )

(setq window-divider-default-bottom-width 6)
(setq window-divider-default-right-width 6)
(setq window-divider-default-places t)

(window-divider-mode -1)

(setq-default left-margin-width 0 right-margin-width 0)

(modify-all-frames-parameters `((internal-border-width . 0)))

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
    (setq truncate-lines t)
    (setq imenu-sort-function 'imenu--sort-by-name)
    (setq imenu-generic-expression
      '((nil "^;;[[:space:]]+-> \\(.*\\)$" 1)))
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
            (propertize " * " 'face
              '(:background "#ff0000" :foreground "#ffffff" :inherit bold)) "")))

(set-face-attribute 'mode-line-active nil :height 130 :underline nil :overline nil :box nil
  :background "#a7a7a7" :foreground "#000000")
(set-face-attribute 'mode-line-inactive nil :height 130 :underline nil :overline nil
  :background "#151515" :foreground "#cacaca")

(setq-default mode-line-format
  '("%e"
     mode-line-modified
     (:eval
       (propertize (format "%s" (abbreviate-file-name default-directory))))
     (:eval
       (when (or (eq major-mode 'image-mode)
               (eq major-mode 'image-dired-image-mode))
         (process-lines  "identify"  "-format"  "[%m %wx%h %b]" (buffer-file-name))))
     (:eval
       (if (not (equal major-mode 'dired-mode))
         (propertize (format "%s " (buffer-name))
           'face '(:inherit bold))
         " "))
     mode-line-position
     ;; mode-line-modes
     mode-line-misc-info))
;; "-%-"))

(setq mode-line-compact t)

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
(use-package jinx)
(use-package powerthesaurus)

(global-set-key (kbd "M-s l")
  (lambda () (interactive)
    ;; (backward-word)
    (jinx-correct)))
    ;; (forward-word)))

(global-set-key (kbd "M-s j") 'jinx-mode)
(global-set-key (kbd "M-s k") 'dictionary-lookup-definition)
(global-set-key (kbd "M-s n") 'powerthesaurus-lookup-synonyms-dwim)

(setq ispell-local-dictionary "en_GB")
(setq ispell-program-name "hunspell")
(setq dictionary-default-dictionary "*")
(setq dictionary-server "dict.org")
(setq dictionary-use-single-buffer t)

;;
;; -> gdb
;;
(setq gdb-display-io-nopopup 1)
(setq gdb-many-windows t)

(global-set-key (kbd "<f9>") 'gud-break)
(global-set-key (kbd "<f10>") 'gud-next)
(global-set-key (kbd "<f11>") 'gud-step)

;;
;; -> compilation
;;
(setq compilation-always-kill t)
(setq compilation-context-lines 3)
(setq compilation-scroll-output nil)
;; ignore warnings
(setq compilation-skip-threshold 2)

(global-set-key (kbd "<f5>") 'my/project-compile)

;; (add-hook 'compilation-mode-hook #'my/project-create-compilation-search-path)

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
(use-package eglot)

;; (define-key company-active-map (kbd "<tab>") 'company-complete-selection)

(use-package company
  :bind
  (:map company-active-map
    ("<tab>" . company-complete-selection))
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.05))

(use-package yaml-mode)

(add-hook 'yaml-mode-hook
  '(lambda ()
     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(setq eldoc-echo-area-use-multiline-p nil)

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
(setq ediff-split-window-function 'split-window-horizontally)
(defvar my-ediff-last-windows nil)

(defun my-store-pre-ediff-winconfig ()
  "Store `current-window-configuration' in variable `my-ediff-last-windows'."
  (setq my-ediff-last-windows (current-window-configuration)))

(defun my-restore-pre-ediff-winconfig ()
  "Restore window configuration to stored value in `my-ediff-last-windows'."
  (set-window-configuration my-ediff-last-windows))

(add-hook 'ediff-before-setup-hook #'my-store-pre-ediff-winconfig)
(add-hook 'ediff-quit-hook #'my-restore-pre-ediff-winconfig)

;;
;; -> ada
;;
(use-package ada-mode
  :vc (:fetcher github :repo "captainflasmr/old-ada-mode"))

(defun my/eglot-dir-locals ()
  "Create .dir-locals.el file for eglot ada-mode using the selected dired path."
  (interactive)
  (add-dir-local-variable
    'ada-mode
    'eglot-workspace-configuration
    `((ada . (:projectFile ,(dired-get-filename))))))

(setq xref-auto-jump-to-first-definition t)
(setq xref-auto-jump-to-first-xref t)

(defun my/xref--read-identifier (prompt)
  "Custom function to find definitions in Ada mode."
  (let ((def (xref-backend-identifier-at-point 'etags))
         (variations '("/t" "/k" "/f" "/p" "/b" "/s"))
         (ada-refs 'nil))
    (when def
      (dolist (variation variations)
        (if (xref-backend-definitions 'etags (concat def variation))
          (setq ada-refs (cons (concat identifier variation) ada-refs)))))
    (cond
      ((eq (length ada-refs) 0)
        (setq id def))
      ((eq (length ada-refs) 1)
        (setq id (nth 0 ada-refs)))
      (t
        (setq id (completing-read prompt ada-refs))))))

(defun my/xref-find-definitions (identifier)
  (interactive "p")
  (setq identifier (my/xref--read-identifier "Find definitions of: "))
  (xref-find-definitions identifier))

(defun buffer-in-eglot-mode-p ()
  (if (fboundp 'eglot-managed-p)
    (eglot-managed-p)
    nil))

(defun buffer-in-old-ada-mode-p ()
  (if (boundp 'ada-prj-default-project-file)
    t
    nil))

(defun buffer-in-tags-mode-p ()
  (if tags-table-list
    t
    nil))

(defun my/ada-find-definitions ()
  "Custom function to find definitions in Ada mode."
  (interactive)
  (cond
    ((buffer-in-eglot-mode-p)
      (message "xref: eglot")
      (xref-find-definitions (xref-backend-identifier-at-point 'eglot)))
    ((buffer-in-old-ada-mode-p)
      (message "xref: old-ada-mode")
      (setq ada-xref-other-buffer nil)
      (ada-goto-declaration (point)))
    ((buffer-in-tags-mode-p)
      (message "xref: etags")
      (my/xref-find-definitions (xref-backend-identifier-at-point 'etags)))
    (t
      (message "xref: fallback")
      (my/etags-load)
      (my/xref-find-definitions (xref-backend-identifier-at-point 'etags)))))

(defun my/xref-quit-xref-marker-stack ()
  "Quit *xref* buffer"
  (interactive)
  (save-excursion
    (let ((target-window (get-buffer-window "*xref*")))
      (when target-window
        (select-window target-window)
        (quit-window t)))))

(defun my/ada-find-definition-pop ()
  "Custom function to pop definitions in Ada mode."
  (interactive)
  (cond
    ((buffer-in-eglot-mode-p)
      (message "xref pop: eglot")
      (my/xref-quit-xref-marker-stack)
      (xref-quit-and-pop-marker-stack))
    ((buffer-in-old-ada-mode-p)
      (message "xref pop: old-ada-mode")
      (ada-xref-goto-previous-reference))
    ((buffer-in-tags-mode-p)
      (message "xref pop: etags")
      (my/xref-quit-xref-marker-stack)
      (xref-go-back))
    (t
      (message "xref pop: fallback")
      (my/xref-quit-xref-marker-stack)
      (xref-go-back))))

(define-key ada-mode-map (kbd "M-.") 'my/ada-find-definitions)
(define-key ada-mode-map (kbd "M-,") 'my/ada-find-definition-pop)

;;
;; -> treesitter
;;
(setq treesit-language-source-alist
  '((ada "https://github.com/briot/tree-sitter-ada")
     (bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript"
       "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript"
       "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
       "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; (mapc #'treesit-install-language-grammar
;;      (mapcar #'car treesit-language-source-alist))

;;  (use-package ada-ts-mode)
(use-package gpr-ts-mode)

(setq major-mode-remap-alist
  '( ;;      (ada-mode . ada-ts-mode)
     ;;      (yaml-mode . yaml-ts-mode)
     (toml-mode . toml-ts-mode)
     ;;      (bash-mode . bash-ts-mode)
     ;;      (sh-mode . bash-ts-mode)
     ;;      (js2-mode . js-ts-mode)
     ;;      (typescript-mode . typescript-ts-mode)
     ;;      (conf-colon-mode . json-ts-mode)
     ;;      (json-mode . json-ts-mode)
     ;;      (css-mode . css-ts-mode)
     ;;      (python-mode . python-ts-mode)
     ))

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
     ;; space -> · else .
     (space-mark 32 [183] [46])
     ;; new line -> ¬ else $
     (newline-mark ?\n [172 ?\n] [36 ?\n])
     ;; carriage return (Windows) -> ¶ else #
     (newline-mark ?\r [182] [35])
     ;; tabs -> » else >
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
;; -> project
;;
(defun my/project-root ()
  "Return project root defined by user."
  (interactive)
  "Guess the project root of the given FILE-PATH."
  (let ((root default-directory)
         (project (project-current)))
    (when project
      (cond ((fboundp 'project-root)
              (setq root (project-root project)))))))

(add-to-list 'project-switch-commands '(project-dired "Dired") t)

(defun my/project-create-compilation-search-path ()
  "Populate the compilation-search-path variable with directories under project root using find"
  (interactive)
  (let ((find-command
          (concat "find " (project-root (project-current t))
            " \\( -path \\*/.local -o -path \\*/.config -o -path \\*/.svn -o -path \\*/.git -o -path \\*/nas \\) -prune -o -type d -print")))
    (setq compilation-search-path
      (split-string
        (shell-command-to-string find-command)
        "\n" t))))

(defun my/project-compile (arg)
  (interactive "p")
  (let ((default-directory (project-root (project-current t))))
    (cond ((= arg 1)
            (setq compile-command
              (concat "make " buffer-file-name)))
      (t
        (setq compile-command "make")))
    (compile compile-command)))

(setq project-vc-extra-root-markers '(".project"))

(global-set-key (kbd "C-x p c") 'my/project-compile)

;;
;; -> indentation
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq-default lisp-indent-offset 2)
(add-hook 'sh-mode-hook
  (lambda () (setq sh-basic-offset 3)))

(use-package highlight-indent-guides
  :custom (highlight-indent-guides-method 'character))

;;
;; -> etags
;;
(defun my/etags-load ()
  "Load the TAGS file from the first it can find up the directory stack."
  (interactive)
  (let ((my-tags-file (locate-dominating-file default-directory "TAGS")))
    (when my-tags-file
      (message "Loading tags file: %s" my-tags-file)
      (visit-tags-table my-tags-file))))

(defun my/etags-update ()
  "Call external bash script to generate new etags for all languages it can find"
  (interactive)
  (async-shell-command "my-generate-etags.sh" "*etags*"))

;; (global-set-key (kbd "C-x p l") 'my/etags-load)
;; (global-set-key (kbd "C-x p u") 'my/etags-update)

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
;; -> shell
;;
(setq explicit-shell-file-name "/usr/bin/bash")
(setq shell-file-name "/bin/bash")

(defun my/eshell-hook ()
  "set up company completions to be a little more fish like"
  (interactive)
  (define-key eshell-mode-map (kbd "<tab>") #'company-complete)
  (define-key eshell-hist-mode-map (kbd "M-r") #'consult-history))

(defun my/shell-hook ()
  "set up company completions to be a little more fish like"
  (interactive)
  (define-key shell-mode-map (kbd "<tab>") #'company-complete)
  (define-key shell-mode-map (kbd "M-r") #'consult-history))

(use-package eshell
  :config
  (setq eshell-scroll-to-bottom-on-input t)
  :hook
  (eshell-mode . my/eshell-hook))

(use-package shell
  :config
  :hook
  (shell-mode . my/shell-hook))

(global-set-key (kbd "M-T") 'shell)

;;
;; -> chatGPT
;;
(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
     (lambda ()
       (auth-source-pass-get 'secret "openai-key")))))

;;
;; —> proced
;;
(use-package proced
  :bind ("C-x x p" . 'proced)
  :init (setq proced-auto-update-interval 1
          proced-enable-color-flag 1
          proced-format 'medium
          proced-sort 'rss)
  :hook (proced-mode . (lambda ()
                         (interactive)
                         (proced-toggle-auto-update 1))))

(defun my/proced-toggle-update()
  "Proced turn auto update on and off"
  (interactive)
  (if proced-auto-update-flag
    (proced-toggle-auto-update -1)
    (proced-toggle-auto-update 1)))

(use-package proced-narrow
  :after proced
  :bind (:map proced-mode-map
          ("f" . proced-narrow)
          ("G" . my/proced-toggle-update)))

;;
;; -> all-the-icons
;;
(use-package all-the-icons-ibuffer
  :ensure t
  :hook
  (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package all-the-icons-completion
  :ensure t
  :init
  (all-the-icons-completion-mode)
  :hook
  (marginalia-mode all-the-icons-completion-marginalia-setup))

(use-package all-the-icons-dired
  :diminish
  all-the-icons-dired-mode
  :hook
  (dired-mode . all-the-icons-dired-mode))

;;
;; -> tab-bar
;;

(display-time-mode 1)
(setq display-time-day-and-date t)
(setq display-time-interval 4)
(setq display-time-load-average-threshold 2.0)

(defun my-tab-line-buffer-name ()
  "Return the current buffer name for use in the tab line."
  (let ((buffer-name (buffer-name)))
    (propertize (concat buffer-name "  ") 'face 'default)))

(use-package tab-bar ;; 29.1
  :ensure nil ;; Since tab-bar is built-in, no package needs to be downloaded
  :init
  (tab-bar-mode 1) ;; 27.1
  (tab-bar-history-mode 1) ;; 27.1
  :custom
  (tab-bar-format '(tab-bar-format-tabs-groups
                     tab-bar-format-align-right
                     my-tab-line-buffer-name
                     tab-bar-format-global)) ;; 28.1
  (tab-bar-select-tab-modifiers '(control)) ;; 27.1
  (tab-bar-new-button-show nil) ;; 27.1
  (tab-bar-close-button-show nil) ;; 27.1
  (tab-bar-history-limit 100) ;; 27.1
  (tab-bar-auto-width-max '(50 20)) ;; 29.1
  (tab-bar-tab-hints t) ;; 27.1
  (tab-bar-tab-name-format-function #'my-tab-bar-tab-name-format) ;; 28.1
  :config
  (defun my-tab-bar-tab-name-format (tab i)
    (propertize
      (format " %d " i)
      'face (funcall tab-bar-tab-face-function tab)))
  :bind
  (("M-H" . tab-bar-switch-to-prev-tab) ;; 27.1
    ("M-L" . tab-bar-switch-to-next-tab) ;; 27.1
    ("M-u" . tab-bar-history-back) ;; 27.1
    ("M-i" . tab-bar-history-forward)) ;; 27.1
  )

;; (use-package tab-bar ;; 27.1
;;   :ensure nil ;; Since tab-bar is built-in, no package needs to be downloaded
;;   :init
;;   (tab-bar-mode 1) ;; 27.1
;;   (tab-bar-history-mode 1) ;; 27.1
;;   :custom
;;   (tab-bar-select-tab-modifiers '(control)) ;; 27.1
;;   (tab-bar-new-button-show nil) ;; 27.1
;;   (tab-bar-close-button-show nil) ;; 27.1
;;   (tab-bar-history-limit 100) ;; 27.1
;;   (tab-bar-tab-hints t) ;; 27.1
;;   (tab-bar-tab-name-function 'tab-bar-tab-name-truncated) ;; *27.1
;;   (tab-bar-tab-name-truncated-max 1) ;; *27.1
;;   (tab-bar-tab-name-ellipsis " ") ;; *27.1
;;   :bind
;;   (("M-H" . tab-bar-switch-to-prev-tab) ;; 27.1
;;     ("M-L" . tab-bar-switch-to-next-tab) ;; 27.1
;;     ("M-u" . tab-bar-history-back) ;; 27.1
;;     ("M-i" . tab-bar-history-forward)) ;; 27.1
;;   :custom-face
;;   (tab-bar-tab ((t (:inherit tab-bar :box (:line-width (2 . 2) :color "#9c9c9c" :style flat))))) ;; 27.1
;;   (tab-bar-tab-inactive ((t (:inherit tab-bar :box (:line-width (2 . 2) :color "#575757" :style flat)))))) ;; 27.1

;;
;; -> development
;;
(defvar my/internal-border-width 10 "Default internal border width for toggling.")

(defun my/toggle-internal-border-width (&optional value)
  (interactive "P")
  (let ((new-value (if value
                     value
                     (if (= (or (frame-parameter nil 'internal-border-width) 0)
                           0)
                       my/internal-border-width
                       0))))
    (modify-all-frames-parameters `((internal-border-width . ,new-value)))))

(defun my/toggle-scroll-margin (&optional value)
  (interactive "P")
  (let ((new-value (if value
                     value
                     (if (= (or scroll-margin 0) 0)
                       20
                       0))))
    (setq scroll-margin new-value)))

(use-package lorem-ipsum)

(defun subtract-weight (weight-str avg-loss)
  "Subtract AVG-LOSS pounds from WEIGHT-STR given in 'stones:pounds' format."
  (let* ((stones-pounds (split-string weight-str ":"))
          (stones (string-to-number (car stones-pounds)))
          (pounds (string-to-number (cadr stones-pounds)))
          (total-pounds (+ pounds (* stones 14)))      ;; Convert stones to pounds
          (new-total-pounds (- total-pounds avg-loss)) ;; Subtract weight loss
          (new-stones (truncate (/ new-total-pounds 14))) ;; Calculate new stones
          (new-pounds (mod new-total-pounds 14)))      ;; Calculate remaining pounds
    (format "%d:%d" new-stones new-pounds)))         ;; Format new weight

(defun extrapolate-weight-loss (num-weeks)
  "Extrapolate weight loss for NUM-WEEKS using the last 'av/pd' value in the org-table."
  (interactive "p")
  (save-excursion
    (let ((last-avg-loss 2.9)
           (last-date "")
           (week 0)
           (next-date ""))
      (print num-weeks)
      (when (org-table-p)
        (goto-char (org-table-end))
        ;; Find the last date and week number
        (search-backward-regexp "|\\s-?\\([0-9]+\\)\\s-?|\\s-?<\\([0-9-]+\\)" nil t)
        (setq week (string-to-number (match-string 1)))
        (setq last-date (match-string 2))
        (setq last-weight "16:10")

        (goto-char (org-table-end))

        ;; Loop for num-weeks to generate new lines
        (dotimes (i num-weeks)
          (setq next-date
            (format-time-string "<%Y-%m-%d %a>"
              (time-add (org-time-string-to-time last-date)
                (days-to-time (+ (* i 7) 7))))) ;; add 7 days per week
          (setq week (+ week 1))
          (insert (format "| %d | %s | %s | | | | | | |\n"
                    week next-date (subtract-weight last-weight (* (+ i 1) last-avg-loss)))))
        )
      )
    )
  (org-table-align))

(use-package ox-epub)

(use-package selected-window-accent-mode
  ;;   :load-path "~/repos/selected-window-accent-mode"
  ;; :vc (:fetcher github :repo "captainflasmr/selected-window-accent-mode")
  :diminish selected-window-accent-mode
  :custom
  (selected-window-accent-fringe-thickness 10)
  (selected-window-accent-custom-color my/accent-color)
  (selected-window-accent-mode-style 'subtle))

(selected-window-accent-mode)

(defun my/text-browser-search ()
  "Use the selected text (or the word under the cursor) as the search term for a Google search in a web browser."
  (interactive)
  (let (search-term start end)
    ;; Check if text is selected, otherwise use the word at the cursor position
    (if (use-region-p)
      (setq start (region-beginning)
        end (region-end))
      (setq start (beginning-of-thing 'word)
        end (end-of-thing 'word)))
    ;; Extract the search term and urlencode it
    (setq search-term (buffer-substring-no-properties start end))
    (setq search-term (replace-regexp-in-string "[[:space:]\n]+" "+" search-term))
    ;; Open in an external browser
    (browse-url (concat "https://www.startpage.com/search?q=" search-term))))

(use-package file-info)

(setq my/push-block-spec
  '(
     ("~/repos/selected-window-accent-mode/TODO.org" ;; source-file
       "~/repos/selected-window-accent-mode/README.org" ;; export-file
       "" ;; source-start-tag
       "" ;; source-end-tag
       "* TODOs / ROADMAP\n" ;; export-start-tag
       "\n* Testing" ;; export-end-tag
       :ascii ;; format-spec
       "  ") ;; prefix-string
     ("~/repos/selected-window-accent-mode/README.org"
       "~/repos/selected-window-accent-mode/selected-window-accent-mode.el"
       "\\*\\* selected-window-accent-fringe-thickness"
       "\\*\\* selected-window-accent-custom-color"
       "defcustom selected-window-accent-fringe-thickness 6\n  \""
       "\"\n  \\:type"
       :ascii
       " ")
     ("~/repos/selected-window-accent-mode/README.org"
       "~/repos/selected-window-accent-mode/selected-window-accent-mode.el"
       "\\*\\* selected-window-accent-custom-color"
       "\\*\\* selected-window-accent-mode"
       "defcustom selected-window-accent-custom-color nil\n  \""
       "\"\n  \\:type"
       :ascii
       " ")
     ("~/repos/selected-window-accent-mode/README.org"
       "~/repos/selected-window-accent-mode/selected-window-accent-mode.el"
       "\\*\\* selected-window-accent-mode"
       "\\*\\* selected-window-accent-mode-style"
       "defcustom selected-window-accent-mode nil\n  \""
       "\"\n  \\:type"
       :ascii
       " ")
     ("~/repos/selected-window-accent-mode/README.org"
       "~/repos/selected-window-accent-mode/selected-window-accent-mode.el"
       "\\*\\* selected-window-accent-mode-style"
       "\\* Minor Mode"
       "defcustom selected-window-accent-mode-style \'default\n  \""
       "\"\n  \\:type"
       :ascii
       " ")
     ("~/repos/selected-window-accent-mode/README.org"
       "~/repos/selected-window-accent-mode/selected-window-accent-mode.el"
       ""
       ""
       ";;; Commentary:\n"
       ";; Code\n"
       :ascii
       ";; ")
     ("~/DCIM/content/art--all.org" "" "" "" "" "" :hugo "")
     ("~/DCIM/content/emacs--all.org" "" "" "" "" "" :hugo "")
     ("~/DCIM/content/kate--blog.org" "" "" "" "" "" :hugo "")
     ("~/DCIM/content/linux--all.org" "" "" "" "" "" :hugo "")
     ("~/DCIM/content/posts--all.org" "" "" "" "" "" :hugo "")
     )
  )

(setq my/push-black-flush-lines '("----" "====" "~~~~"))

(setq dst-valid '(:raw :org :ascii :hugo))

(defun my/push-block (&optional value)
  "Export content from one file to another in various formats and update files accordingly."
  (interactive "p")

  (dolist (item my/push-block-spec)
    (let* ((source-file (expand-file-name (nth 0 item)))
            (export-file (expand-file-name (nth 1 item)))
            (source-start-tag (nth 2 item))
            (source-end-tag (nth 3 item))
            (export-start-tag (nth 4 item))
            (export-end-tag (nth 5 item))
            (format-spec (nth 6 item))
            (prefix-string (nth 7 item))
            (tmp-file (make-temp-file "tmp"))
            (buff-contents "")
            (in-current (string-equal (expand-file-name (buffer-file-name)) source-file)))

      (access-file source-file "source file")
      (access-file export-file "export file")

      (if (or in-current (> value 1)) ;; should I process file?
        (if (memq format-spec dst-valid) ;; check for valid dst format
          (progn
            (pcase format-spec
              (:hugo
                (org-hugo-export-wim-to-md)
                (mapc 'shell-command
                  '("web rsync emacs" "web rsync art"
                     "web rsync dyerdwelling" "web rsync sway")))
              (save-excursion ;; other org processing
                (when (and (stringp source-start-tag) (stringp source-end-tag)
                        (not (string-empty-p source-start-tag)) (not (string-empty-p source-end-tag)))
                  (goto-char (point-min))
                  (re-search-forward source-start-tag nil t)
                  (forward-line 1)
                  (let ((start (point)))
                    (re-search-forward source-end-tag nil t)
                    (forward-line -1)
                    (narrow-to-region start (point))))

                ;; perform the export
                (pcase format-spec
                  (:raw (write-region (point-min)(point-max) tmp-file)) ;; just raw text
                  (progn
                    ;; lets go through org output
                    (org-export-to-file (pcase format-spec
                                          (:ascii 'ascii)
                                          (:html 'html)
                                          (:icalendar 'icalendar)
                                          (:latex 'latex)
                                          (:odt 'odt)) tmp-file)))
                (widen)
                ;; modify the export
                (with-temp-buffer
                  (insert-file-contents tmp-file)
                  ;; remove duplicates
                  (delete-duplicate-lines (point-min)(point-max) nil t nil)
                  ;; filter lines
                  (mapcar (lambda (x)
                            (goto-char (point-min))
                            (flush-lines x)) my/push-black-flush-lines)
                  ;; apply prefix
                  (when (not (s-blank-p prefix-string))
                    (goto-char (point-min))
                    (while (search-forward-regexp "^" nil t)
                      (replace-match prefix-string)))
                  (whitespace-cleanup)
                  ;; write to file
                  (setq buff-contents (buffer-substring (point-min)(buffer-size))))

                ;; transplant src block to dst block
                (with-temp-buffer
                  (insert-file-contents export-file)
                  (goto-char (point-min))
                  (re-search-forward export-start-tag nil t)
                  ;; delete destination region
                  (let ((insert-point (point)))
                    (re-search-forward export-end-tag nil t)
                    (backward-char (length export-end-tag))
                    (delete-region insert-point (point)))
                  ;; insert transformed input
                  (insert buff-contents)
                  ;; write to file
                  (write-region (point-min)(point-max) export-file))
                ) ;; save-excursion
              ) ;; pcase format-spec
            ) ;; progn if dst-valid
          (message (format "Invalid format-spec %s not in %s" format-spec dst-valid))
          ) ;; if mdemq
        ;; (message (format "%s %s not processed" source-file export-file))
        ) ;; end if in-current value
      ) ;; let
    ) ;; dolist
  ) ;; defun

(defun my/dired-async-mode-line-message (text face &rest args)
  "Notify end of operation in `mode-line'."
  (message "Dired Async has finished!!")
  (let ((mode-line-format (concat
                           " " (propertize
                                (if args
                                    (apply #'format text args)
                                  text)
                                 'face
                                 '(:background "#ff0000" :foreground "#ffffff" :inherit bold)
                                 ))))
    (force-mode-line-update)
    (sit-for 8)
    (force-mode-line-update)))

(setq dired-async-message-function 'my/dired-async-mode-line-message)
