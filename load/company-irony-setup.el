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

;; Add yasnippet as a backend
(add-to-list 'company-backends 'company-yasnippet)
(setq company-minimum-prefix-length 1)
(setq company-transformers '(company-sort-by-occurrence))
(setq company-idle-delay 0)
