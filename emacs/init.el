;;
;; -> packages
;;
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;;(setq package-archives '(("melpa" . "~/emacs-pkgs/melpa")
;;                          ("elpa" . "~/emacs-pkgs/elpa")
;;                          ("org" . "~/emacs-pkgs/org-mode/lisp")))

(package-initialize)
(package-refresh-contents)
;; (unless package-archive-contents
;; (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose t)
(setq warning-minimum-level :emergency)

;;
;; -> packages (extra)
;;
(add-to-list 'load-path "/home/jdyer/emacs-pkgs/new/fd-find")
(require 'fd-find)
(add-to-list 'load-path "/home/jdyer/emacs-pkgs/new/tmtxt-async-tasks")
(require 'tmtxt-async-tasks)
(add-to-list 'load-path "/home/jdyer/emacs-pkgs/new/tmtxt-dired-async")
(require 'tmtxt-dired-async)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

;;
;; -> linux specific
;;
(setq home-dir "~")

;;
;; -> mail
;;
(require 'mu4e)

(setq my/unified-inbox
      (concat "maildir:/james@dyerdwelling.family/INBOX OR "
              "maildir:/gmail/INBOX OR "
              "maildir:/jimbob@dyerdwelling.family/INBOX OR "
              "maildir:/gmail/[Gmail]/All Mail"))

(setq my/unified-sent
      (concat "maildir:/james@dyerdwelling.family/Sent OR "
              "maildir:/gmail/[Gmail]/Sent Mail OR "
              "maildir:/jimbob@dyerdwelling.family/Sent"))

(setq my/unified-trash
      (concat "maildir:/james@dyerdwelling.family/Trash OR "
              "maildir:/gmail/[Gmail]/Trash OR "
              "maildir:/jimbob@dyerdwelling.family/Trash"))

(defun my-mu4e-view-rendered-hook ()
  (select-window (get-buffer-window "*mu4e-headers*")))

(use-package mu4e
  :ensure nil
  :defer 30
  :init (mu4e t)
  :config
  (add-hook 'mu4e-view-rendered-hook #'my-mu4e-view-rendered-hook t)
  :bind
  ("C-c m" . mu4e)
  (:map mu4e-headers-mode-map
        ("d" . mu4e-headers-mark-for-move))
  (:map mu4e-view-mode-map
        ("d" . mu4e-view-mark-for-move))
  :custom
  (smtpmail-smtp-server "mail.dyerdwelling.family")
  (smtpmail-smtp-service 25)
  (send-mail-function 'smtpmail-send-it)
  (user-mail-address "james@dyerdwelling.family")
  (mu4e-update-interval 600)
  (mu4e-attachment-dir "~/Downloads")
  (mu4e-compose-signature-auto-include nil)
  (mu4e-drafts-folder "/james@dyerdwelling.family/Drafts")
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-maildir "~/Maildir")
  (mu4e-refile-folder "/james@dyerdwelling.family/Archive")
  (mu4e-sent-folder "/james@dyerdwelling.family/Sent")
  (mu4e-search-threads nil)
  (mu4e-search-sort-field :date)
  (mu4e-bookmarks
   `(
     (:name "Unified Inbox" :query ,my/unified-inbox :key ?i)
     (:name "Unified Sent"      :query ,my/unified-sent :key ?s)
     (:name "Unified Trash" :query ,my/unified-trash :key ?t)
     (:name "Big messages"      :query "size:5M..500M" :key 98)
     (:name "Messages with images" :query "mime:image/*" :key 112)
     ))
  (mu4e-maildir-shortcuts
   '(
     ("/james@dyerdwelling.family/INBOX" . ?i)
     ("/james@dyerdwelling.family/Drafts" . ?d)
     ("/james@dyerdwelling.family/Sent" . ?s)
     ("/james@dyerdwelling.family/Archive" . ?a)
     ("/james@dyerdwelling.family/Trash" . ?t)
     ;; ("/james@dyerdwelling.family/spam" . ?p)
     ("/jimbob@dyerdwelling.family/INBOX" . ?m)
     ("/jimbob@dyerdwelling.family/Sent" . ?e)
     ("/jimbob@dyerdwelling.family/Trash" . ?r)
     ("/gmail/INBOX" . ?g)
     ("/gmail/[Gmail]/Sent Mail" . ?n)
     ("/gmail/[Gmail]/All Mail" . ?l)
     ("/gmail/[Gmail]/Trash" . ?w)
     ("/gmail/[Gmail]/Chats" . ?c)
     ))
  (mu4e-trash-folder "/james@dyerdwelling.family/Trash")
  (mu4e-use-fancy-chars t)
  (mu4e-view-show-addresses t)
  (mu4e-change-filenames-when-moving t)
  (mu4e-headers-visible-columns 100)
  (mu4e-completing-read-function 'completing-read)
  (mu4e-split-view 'vertical)
  (mu4e-view-show-images t)
  (mu4e-headers-fields '((:flags      . 6)
                         (:maildir   . 6)
                         (:human-date . 12)
                         (:from-or-to . 20)
                         (:size      . 6)
                         (:subject   . nil))))

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
;; -> simple use
;;
(use-package company)
(use-package ada-mode)
(use-package highlight-indentation)
(use-package yaml-mode)
(use-package toml-mode)
(use-package indent-tools)

(use-package hydra
  :ensure t ;; only if it's not already installed
  :bind (("C-q" . hydra-jump-to-directory/body))
  :config
  (defhydra hydra-jump-to-directory
    (:exit t)
    "Jump to directory"
    ("n" (find-file (concat home-dir "/nas")) "nas")
    ("d" (find-file deft-directory) "content")
    ("t" (find-file (concat deft-directory "/aaa--todo.org")) "todo")
    ("s" (find-file (concat deft-directory "/aa--source_code.org")) "src")
    ("j" (find-file home-dir) "home")
    ("i" (find-file (concat home-dir "/.emacs.d/image-dired")) "image-dired")
    ("b" (find-file (concat home-dir "/bin")) "bin")
    ("e" (find-file (concat home-dir "/.emacs")) ".emacs")
    ("m" (find-file (concat home-dir "/DCIM")) "DCIM")
    ("c" (find-file (concat home-dir "/DCIM/Camera")) "Camera")
    ("r" (find-file (concat home-dir "/DCIM/Screenshots")) "screenshots")
    ("q" nil "Quit" :color blue)))

(use-package rainbow-mode
  :ensure t
  :hook (prog-mode . rainbow-mode))

;;
;; -> other use
;;
(use-package org
  :config
  (setq org-tags-sort-function 'org-string-collate-greaterp)
  (setq org-agenda-include-diary t)
  (setq org-export-with-sub-superscripts nil)
  (setq org-hugo-base-dir "~/DCIM")
  (setq org-image-actual-width (list 50))
  (setq org-log-done 'time)
  (setq org-startup-folded t)
  (setq org-startup-indented t)
  (setq org-startup-with-inline-images t)
  (setq org-tags-column 0)
  (setq org-toggle-link-display 1)
  (setq org-todo-keywords
        '((sequence "TODO" "DOIN" "WAIT" "IGNR" "ORDR" "SENT" "ARRV" "|" "CANC" "DONE")))
  (setq org-todo-keyword-faces
        '(("TODO" . "#e56")
          ("DOIN" . "#57a")
          ("WAIT" . "#b74")
          ("IGNR" . "#b7e")
          ("ORDR" . "#b4e")
          ("SENT" . "#b4e")
          ("ARRV" . "#f52")
          ("CANC" . "#a32")
          ("DONE" . "#7a6")))
  )

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-ai
  :commands (org-ai-mode org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode)
  (org-ai-global-mode))

(use-package org-rainbow-tags
  :hook
  (org-mode . org-rainbow-tags-mode)
  :config
  (setq org-rainbow-tags-mode 1))

(use-package visual-fill-column
  :config
  (setq visual-fill-column-center-text t))

(use-package embark-consult)
(use-package lorem-ipsum)
(use-package ztree)
(use-package find-file-rg)
(use-package gruvbox-theme)
(use-package ef-themes)
(use-package doom-themes)
(use-package dwim-shell-command)
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
  (dired-rainbow-define-chmod directory "#0074d9" "d.*")
  (dired-rainbow-define html "#eb5286"
                        ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht"
                         "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024"
                        ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg"
                         "pgn" "rss" "yaml" "yml" "rdata" "sln" "csproj"
                         "meta" "unity" "tres" "tscn" "import" "godot"))
  (dired-rainbow-define document "#9561e2"
                        ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps"
                         "rtf" "djvu" "epub" "odp" "ppt" "pptx" "xls" "xlsx"
                         "vsd" "vsdx" "plantuml"))
  (dired-rainbow-define markdown "#4dc0b5"
                        ("org" "org_archive" "etx" "info" "markdown" "md"
                         "mkd" "nfo" "pod" "rst" "tex" "texi" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd"
                        ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f"
                        ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv"
                         "ogg" "mov" "mid" "midi" "wav" "aiff" "flac" "mkv"))
  (dired-rainbow-define image "#f66d9b"
                        ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png"
                         "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11"
                        ("log" "log.1" "log.2" "log.3" "log.4" "log.5" "log.6"
                         "log.7" "log.8" "log.9"))
  (dired-rainbow-define shell "#f6993f"
                        ("awk" "bash" "bat" "fish" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172"
                        ("py" "ipynb" "hy" "rb" "pl" "t" "msql" "mysql"
                         "pgsql" "sql" "r" "clj" "cljs" "cljc" "cljx" "edn"
                         "scala" "js" "jsx" "lua" "fnl" "gd"))
  (dired-rainbow-define compiled "#6cb2eb"
                        ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp"
                         "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn"
                         "f90" "f95" "f03" "f08" "s" "rs" "active" "hs"
                         "pyc" "java"))
  (dired-rainbow-define executable "#8cc4ff"
                        ("com" "exe" "msi"))
  (dired-rainbow-define compressed "#51d88a"
                        ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar"
                         "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar" "rar"))
  (dired-rainbow-define packaged "#faad63"
                        ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf"
                         "vpk" "bsp"))
  (dired-rainbow-define encrypted "#f2d024"
                        ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12"
                         "pem"))
  (dired-rainbow-define fonts "#f6993f"
                        ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf" "woff"
                         "woff2" "eot"))
  (dired-rainbow-define partition "#e3342f"
                        ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk"
                         "bak"))
  (dired-rainbow-define vc "#6cb2eb"
                        ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define config "#5040e2"
                        ("cfg" "conf"))
  (dired-rainbow-define certificate "#6cb2eb"
                        ("cer" "crt" "pfx" "p7b" "csr" "req" "key"))
  (dired-rainbow-define junk "#7F7D7D"
                        ("DS_Store" "projectile"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")

  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (equal major-mode 'dired-mode)
        (font-lock-refresh-defaults)))))

;;
;; -> magit
;;
(use-package magit
  :init
  (defhydra hydra-magit (:exit t)
    "Magit"
    ("s" magit-status "status")
    ("c" magit-clone "clone")
    ("l" magit-list-repositories "list all")
    ("q" nil "quit"))
  :bind
  ("C-c g" . hydra-magit/body)
  :config
  (unbind-key "M-1" magit-mode-map)
  (unbind-key "M-2" magit-mode-map)
  (unbind-key "M-3" magit-mode-map)
  (unbind-key "M-4" magit-mode-map)
  :custom
  (magit-section-initial-visibility-alist (quote ((untracked . hide))))
  (magit-repolist-column-flag-alist
   '((magit-untracked-files . "N")
     (magit-unstaged-files . "U")
     (magit-staged-files . "S")))
  (magit-repolist-columns
   '(
     ("Name" 25 magit-repolist-column-ident nil)
     ("" 3 magit-repolist-column-flag)
     ("Version" 25 magit-repolist-column-version
      ((:sort magit-repolist-version<)))
     ("B<U" 3 magit-repolist-column-unpulled-from-upstream
      ((:right-align t)
       (:sort <)))
     ("B>U" 3 magit-repolist-column-unpushed-to-upstream
      ((:right-align t)
       (:sort <)))
     ("Path" 99 magit-repolist-column-path nil))
   )
  (magit-repository-directories
   '(
     ("/home/jdyer" . 0)
     ("/home/jdyer/bin" . 0)
     ("/home/jdyer/emacs-pkgs/new" . 2)
     ("/home/jdyer/DCIM/publish/hugo-katieboo85" . 0)
     ("/home/jdyer/DCIM/Art/Content" . 2)
     ("/home/jdyer/DCIM/themes" . 2)
     ("/home/jdyer/DCIM/content" . 0)
     )
   )
  )

;;
;; -> doom-modeline
;;
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-enable-word-count t)
  (doom-modeline-hud t)
  (doom-modeline-buffer-file-name-style 'truncate-nil)
  (doom-modeline-height 20)
  (doom-modeline-bar-width 2))

;;
;; -> emms
;;
(use-package emms
  :init (emms-all)
  :hook
  (emms-browser-mode . turn-on-follow-mode)
  (emms-browser-mode . hl-line-mode)
  :bind
  ("S-<f2>" . emms)
  ("<f2>" . emms-browse-by-album)
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
;; -> keys
;;
(bind-key* (kbd "M-S") 'consult-org-heading)
(bind-key* (kbd "M-g i") 'imenu)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "M-q") 'my/pure-paragraph-refill)
(global-set-key (kbd "C-c d") (lambda()(interactive)(dired deft-directory)))
(global-set-key (kbd "M->") (lambda()(interactive)(end-of-buffer)(recenter)))
(global-set-key (kbd "C-c j") 'winner-undo)
(global-set-key (kbd "C-c k") 'winner-redo)
(global-set-key (kbd "M-<backspace>") (lambda()(interactive)(delete-region (point)(progn (backward-word) (point)))))
(global-set-key (kbd "M-d") (lambda()(interactive)(delete-region (point)(progn (forward-word) (point)))))
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
(global-set-key (kbd "<f12>") 'xref-find-definitions)
(global-set-key (kbd "S-<f12>") 'my/grep)
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
(global-set-key [f4] 'my/eshell)
(global-set-key (kbd "C-`") 'my/eshell)
(global-set-key [f5] 'gud-cont)
;; (global-set-key [f6] 'find-file-vanilla)
(global-set-key [f6] 'find-file-rg)
(global-set-key [f6] 'fd-find-complete)
(global-set-key [f7] 'display-fill-column-indicator-mode)
(global-set-key [f8] 'next-error)
(global-set-key (kbd "C-M-m") 'next-error)
(global-set-key [S-f8] 'find-file-rg-at-point)
(global-set-key [f9] 'gud-break)
(global-set-key [f10] 'gud-next)
(global-set-key [f11] 'gud-step)
(global-set-key (kbd "C-c i d") '(lambda () (interactive)(insert (format-time-string "<%Y-%m-%d>"))))
(global-set-key (kbd "C-c i t") '(lambda () (interactive)(insert (format-time-string "%Y%m%d%H%M%S"))))
(define-key dired-mode-map (kbd "C") 'my/rsync)
(define-key dired-mode-map (kbd "?") 'my/get-file-size)
(define-key dired-mode-map (kbd "C-<return>") 'browse-url-of-dired-file)
(define-key dired-mode-map (kbd "C-t d") 'my/image-dired-sort)
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
(tooltip-mode -1)
(transient-mark-mode 1)
(winner-mode 1)

;;
;; -> setqs
;;
;; (setq-default mode-line-format "%b")
(setq dired-dwim-target t)
;; (setq dired-guess-shell-alist-default
;;   (append '(("\\.\\(jpg\\|jpeg\\|png\\|gif\\|bmp\\)$" "gwenview")
;;              ("\\t.\\(mp4\\|mkv\\|avi\\|mov\\|wmv\\|flv\\|mpg\\)$" "mpv"))
;;     dired-guess-shell-alist-default))
(setq window-persistent-parameters
      '((parent-id . nil)
        (outer-window-id . nil)
        (window-id . nil)
        (clone-of . t)))
(setq tramp-default-method "ssh")
(setq enable-local-variables t)
(setq proced-auto-update-interval 1)
(setq compilation-always-kill t)
(setq compilation-context-lines 3)
(setq compilation-scroll-output nil)
(setq isearch-lazy-count t)
(setq shr-max-image-proportion 0.5)
(setq shr-max-width 80)
(setq shr-width 70)
(setq truncate-partial-width-windows t)
(setq tooltip-hide-delay 60)
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
(setq image-dired-external-viewer "/usr/bin/gwenview")
(setq image-dired-show-all-from-dir-max-files 999)
(setq image-dired-thumbs-per-row 999)
(setq image-dired-thumb-margin 5)
(setq image-dired-thumb-size 10)
(setq image-dired-thumb-height 100)
(setq image-dired-thumb-width 100)
(setq image-dired-thumb-size 100)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
;; (setq inhibit-message -1)
(setq kill-whole-line t)
(setq large-file-warning-threshold nil)
(setq reb-re-syntax 'string)
(setq require-final-newline t)
(setq truncate-lines t)
(setq visible-bell nil)
(setq wdired-allow-to-change-permissions t)
(setq diary-show-holidays-flag nil)
(setq suggest-key-bindings nil)
(setq image-use-external-converter t)
(setq-default display-line-numbers-width 0)
(setq-default abbrev-mode t)
(setq diary-file (concat home-dir "/DCIM/content/diary.org"))
(setq frame-title-format "%f")

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
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t          ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 10   ; how many of the newest versions to keep
      kept-old-versions 5)    ; and how many of the old

;;
;; -> hooks
;;
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'calendar-mode-hook 'diary-mark-entries)
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
(add-hook 'proced-mode-hook 'proced-settings)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)
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
    '(jinx powerthesaurus marginalia orderless vertico elfeed emms doom-modeline magit dired-rainbow deadgrep ox-hugo dwim-shell-command doom-themes ef-themes gruvbox-theme find-file-rg ztree lorem-ipsum embark-consult visual-fill-column org-rainbow-tags org-ai org-bullets toc-org rainbow-mode indent-tools toml-mode yaml-mode highlight-indentation ada-mode company use-package))
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
  (if (equal major-mode 'dired-mode)
      (setq search-term
            (read-from-minibuffer "Search : "))
    (setq search-term
          (read-from-minibuffer "Search : " (thing-at-point 'symbol)))
    )
  (deadgrep search-term default-directory))

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
  (rx bos "*" (or "Async")
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

;;
;; -> skeletons
;;
(define-skeleton org-image-size-skel
  "Org properties skeleton."
  "\n"
  "#+attr_org: :width 300px\n"
  "#+attr_html: :width 100%")

(define-skeleton hugo-column-start
  "Split org file into column skeleton."
  "\n"
  "\n#+begin_export md\n"
  "{{< columns 12 12 6 6 6 >}}\n"
  "#+end_export\n")

(define-skeleton hugo-column-split
  "Split org file into column skeleton."
  "\n"
  "\n---||---\n")

(define-skeleton hugo-column-end
  "Split org file into column skeleton."
  "\n"
  "\n#+begin_export md\n"
  "{{< \/columns >}}\n"
  "#+end_export\n")

(define-skeleton hugo-column-video
  "Video hugo link."
  "\n"
  "\n#+begin_export md\n"
  "{{\< video src=\"\/art--videos\/\" \>}}"
  "\n#+end_export\n")

(define-abbrev-table 'global-abbrev-table
  '(
    ("jdimg" "" org-image-size-skel)
    ("jdcol1" "" hugo-column-start)
    ("jdcol2" "" hugo-column-split)
    ("jdcol3" "" hugo-column-end)
    ("jdvid" "" hugo-column-video)
    ("btw" "by the way" nil)
    )
  )

;;
;; org capture
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
{{< columns 12 12 6 6 6 >}}
#+end_export
%?
---||---
#+begin_export md
{{< /columns >}}
#+end_export
" :prepend t :jump-to-captured t)

        ("e" "Emacs" plain
         (file+headline
          ,(concat home-dir "/DCIM/content/emacs--all.org")
          "Emacs")
         "** TODO %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>-emacs--%\\1
:EXPORT_HUGO_SECTION: emacs
:EXPORT_HUGO_LASTMOD: <%<%Y-%m-%d>>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /emacs/%<%Y%m%d%H%M%S>-emacs--%\\1.jpg
:END:
#+begin_export md
{{< columns 12 12 6 6 6 >}}
#+end_export
%?
---||---
#+begin_export md
{{< /columns >}}
#+end_export
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
#+begin_export md
{{< columns 12 12 6 6 6 >}}
#+end_export
%?
---||---
#+begin_export md
{{< /columns >}}
#+end_export
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
:END:
#+begin_export md
{{< columns 12 12 6 6 6 >}}
#+end_export
#+begin_export md
{{< youtube %^{youtube} >}}
#+end_export
---||---
%?
#+begin_export md
{{< /columns >}}
#+end_export
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
:END:
#+begin_export md
{{< columns 12 12 6 6 6 >}}
#+end_export
#+attr_org: :width 300px
#+attr_html: :width 100%
#+begin_export md
#+end_export
---||---
%?
#+begin_export md
{{< /columns >}}
#+end_export
" :prepend t :jump-to-captured t)

        ("ai" "Art AI" plain
         (file+headline
          ,(concat home-dir "/DCIM/content/art--2018-now.org")
          "Art")
         "** TODO %<%Y%m%d%H%M%S>--AI %^{title} :2023:
:PROPERTIES:
:EXPORT_FILE_NAME: %<%Y%m%d%H%M%S>--%\\1
:EXPORT_HUGO_SECTION: art--ai
:EXPORT_HUGO_LASTMOD: %<%Y-%m-%d>
:EXPORT_HUGO_CUSTOM_FRONT_MATTER+: :thumbnail /art--ai/%<%Y%m%d%H%M%S>--%\\1.jpg
:END:
Here is more experimentation using [[https://playgroundai.com]] and
passing in some of my art!

This was the orignal piece:

to produce the following:

%?" :prepend t :jump-to-captured t)

        )
      )

;;
;; -> dwim
;;
(defun my/dwim-convert-nospace () "" (interactive)
       (dwim-shell-command-on-marked-files
        "ConvertNoSpace"
        "ConvertNoSpace '<<*>>'" :silent-success t))

(defun my/dwim-audio-convert () "" (interactive)
       (dwim-shell-command-on-marked-files
        "AudioConvert"
        "AudioConvert '<<*>>'" :silent-success t))

(defun my/dwim-audio-info () "" (interactive)
       (dwim-shell-command-on-marked-files
        "AudioInfo"
        "AudioInfo '<<*>>'" :silent-success t))

(defun my/dwim-audio-normalise () "" (interactive)
       (dwim-shell-command-on-marked-files
        "AudioNormalise"
        "AudioNormalise '<<*>>'" :silent-success t))

(defun my/dwim-audio-trim-silence () "" (interactive)
       (dwim-shell-command-on-marked-files
        "AudioTrimSilence"
        "AudioTrimSilence '<<*>>'" :silent-success t))

(defun my/dwim-picture-auto-colour () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureAutoColour"
        "PictureAutoColour '<<*>>'" :silent-success t))

(defun my/dwim-picture-convert () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureConvert"
        "PictureConvert '<<*>>'" :silent-success t))

(defun my/dwim-picture-crush () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureCrush"
        "PictureCrush '<<*>>'" :silent-success t))

(defun my/dwim-picture-info () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureInfo"
        "PictureInfo '<<*>>'" :silent-success nil))

(defun my/dwim-picture-montage () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureMontage"
        "PictureMontage '<<*>>'" :silent-success t))

(defun my/dwim-picture-organise () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureOrganise"
        "PictureOrganise '<<*>>'" :silent-success t))

(defun my/dwim-picture-rotate-flip () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureRotateFlip"
        "PictureRotateFlip '<<*>>'" :silent-success t))

(defun my/dwim-picture-rotate-left () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureRotateLeft"
        "PictureRotateLeft '<<*>>'" :silent-success t))

(defun my/dwim-picture-rotate-right () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureRotateRight"
        "PictureRotateRight '<<*>>'" :silent-success t))

(defun my/dwim-picture-scale () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureScale"
        "PictureScale '<<*>>'" :silent-success t))

(defun my/dwim-picture-upscale () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureUpscale"
        "PictureUpscale '<<*>>'" :silent-success t))

(defun my/dwim-picture-get-text () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureGetText"
        "PictureGetText '<<*>>'" :silent-success t))

(defun my/dwim-picture-orientation () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureOrientation"
        "PictureOrientation '<<*>>'" :silent-success t))

(defun my/dwim-video-concat () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoConcat"
        "VideoConcat '<<*>>'" :silent-success nil))

(defun my/dwim-video-convert () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoConvert"
        "VideoConvert '<<*>>'" :silent-success t))

(defun my/dwim-video-cut () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoCut"
        "VideoCut '<<*>>'" :silent-success t))

(defun my/dwim-video-double () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoDouble"
        "VideoDouble '<<*>>'" :silent-success t))

(defun my/dwim-video-extract-audio () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoExtractAudio"
        "VideoExtractAudio '<<*>>'" :silent-success t))

(defun my/dwim-video-extract-frames () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoExtractFrames"
        "VideoExtractFrames '<<*>>'" :silent-success t))

(defun my/dwim-video-filter () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoFilter"
        "VideoFilter '<<*>>'" :silent-success t))

(defun my/dwim-video-from-frames () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoFromFrames"
        "VideoFromFrames '<<*>>'" :silent-success t))

(defun my/dwim-video-info () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoInfo"
        "VideoInfo '<<*>>'" :silent-success nil))

(defun my/dwim-video-remove-audio () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoRemoveAudio"
        "VideoRemoveAudio '<<*>>'" :silent-success t))

(defun my/dwim-video-replace-video-audio () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoReplaceVideoAudio"
        "VideoReplaceVideoAudio '<<*>>'" :silent-success t))

(defun my/dwim-video-rescale () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoRescale"
        "VideoRescale '<<*>>'" :silent-success t))

(defun my/dwim-video-reverse () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoReverse"
        "VideoReverse '<<*>>'" :silent-success t))

(defun my/dwim-video-rotate () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoRotate"
        "VideoRotate '<<*>>'" :silent-success t))

(defun my/dwim-video-rotate-left () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoRotateLeft"
        "VideoRotateLeft '<<*>>'" :silent-success t))

(defun my/dwim-video-rotate-right () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoRotateRight"
        "VideoRotateRight '<<*>>'" :silent-success t))

(defun my/dwim-video-shrink () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoShrink"
        "VideoShrink '<<*>>'" :silent-success t))

(defun my/dwim-video-slow-down () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoSlowDown"
        "VideoSlowDown '<<*>>'" :silent-success t))

(defun my/dwim-video-speed-up () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoSpeedUp"
        "VideoSpeedUp '<<*>>'" :silent-success t))

(defun my/dwim-video-zoom () "" (interactive)
       (dwim-shell-command-on-marked-files
        "VideoZoom"
        "VideoZoom '<<*>>'" :silent-success t))

(defun my/dwim-video-whatsapp-convert () "" (interactive)
       (dwim-shell-command-on-marked-files
        "WhatsAppConvert"
        "WhatsAppConvert '<<*>>'" :silent-success t))

(defun my/dwim-picture-correct () "" (interactive)
       (dwim-shell-command-on-marked-files
        "PictureCorrect"
        "PictureCorrect '<<*>>'" :silent-success t))

(defun my/dwim-picture-2-pdf () "" (interactive)
       (dwim-shell-command-on-marked-files
        "Picture2pdf"
        "Picture2pdf '<<*>>'" :silent-success t))

(defun my/dwim-other-tag-date () "" (interactive)
       (dwim-shell-command-on-marked-files
        "OtherTagDate"
        "OtherTagDate '<<*>>'" :silent-success t))

;;
;; -> visuals
;;
(set-cursor-color "yellow")

;; (set-frame-font "MesloLGS Nerd Font Mono 12" nil t)
;; (set-frame-font "Source Code Pro 12" nil t)
;; (set-frame-font "Noto Sans Mono 12" nil t)
;; (set-frame-font "Nimbus Mono PS 12" nil t)
;; (set-frame-font "MesloLGS Nerd Font Mono 12" nil t)
;; (set-frame-font "Droid Sans Mono 13" nil t)
;; (set-frame-font "Hack Nerd Font Mono 13" nil t)
(set-frame-font "Hack Nerd Font Mono 13" nil t)

;; the set-frame-font doesn't seem to work in server / client mode
(add-to-list 'default-frame-alist '(font . "Hack Nerd Font Mono 13"))

;;
;; -> custom set-faces
;;
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-search-title-face ((t (:foreground "#4E4E4E" :height 1.2 :family "Source Code Pro"))))
 '(mode-line ((t (:background "#000000" :foreground "#f4f4f4" :box nil)))))

;;
;; -> visual truncation and line wrapping
;;
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook '(lambda () (visual-line-mode)))
(setq truncate-partial-width-windows 140)

;;
;; -> spelling
;;
(setq flyspell-issue-message-flag nil)
(setq ispell-local-dictionary "en_GB")
(setq ispell-program-name "hunspell")
(global-dictionary-tooltip-mode 1)
(setq dictionary-default-dictionary "*")
(setq dictionary-server "dict.org")
(setq dictionary-use-single-buffer t)
(add-hook 'dictionary-post-buffer-hook (lambda()(interactive)(end-of-buffer)))

(use-package powerthesaurus
  :init
  (defhydra hydra-powerthesaurs (:exit t)
    "PowerThesaurus"
    ("s" powerthesaurus-lookup-synonyms-dwim "synonyms")
    ("a" powerthesaurus-lookup-antonyms-dwim "antonyms")
    ("f" flyspell-mode "flyspell")
    ("l" jinx-correct "spell")
    ("t" dictionary-lookup-definition "thesaurus")
    ("q" nil "quit"))
  :bind
  ("C-c s" . hydra-powerthesaurs/body))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

;;
;; -> tests
;;
;; to be able to attach from dired
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(defun my/hugo-org-export-post-processing (file)
  "My/org-export-hook."
  (progn
    (with-temp-buffer
      (insert-file-contents file)

      ;; make sure quotes are around the tag list
      ;; for compatibility with netlify
      (goto-char (point-min))
      (search-forward-regexp "^tags = \\[\\(.*\\)\\]$" nil t)
      (setq str (s-trim (match-string 1)))
      (setq str (replace-regexp-in-string "\"" "" str))
      (setq wrd (split-string str "," t " "))
      (setq new
            (concat
             "[\""
             (s-join "\", \"" wrd)
             "\"]")
            )
      (goto-char (point-min))
      (while (search-forward-regexp "^tags = \\(\\[.*\\]\\)$" nil t)
        (replace-match new nil nil nil 1))

      ;; author
      (goto-char (point-min))
      (search-forward-regexp "^author = \\[\\(.*\\)\\]$" nil t)
      (setq str (s-trim (match-string 1)))
      (setq str (replace-regexp-in-string "\"" "" str))
      (setq wrd (split-string str "," t " "))
      (setq new
            (concat
             "\""
             (s-join "\", \"" wrd)
             "\"")
            )
      (goto-char (point-min))
      (while (search-forward-regexp "^author = \\(\\[.*\\]\\)$" nil t)
        (replace-match new nil nil nil 1))

      ;; replace any other strings
      (replace-string "~/DCIM/static" "" nil (point-min) (point-max))

      ;; write changes to the file
      (message (concat "Writing org-post-processing to : " file))
      (write-region (point-min) (point-max) file)
      )
    )
  )

(defun my/hugo-org-export-files-in-directory (directory)
  "Process all markdown (.md) files in DIRECTORY using a defined function."
  (interactive "DChoose a directory to process md files: ")
  (dolist (file (directory-files directory t "\\.md$"))
    (my/hugo-org-export-post-processing file)))

(defun my/hugo-org-export-subtree ()
  "Hugo export processing."
  (interactive)
  (org-hugo-export-wim-to-md)
  (shell-command "web rsync emacs"))

;; (save-excursion
;;   (re-search-backward ":PROPERTIES:" nil t)
;;   (let* ((export-path (concat "~/DCIM/content/" (org-entry-get (point) "EXPORT_HUGO_SECTION") "/"))
;;           (export-file (concat export-path(concat (org-entry-get (point) "EXPORT_FILE_NAME") ".md"))))
;;     (message export-file)
;;     (my/hugo-org-export-post-processing export-file))))

(global-set-key (kbd "C-c x") #'my/hugo-org-export-subtree)

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

;; (setq-default mode-line-format
;;   '("%e"
;;      ;; mode-line-front-space
;;      ;; mode-line-mule-info
;;      ;; mode-line-client
;;      mode-line-modified
;;      ;; mode-line-remote
;;      ;; mode-line-frame-identification
;;      mode-line-buffer-identification
;;      "   "
;;      ;; mode-line-position
;;      ;; (vc-mode vc-mode)
;;      "  "
;;      ;; mode-line-modes
;;      mode-line-end-spaces
;;      ))

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

;; (eval-after-load "eglot.el"
;;   (progn
;;     (add-to-list 'eglot-ignored-server-capabilities :documentHighlightProvider)))

;; (eval-after-load "eglot.el"
;;   (progn
;;     (add-to-list 'eglot-stay-out-of 'progress)))


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

;;
;; -> development
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

(defun my/dired-duplicate-file ()
  "Duplicate the current file in Dired."
  (interactive)
  (let ((filename (dired-get-filename)))
    (copy-file filename (concat (file-name-sans-extension filename) "-old." (file-name-extension filename)))
    (revert-buffer)))

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
  (let* ((word (cond (prefix
                      (setq my/uniq-log-word
                            (read-string "Log word: ")))
                     ((region-active-p)
                      (setq my/uniq-log-word
                            (buffer-substring (region-beginning)
                                              (region-end))))
                     (my/uniq-log-word
                      my/uniq-log-word)
                     (t
                      "Reached")))
         (config
          (cond
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
