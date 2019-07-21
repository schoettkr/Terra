
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq gc-cons-threshold 100000000)
(let ((file-name-handler-alist nil))
(menu-bar-mode 0)
(tool-bar-mode 0)
(toggle-scroll-bar -1)
(package-initialize)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(unless (file-exists-p "~/.emacs.d/custom.el")
  (with-temp-buffer (write-file "~/.emacs.d/custom.el")))

(require 'org)
(let ((file-name-handler-alist nil))
  (org-babel-load-file
   (expand-file-name "config.org"
                     user-emacs-directory)))
)
