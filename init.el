
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(menu-bar-mode 0)
(tool-bar-mode 0)
(toggle-scroll-bar -1)
(package-initialize)

(unless (file-exists-p "~/.emacs.d/custom.el")
  (with-temp-buffer (write-file "~/.emacs.d/custom.el")))

(require 'org)
(let ((file-name-handler-alist nil))
  (org-babel-load-file
   (expand-file-name "config.org"
                     user-emacs-directory)))
