;; environment.el
;; 
;; Contains general environment settings.
;;

(provide 'environment)

;; Enable line numbers in programming mode
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%d ")

;; Disable scroll bars
(toggle-scroll-bar -1)

;; Sets cursor to bar
(setq-default cursor-type 'bar)

;; Sets default font
(set-default-font "DejaVu Sans Mono 12") 

;; Turn on showing matching parentheses
(setq show-paren-delay 0) 
(show-paren-mode 1)

;; Turn off weird bell noises
(setq ring-bell-function #'ignore)

;; Replace yes/no with y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Turn off welcome page
(setq inhibit-startup-message t) 

;; Move backups so ~foo aren't created everywhere
(setq backup-directory-alist `(("." . "~/.saves")))

;; Use the system keyboard for yanks
(setq select-enable-clipboard t) 

;; Close window with C-C #
(global-set-key (kbd "C-c 1")
		(lambda () (interactive) (select-window-1) (delete-window)))
(global-set-key (kbd "C-c 2")
		(lambda () (interactive) (select-window-2) (delete-window))) 
(global-set-key (kbd "C-c 3")
		(lambda () (interactive) (select-window-3) (delete-window)))
(global-set-key (kbd "C-c 4")
		(lambda () (interactive) (select-window-4) (delete-window)))
(global-set-key (kbd "C-c 5")
		(lambda () (interactive) (select-window-5) (delete-window)))
(global-set-key (kbd "C-c 6")
		(lambda () (interactive) (select-window-6) (delete-window)))
(global-set-key (kbd "C-c 7")
		(lambda () (interactive) (select-window-7) (delete-window)))
(global-set-key (kbd "C-c 8")
		(lambda () (interactive) (select-window-8) (delete-window)))
(global-set-key (kbd "C-c 9")
		(lambda () (interactive) (select-window-9) (delete-window)))
(global-set-key (kbd "C-c 0")
		(lambda () (interactive) (select-window-0) (delete-window))) 

;; Enable 80char limit on C-like languages and elisp
(add-hook 'c-mode-common-hook 'column-enforce-mode)
(add-hook 'emacs-lisp-mode-hook 'column-enforce-mode)

;; Load Monokai theme
(load-theme 'monokai t)

;; Enable fancy debugging
(setq gdb-many-windows t)
