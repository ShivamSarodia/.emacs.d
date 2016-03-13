;; company-irony-setup.el
;;
;; Sets up company and irony.
;;

(provide 'company-irony-setup)

(require 'company)

;; Enable company-mode in C++ and C
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)

;; Enable company-mode in LaTeX
(add-hook 'LaTeX-mode-hook 'company-mode)

(setq company-minimum-prefix-length 1)
(setq company-transformers '(company-sort-by-occurrence))
(setq company-idle-delay 0)

;; Enable irony mode in C++ and C
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

;; Add yasnippet + irony as a backend
(add-to-list 'company-backends '(company-irony :with company-yasnippet))

;; Add some interesting completions, like after std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;; todo--add yasnippet by itself

