(add-to-list 'load-path "~/.emacs.d/load/")

;; This way, Custom won't barf all over init.el
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(require 'package-installer)
(require 'package-setup)
(require 'environment)
(require 'editing)
