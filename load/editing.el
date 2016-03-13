;; editing.el
;;
;; File for modifying editing keybinds
;;

(provide 'editing)

;; Enable the Google C/C++ styles
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Smarter indents
(electric-indent-mode 1)

;; Kill lines more intelligently wrt whitespace
(defadvice kill-line (before check-position activate)
  (if (member major-mode
	      '(emacs-lisp-mode scheme-mode lisp-mode
				c-mode c++-mode objc-mode
				latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
	  (progn (forward-char 1)
		 (just-one-space 0)
		 (backward-char 1)))))

;; When moving previous, reindent the line
(defun smart-previous ()
  (interactive)
  (previous-line)
  (indent-according-to-mode))

(require 'cc-mode)
(define-key c-mode-map (kbd "C-p") 'smart-previous)
(define-key c++-mode-map (kbd "C-p") 'smart-previous)

;; Better bracket expansion
(defun expand-bracket-enter ()
  (interactive)
  (if (and (char-before)
	   (char-after)
	   (char-equal (char-before) ?{)
	   (char-equal (char-after) ?}))
      (progn (newline-and-indent)
	     (newline-and-indent)
	     (smart-previous))
    (newline-and-indent)))

(define-key c-mode-map (kbd "RET") 'expand-bracket-enter)
(define-key c++-mode-map (kbd "RET") 'expand-bracket-enter)



