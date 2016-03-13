;; package-installer.el
;;
;; Contains list of packages to check for. Installs any missing packages.
;; 

(provide 'package-installer)

;; List of packages to install. If a package is not present, we'll install it.
;; NOTE: I need to update this every time I install a new package.
(setq package-list '(auto-complete-c-headers
		     auto-complete
		     column-enforce-mode
		     company-irony
		     company
		     flx-ido
		     flx-isearch
		     flx
		     ggtags
		     google-c-style
		     ;; ido-ubiquitous ;; doesn't seem to work on zoo emacs
		     iedit
		     irony-eldoc
		     irony
		     monokai-theme
		     multi-term
		     smartparens
		     smex
		     solarized-theme
		     undo-tree
		     window-numbering
		     yasnippet))


(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; activate all the packages
(package-initialize)

;; make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents)) 

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


