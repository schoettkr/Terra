(menu-bar-mode 0)
(tool-bar-mode 0)
(set-default-font "Hack 12")
;;(set-default-font "Fantasque Sans Mono 14")
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
(setq tab-width 2)                    ; tab are 4 spaces large

(setq initial-scratch-message "Welcome to Emacs") ; print a default message in the empty scratch buffer opened at startup
(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "https://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize) ; guess what this one does ?

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package) ; guess what this one does too ?
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-magit projectile dashboard linum-relative arjen-grey-theme which-key evil avy general use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  ;; More configuration goes here
  )
(use-package arjen-grey-theme
  :ensure t
  :config
   (load-theme 'arjen-grey t))

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 1)
  )

(use-package general :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   :states '(normal emacs)
   "C-s" 'swiper             ; search for string in current buffer
   "/" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
   )
  (general-define-key
   :states '(normal emacs motion)
   :prefix "SPC"

   ;; simple command
   "'"   '(iterm-focus :which-key "iterm")
   "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
   "TAB" '(mode-line-other-buffer :which-key "prev buffer")
   "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")
   "C-'" 'avy-goto-word-1
   "qq"  '(save-buffers-kill-terminal :which-key "Save all & quit")
	   
   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ar" 'ranger
   "ad" 'dired

   ;; Buffer
   "b" '(:ignore t :which-key "Buffer")
   "bb" '(ivy-switch-buffer :which-key "Change buffer")
   "bd" '(kill-buffer :which-key "kill buffer")

   ;; Files
   "f" '(:ignore t :which-key "Files")
   "ff" '(counsel-find-file :which-key "find file")
   "fr"	'(counsel-recentf   :which-key "recent files")
   "fs" '(save-buffer :which-key "save file")

   ;; Projects
   "p" '(:ignore t :which-key "Projects")
   "pf" '(counsel-git :which-key "Find file in git project")

   ;; Windows
   "w" '(:ignore t :which-key "Windows")
   "wd" '(evil-window-delete :which-key "close window")
   "ww" '(evil-window-next :which-far-key "next window")
   "wh" '(evil-window-left :which-key "left")
   "wH" '(evil-window-move-far-left :which-key "move left")
   "wj" '(evil-window-down :which-key "down")
   "wJ" '(evil-window-move-very-bottom :which-key "move down")
   "wk" '(evil-window-up :which-key "up")
   "wK" '(evil-window-move-very-top :which-key "move up")
   "wl" '(evil-window-right :which-key "right")
   "wL" '(evil-window-move-far-right :which-key "move right")
   ))

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
