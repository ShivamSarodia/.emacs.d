;; editing.el
;;
;; File for modifying editing keybinds
;;

(provide 'editing)

;; Enable the Google C/C++ styles
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Smarter indents
(electric-indent-mode 1)


(defun smart-move-beginning-of-line (arg)
    "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first. If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") 'smart-move-beginning-of-line)


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

;; Change around yank indent behavior
;; automatically indent yanked text if in programming-modes
(defvar yank-indent-modes
  '(LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked (or yank-popped).
Only modes that don't derive from `prog-mode' should be listed here.")

(defvar yank-indent-blacklisted-modes
  '(python-mode slim-mode haml-mode)
  "Modes for which auto-indenting is suppressed.")

(defvar yank-advised-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur.")

(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(defadvice yank (after yank-indent activate)
  "If current mode is one of 'yank-indent-modes,
indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (not (member major-mode yank-indent-blacklisted-modes))
           (or (derived-mode-p 'prog-mode)
               (member major-mode yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

(defadvice yank-pop (after yank-pop-indent activate)
  "If current mode is one of `yank-indent-modes',
indent yanked text (with prefix arg don't indent)."
  (when (and (not (ad-get-arg 0))
             (not (member major-mode yank-indent-blacklisted-modes))
             (or (derived-mode-p 'prog-mode)
                 (member major-mode yank-indent-modes)))
    (let ((transient-mark-mode nil))
      (yank-advised-indent-function (region-beginning) (region-end)))))

;; Set undo to C-- for consistency
(global-set-key (kbd "C--") 'undo-tree-undo)
(global-set-key (kbd "C-_") 'undo-tree-redo)
(define-key undo-tree-map (kbd "C-\\") nil)


