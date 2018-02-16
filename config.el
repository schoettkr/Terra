(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(require 'package)
  (setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
  ;; the following lines tell emacs where on the internet to look up
  ;; for new packages.
  (setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "https://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")
;;			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ))

  (package-initialize) ; guess what this one does ?

  ;; Bootstrap `use-package'
  (unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

  (require 'use-package) ; guess what this one does too ?

(setq delete-old-versions -1 )		; delete excess backup versions silently
  (setq version-control t )		; use version control
  (setq vc-make-backup-files t )		; make backups file even when in version controlled dir
  (setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
  (setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
  (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
  (setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen
  (setq ring-bell-function 'ignore )	; silent bell when you make a mistake
  (setq coding-system-for-read 'utf-8 )	; use utf-8 by default
  (setq coding-system-for-write 'utf-8 )
  (setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
  (setq default-fill-column 80)		; toggle wrapping text at the 80th character
  (setq-default tab-width 2)                    ; tab are 2 spaces large
  (setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup
  (setq tab-stop-list (number-sequence 2 120 2)) ;; set tab length
  (setq evil-want-C-u-scroll t) ;; scroll with C-u like in vim
;;(set-display-table-slot standard-display-table 'wrap ?\ )
  (set-display-table-slot standard-display-table 0 ?\ ) 
  (set-display-table-slot standard-display-table 'wrap ?\ )
  (setq-default indent-tabs-mode nil)
  
(mapc
 (lambda (face)
   (set-face-attribute face nil :weight 'normal :underline nil))
 (face-list))

(menu-bar-mode 0)
(tool-bar-mode 0)
(set-default-font "Fira Code 12")
;; (set-default-font "Hack 11")
;; (set-default-font "Source Code Pro 11")
;; (set-default-font "Fantasque Sans Mono 14")
(toggle-scroll-bar -1)
(set-fringe-mode 0) ;; deactivates gutters at screen edges on linebreak
(setq whitespace-line-column 999)
;;(set-window-fringes (selected-window) 0 0 nil)
;; (setq whitespace-style '(faces spaces indentation))
;;(use-package solarized-theme :ensure t)
(use-package gruvbox-theme :ensure t)
(use-package dracula-theme :ensure t)
(use-package badger-theme :ensure t)
(use-package color-theme-sanityinc-tomorrow :ensure t)
(use-package moe-theme :ensure t)
(use-package oceanic-theme :ensure t)
(use-package subatomic-theme :ensure t)
;; (load-theme 'github-modern t)
(load-theme 'subatomic t)
;; (moe-light)

;;(defun my-flymake-show-next-error()
;;    (interactive)
;;    (flymake-goto-next-error)
;;    (flymake-popup-current-error-menu)
;;    )

      (defun open-termite ()
        (interactive "@")
        (shell-command (concat "termite"
             " > /dev/null 2>&1 & disown") nil nil))
      (defun indent-buffer ()
        "Apply indentation rule to the entire buffer."
        (interactive)
        (delete-trailing-whitespace)
        (indent-region (point-min) (point-max)))

      (defun company-mode/backend-with-yas (backend)
        (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
            backend
          (append (if (consp backend) backend (list backend))
                  '(:with company-yasnippet))))

      (defun setup-tide-mode ()
        (interactive)
        (tide-setup)
        (flycheck-mode +1)
        (setq flycheck-check-syntax-automatically '(save mode-enabled))
        (eldoc-mode +1)
        (tide-hl-identifier-mode +1)
        ;; company is an optional dependency. You have to
        ;; install it separately via package-install
        ;; `M-x package-install [ret] company`
        (company-mode +1))

      (defun add-semicolon ()
        (interactive)
        (end-of-line)
        (when (not (looking-back ";"))
          (insert ";"))
        (evil-first-non-blank))

    (defvar counter 0)
    (defun popup-shell ()
      (interactive)
      (setq counter (+ counter 1))
      (setq title (concat "Terminal-" (number-to-string counter)))
      (setq buf-title (concat "*" title "*"))
      (ansi-term "/bin/zsh" buf-title)
      (mode-line-other-buffer)
      (split-window-below)
      (enlarge-window 15)
      (evil-window-down 1)
  )
      ;; (defun popup-shell ()
      ;;   (interactive)
      ;;   (ansi-term "/usr/bin/zsh" "terminal")
        ;; (split-window-below)
        ;; (mode-line-other-buffer)
        ;; (other-window 1)
        ;; (enlarge-window 15)
        ;; (/ (frame-height) 5)
        ;; (add-to-list 'default-frame-alist '(height . (/ (frame-height) 5)))
        ;; )

      ;; (defvar counter 0)
      ;; (defun popup-shell ()
      ;;   "Open a new terminal and rename the buffer"
      ;;   (interactive)
      ;;   (setq counter (+ counter 1))
      ;;   (setq title (concat "Terminal-" (number-to-string counter)))
      ;;   (setq buf-title (concat "*" title "*"))
      ;;   (message buf-title)
      ;;   (set-buffer (make-term title "/bin/zsh"))
        ;; (term-mode)
        ;; (term-char-mode)
        ;; (switch-to-buffer buf-title)
      ;; )

(global-set-key (kbd "<escape>")      'keyboard-escape-quit) ;; send quit signal with escape

(use-package general :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   :states '(normal emacs)
   "C-s" 'swiper             ; search for string in current buffer
;;   "C-p" 'company-select-previous             ; search for string in current buffer
;;   "C-n" 'company-select-next             ; search for string in current buffer
   "/" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
   "n" 'evil-search-previous
   "N" 'evil-search-next
   "\\" 'evil-ex-nohighlight
   ;; "C-w" 'evil-delete-buffer
   )

  (general-def :states '(normal motion emacs) "SPC" nil)

  (general-define-key
   :states '(normal motion emacs)
   :prefix "SPC"

   ;; simple command
   "x" 'counsel-M-x        ; replace default M-x with ivy backend
   "TAB" '(mode-line-other-buffer :which-key "prev buffer")
   "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")
   "C-'" 'avy-goto-word-1
   "qq"  '(save-buffers-kill-terminal :which-key "Save all & quit")
   "RET" '(add-semicolon :which-key "Insert ; at eol")
   "/" '(counsel-ag :which-key "Counsel ag search [everywhere]")
   ;; "'" '(ansi-term "/usr/bin/zsh" :which-key "popup shell")
   "'" '(popup-shell :which-key "popup shell")

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "aa" '(ag :which-key "Ag")
   "ar" '(ranger :which-key "Ranger")
   "at" '(open-termite :which-key "Termite")
   "ac" '(compile :which-key "compile")
   "ar" '(recompile :which-key "recompile")
   "ao" '(occur :which-key "occur") ;; example usage function\|var
   "ad" 'dired

   ;; Buffer
   "b" '(:ignore t :which-key "Buffer")
   "bb" '(ivy-switch-buffer :which-key "Change buffer")
   "bd" '(kill-buffer :which-key "kill buffer")
   "bp" '(switch-to-prev-buffer :which-key "prev buffer")
   "bn" '(switch-to-prev-buffer :which-key "next buffer")

   ;; ;; Flymake
   ;; "m" '(:ignore t :which-key "Major Mode")

   ;; Flymake
   "e" '(:ignore t :which-key "Flymake")
   "eh" '(flymake-popup-current-error-menu :which-key "show error msg")
   "en" '(flymake-goto-next-error :which-key "next error")
   "ep" '(flymake-goto-prev-error :which-key "prev error")

   ;; Files
   "f" '(:ignore t :which-key "Files")
   "ff" '(counsel-find-file :which-key "find file")
   "fr"	'(counsel-recentf   :which-key "recent files")
   "fs" '(save-buffer :which-key "save file")
   "f/" '(swiper :which-key "search in file")
   "ft" '(treemacs-toggle :which-key "toggle treemacs")

   ;; Git
   "g" '(:ignore t :which-key "Git")
   "gs" '(magit-status :which-key "status")

   ;; Help
   "h" '(:ignore t :which-key "Help")
   "hh" '(help-for-help-internal :which-key "open help")

   ;; Projects
   "p" '(:ignore t :which-key "Projects")
   "pf" '(counsel-git :which-key "Find file in git project")
   "p/" '(projectile-ag :which-key "Projectile ag search [in project]")
   "pp" '(projectile-switch-project :which-key "Switch project")

   ;; Windows
   "w" '(:ignore t :which-key "Windows")
   "w1" '(winum-select-window-1 :which-key "win 1")
   "w2" '(winum-select-window-2 :which-key "win 2")
   "w3" '(winum-select-window-3 :which-key "win 3")
   "w4" '(winum-select-window-4 :which-key "win 4")
   "w5" '(winum-select-window-5 :which-key "win 5")
   "w6" '(winum-select-window-6 :which-key "win 6")
   "ws" '(split-window-below :which-key "Horizontal split")
   "wv" '(split-window-right :which-key "Vertical split")
   "wd" '(evil-window-delete :which-key "close window")
   "ww" '(evil-window-next :which-far-key "next window")
   "wm" '(delete-other-windows :which-far-key "next window")
   "wu" '(winner-undo :which-key "winner undo")
   "wr" '(winner-redo :which-key "winner redo")
   "wh" '(evil-window-left :which-key "left")
   "wH" '(evil-window-move-far-left :which-key "move left")
   "wj" '(evil-window-down :which-key "down")
   "wJ" '(evil-window-move-very-bottom :which-key "move down")
   "wk" '(evil-window-up :which-key "up")
   "wK" '(evil-window-move-very-top :which-key "move up")
   "wl" '(evil-window-right :which-key "right")
   "wL" '(evil-window-move-far-right :which-key "move right")
   "w+" '(evil-window-increase-height 30 :which-key "increase height")
   "w-" '(evil-window-decrease-height 30 :which-key "decrease height")
     ;; (enlarge-window 15)
   )

)

(use-package evil
    :ensure t
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
    (setq-default evil-shift-width 2)
    (setq evil-search-module 'evil-search)
;;    (evil-set-initial-state 'occur-mode 'normal)

;;    (setq evil-ex-nohighlight t)
;; More configuration goes here
)

(use-package ess
   :ensure t
   :init (require 'ess-site))

(use-package polymode
   :ensure t
   :config
   (setq load-path
   (append '("~/.emacs.d/elpa/polymode-20170307"  "~/.emacs.d/elpa/polymode-20170307/")
load-path))
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
(autoload 'r-mode "ess-site.el" "Major mode for editing R source." t)
)

(use-package which-key
   :ensure t
   :config
   (which-key-mode 1)
   (setq which-key-idle-delay 1))

(use-package evil-magit :ensure t)

(use-package avy :ensure t
 :commands (avy-goto-word-1))

(use-package ivy
 :commands (ivy-switch-buffer
     ivy-switch-buffer-other-window)
 :config
 (ivy-mode 1))

(use-package counsel :ensure t
 :config
 ;;  (setq counsel-find-file-at-point t)
 ;;  (setq counsel-locate-cmd 'counsel-locate-cmd-mdfind)
 (setq counsel-find-file-ignore-regexp "\\.DS_Store\\|.git\\|node_modules"))
 (setq ivy-initial-inputs-alist nil)

(use-package projectile :ensure t
 :config
 (setq projectile-mode-line " foo")
 (setq projectile-completion-system 'ivy)
 (setq projectile-file-exists-local-cache-expire (* 5 60))
 (projectile-global-mode t))

(use-package linum-relative :ensure t
 :config
 (global-linum-mode nil)
 (linum-relative-toggle)
 (setq linum-relative-current-symbol ""))

(use-package dashboard :ensure t
 :config
 (dashboard-setup-startup-hook)
 (setq dashboard-items '((recents  . 5)
		  (bookmarks . 5)
		  (projects . 5)
		  (agenda . 5)
		  (registers . 5)))
 )
  ;; (add-hook 'dashboard-mode-hook
  ;; 	    (lambda ()
  ;; 	       (set-display-table-slot buffer-display-table 'wrap ?\ )))

(use-package page-break-lines :ensure t)
;;  (add-hook 'page-break-lines-mode-hook
;; 	    (lambda ()
;; (set-display-table-slot standard-display-table 0 ?\ )))
;; (add-hook 'page-break-lines-mode-hook
;; (lambda ()
;;  (set-display-table-slot buffer-display-table 0 ?\ )))
;;(set-display-table-slot buffer-display-table 'wrap ?\ )))

(use-package company :ensure t)
;  :config
;  (global-company-mode t))
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(use-package yasnippet :ensure t)
;;  :config
;;  (yas-global-mode 1))

;; (use-package all-the-icons :ensure t)
;; dont forget to M-x all-the-icons-install-fonts

(use-package treemacs
:ensure t
:defer t
;;:init
;;(with-eval-after-load 'winum
;;  (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
:config
(progn
  (use-package treemacs-evil
    :ensure t
    :demand t)
  (setq treemacs-change-root-without-asking nil
        treemacs-collapse-dirs              (if (executable-find "python") 3 0)
        treemacs-file-event-delay           5000
        treemacs-follow-after-init          t
        treemacs-follow-recenter-distance   0.1
        treemacs-goto-tag-strategy          'refetch-index
        treemacs-indentation                2
        treemacs-indentation-string         " "
        treemacs-is-never-other-window      nil
        treemacs-never-persist              nil
        treemacs-no-png-images              nil
        treemacs-recenter-after-file-follow nil
        treemacs-recenter-after-tag-follow  nil
        treemacs-show-hidden-files          t
        treemacs-silent-filewatch           nil
        treemacs-silent-refresh             nil
        treemacs-sorting                    'alphabetic-desc
        treemacs-tag-follow-cleanup         t
        treemacs-tag-follow-delay           1.5
        treemacs-width                      35)

  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (pcase (cons (not (null (executable-find "git")))
                (not (null (executable-find "python3"))))
    (`(t . t)
      (treemacs-git-mode 'extended))
    (`(t . _)
      (treemacs-git-mode 'simple)))))
;;(use-package treemacs-projectile
;;  :defer t
;;  :ensure t
;;  :config
;;  (setq treemacs-header-function #'treemacs-projectile-create-header))

(use-package winum :ensure t
  :config
;;  (setq winum-keymap
;;	(let ((map (make-sparse-keymap)))
;;	  (define-key map (kbd "C-0") 'winum-select-window-0-or-10)
;;	  (define-key map (kbd "C-1") 'winum-select-window-1)
;;	  (define-key map (kbd "M-2") 'winum-select-window-2)
;;	  (define-key map (kbd "M-3") 'winum-select-window-3)
;;	  (define-key map (kbd "M-4") 'winum-select-window-4)
;;	  (define-key map (kbd "M-5") 'winum-select-window-5)
;;	  (define-key map (kbd "M-6") 'winum-select-window-6)
;;	  (define-key map (kbd "M-7") 'winum-select-window-7)
;;	  (define-key map (kbd "M-8") 'winum-select-window-8)
;;	  map))
  (winum-mode)
  )

(use-package evil-commentary :ensure t)

;;(use-package dumb-jump :ensure t)

(use-package indent-guide :ensure t)

(use-package rainbow-delimiters :ensure t)

(use-package ag :ensure t)

(use-package pdf-tools :ensure t) ;; pdf-tools install



(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'evil-commentary-mode)
(add-hook 'prog-mode-hook 'column-number-mode)
;;(add-hook 'prog-mode-hook 'yas-global-mode)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)
(add-hook 'prog-mode-hook 'indent-guide-mode)
(add-hook 'prog-mode-hook 'winner-mode)
;; (add-hook 'prog-mode-hook 'whitespace-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
(setq web-mode-css-indent-offset 2) ; web-mode, css in html file
(setq web-mode-code-indent-offset 2) ; web-mode, js code in html file

(use-package company-tern :ensure t
  :after company
  :config
  (add-to-list 'company-backends 'company-tern))

(add-hook 'js2-mode-hook (lambda ()
			   (tern-mode)
			   (company-mode)))
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)


(use-package js2-mode :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  )
  
(setq javascript-indent-level 2) ; javascript-mode
(setq js-indent-level 2) ; js-mode
(setq js2-basic-offset 2) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
;;(setq tide-basic-offset 2) ;

(use-package typescript-mode :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
  )

(use-package tide :ensure t
  :config
  ;;(add-to-list 'auto-mode-alist '("\\.ts\\'" . tide-mode))
  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)
  ;; formats the buffer before saving
  ;;(add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  )
(setq typescript-indent-level 2
      typescript-expr-indent-offset 2)
(setq evil-shift-width 2)
(setq typescript-indent-level 2) ; 

 ;; typescript mode specific keybindings
 (general-define-key
 :states 'normal
 :keymaps 'typescript-mode-map
 "gd" 'tide-jump-to-definition
 )

(setq css-indent-offset 2) ; css-mode

;; go get: goflymake golang.org/x/tools/cmd/... godef gocode

  (defun load-env-vars () 
    (let ((path (shell-command-to-string ". ~/.zshrc; echo -n $PATH")))
    (setenv "PATH" path)
    (setq exec-path (append (split-string-and-unquote path ":") exec-path)))

    (let ((gopath (shell-command-to-string ". ~/.zshrc; echo -n $GOPATH")))
    (setenv "GOPATH" gopath)
    (setq exec-path (append (split-string-and-unquote gopath ":") exec-path)))
  )

  (use-package go-mode :ensure t
    :config
    (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  ;; :load-path "/tmp/elisp/go-mode"
    )

  (use-package go-guru :ensure t)

  (use-package flymake-go :ensure t
    ;; :config
    ;; (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  ;; :load-path "/tmp/elisp/go-mode"
    )

  (use-package company-go :ensure t
    :after company
    :config
    (add-to-list 'company-backends 'company-go))

  (defun my-go-mode-hook ()
    ;; (require 'go-guru)
  ;; (use-package go-guru
  ;; user-emacs-directory
  ;;  :load-path concat(user-emacs-directory "")"")

    (general-define-key
    :states 'normal
    :keymaps 'go-mode-map
    "gd" 'godef-jump
    "gh" 'godef-describe
    )

    (general-define-key
    :states '(normal motion)
    :keymaps 'go-mode-map
    :prefix "SPC"
    "m" '(go-guru-map :which-key "Major Mode[Go]")
    )
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
    )





  (add-hook 'go-mode-hook (lambda ()
    (set (make-local-variable 'company-backends) '(company-go))
    (company-mode)))

  (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
  (add-hook 'go-mode-hook #'load-env-vars)
  (add-hook 'go-mode-hook 'my-go-mode-hook)
