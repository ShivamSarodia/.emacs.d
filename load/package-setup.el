;; package-setup.el
;;
;; Sets up all the packages. The easy ones are set up here, and the hard ones
;; are set up in separate files.
;; 

(provide 'package-setup)

;; Enable 80char/line limit. To change settings of this, see environment.el
(require 'column-enforce-mode)

;; Enable ido and flx
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; Enable the window numbering
(require 'window-numbering)
(window-numbering-mode 1)

;; Enable multi-term and set an easy alias for it
(require 'multi-term)
(setq multi-term-program "/bin/bash")
(defalias 'mt 'multi-term)

;; Theme business is handled in environment.el

;; Enable smartparens
(require 'smartparens-config)
(add-hook 'prog-mode-hook #'smartparens-mode)

;; Enable global undo tree mode
(global-undo-tree-mode)

;; Enable smex and bind M-x
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex) 
(global-set-key (kbd "M-X") 'smex-major-mode-commands)  

;; Enable yasnippet
(require 'yasnippet)
(yas-reload-all)
(add-hook 'c-mode-hook #'yas-minor-mode)
(add-hook 'c++-mode-hook #'yas-minor-mode)
(add-hook 'python-mode-hook #'yas-minor-mode)

;; Fix a bug in iedit by changing keybinding
(global-set-key (kbd "C-c ;") 'iedit-mode)

;; These setups suck. Do them in separate files.
(require 'ggtags-setup)
(require 'company-irony-setup)




