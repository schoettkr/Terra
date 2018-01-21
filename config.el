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
  (setq tab-width 2)                    ; tab are 2 spaces large
  (setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup
  (setq tab-stop-list (number-sequence 2 120 2)) ;; set tab length
  (setq evil-want-C-u-scroll t) ;; scroll with C-u like in vim
  
(mapc
 (lambda (face)
   (set-face-attribute face nil :weight 'normal :underline nil))
 (face-list))

(menu-bar-mode 0)
(tool-bar-mode 0)
(set-default-font "Hack 11")
;; (set-default-font "Fantasque Sans Mono 14")
(toggle-scroll-bar -1)
(set-fringe-mode 0) ;; deactivates gutters at screen edges on linebreak
;;(set-window-fringes (selected-window) 0 0 nil)
(use-package gruvbox-theme :ensure t)
(use-package dracula-theme :ensure t)
(use-package arjen-grey-theme :ensure t)
(use-package nord-theme :ensure t)
(use-package badger-theme :ensure t)
;; (load-theme 'doom-vibrant t)
;; (load-theme 'dracula t)
;; (load-theme 'arjen-grey t)
;; (load-theme 'badger t)
;; (load-theme 'nord t)
(load-theme 'gruvbox t)

(use-package doom-themes
  :ensure t
  :config
    (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
      	  doom-themes-enable-italic t) ; if nil, italics is universally disabled 
    ;; (load-theme 'doom-nova t)
    ;; Enable custom neotree theme
    (doom-themes-neotree-config) 
)

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
  
(defun popup-shell ()
  (interactive)
  (ansi-term "/bin/zsh")
  (mode-line-other-buffer)
  (split-window-below))

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
   )
  (general-define-key
   :keymaps 'neotree-mode-map
   "c" 'neotree-create-node
   "r" 'neotree-rename-node
   "d" 'neotree-delete-node
   "v" 'neotree-enter-vertical-split
   "s" 'neotree-enter-horizontal-split
   )

  (general-define-key
   :states '(normal emacs motion)
   :prefix "SPC"

   ;; simple command
   "x" 'counsel-M-x        ; replace default M-x with ivy backend
   "'"   '(iterm-focus :which-key "iterm")
   "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
   "TAB" '(mode-line-other-buffer :which-key "prev buffer")
   "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")
   "C-'" 'avy-goto-word-1
   "qq"  '(save-buffers-kill-terminal :which-key "Save all & quit")
   "=="  '(indent-buffer :which-key "Indent buffer")
   "RET" '(add-semicolon :which-key "Insert ; at eol")
   "'" '(popup-shell :which-key "popup shell")

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ar" 'ranger
   "at" '(open-termite :which-key "Termite")
   "ad" 'dired

   ;; Buffer
   "b" '(:ignore t :which-key "Buffer")
   "bb" '(ivy-switch-buffer :which-key "Change buffer")
   "bd" '(kill-buffer :which-key "kill buffer")
   "bp" '(switch-to-prev-buffer :which-key "prev buffer")
   "bn" '(switch-to-prev-buffer :which-key "next buffer")

   ;; Files
   "f" '(:ignore t :which-key "Files")
   "ff" '(counsel-find-file :which-key "find file")
   "fr"	'(counsel-recentf   :which-key "recent files")
   "fs" '(save-buffer :which-key "save file")
   "f/" '(swiper :which-key "search in file")
   "ft" '(neotree-toggle :which-key "toggle neotree")

   ;; Git
   "g" '(:ignore t :which-key "Git")
   "gs" '(magit-status :which-key "status")

   ;; Help
   "h" '(:ignore t :which-key "Help")
   "hh" '(help-for-help-internal :which-key "open help")

   ;; Projects
   "p" '(:ignore t :which-key "Projects")
   "pf" '(counsel-git :which-key "Find file in git project")
   "p/" '(counsel-ag :which-key "Search in project")
   "pp" '(projectile-switch-project :which-key "Switch project")

   ;; Windows
   "1" '(winum-select-window-1 :which-key "win 1")
   "2" '(winum-select-window-2 :which-key "win 2")
   "3" '(winum-select-window-3 :which-key "win 3")
   "4" '(winum-select-window-4 :which-key "win 4")
   "5" '(winum-select-window-5 :which-key "win 5")
   "6" '(winum-select-window-6 :which-key "win 6")
   "w" '(:ignore t :which-key "Windows")
   "ws" '(split-window-below :which-key "Horizontal split")
   "wv" '(split-window-right :which-key "Vertical split")
   "wd" '(evil-window-delete :which-key "close window")
   "ww" '(evil-window-next :which-far-key "next window")
   "wm" '(delete-other-windows :which-far-key "next window")
   "wh" '(evil-window-left :which-key "left")
   "wH" '(evil-window-move-far-left :which-key "move left")
   "wj" '(evil-window-down :which-key "down")
   "wJ" '(evil-window-move-very-bottom :which-key "move down")
   "wk" '(evil-window-up :which-key "up")
   "wK" '(evil-window-move-very-top :which-key "move up")
   "wl" '(evil-window-right :which-key "right")
   "wL" '(evil-window-move-far-right :which-key "move right")
   ))

(use-package evil
    :ensure t
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
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

(use-package page-break-lines :ensure t)

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

(use-package all-the-icons :ensure t)
;; dont forget to M-x all-the-icons-install-fonts

(use-package neotree :ensure t
  :config (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

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



(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'evil-commentary-mode)
;;(add-hook 'prog-mode-hook 'yas-global-mode)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)
(add-hook 'prog-mode-hook 'indent-guide-mode)
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
(setq typescript-indent-level 2) ; 
(setq typescript-indent-level 2
      typescript-expr-indent-offset 2)

(setq css-indent-offset 2) ; css-mode
