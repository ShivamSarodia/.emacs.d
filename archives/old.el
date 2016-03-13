;; old.el
;;
;; Old stuff that I miiiiight need, but most likely won't. Not loaded.
;;

;; There was a a bug in many-windows-mode where it printed way more than it
;; should have been printing. I fixed this by commenting out a part below.

(eval-after-load "gdb-mi"
  ;; fixes a bug with list being printed too much
  '(defun gdb-place-breakpoints ()
     ;; Remove all breakpoint-icons in source buffers but not assembler buffer.
     (dolist (buffer (buffer-list))
       (with-current-buffer buffer
	 (if (and (eq gud-minor-mode 'gdbmi)
		  (not (string-match "\\` ?\\*.+\\*\\'" (buffer-name))))
	     (gdb-remove-breakpoint-icons (point-min) (point-max)))))
     (dolist (breakpoint gdb-breakpoints-list)
       (let* ((breakpoint (cdr breakpoint)) ; gdb-breakpoints-list is
                                        ; an associative list
	      (line (bindat-get-field breakpoint 'line)))
	 (when line
	   (let ((file (bindat-get-field breakpoint 'fullname))
		 (flag (bindat-get-field breakpoint 'enabled))
		 (bptno (bindat-get-field breakpoint 'number)))
	     (unless (and file (file-exists-p file))
	       (setq file (cdr (assoc bptno gdb-location-alist))))
	     (if (or (null file)
		     (string-equal file "File not found"))
		 ;; If the full filename is not recorded in the
		 ;; breakpoint structure or in `gdb-location-alist', use
		 ;; -file-list-exec-source-file to extract it.

		 ;; COMMENTING OUT THIS PART FIXES THAT WEIRD BUG
		 
		 ;; (when (setq file (bindat-get-field breakpoint 'file))
		 ;; 	(gdb-input (concat "list " file ":1") 'ignore)
		 ;; 	(gdb-input "-file-list-exec-source-file"
		 ;; 		   `(lambda () (gdb-get-location
		 ;; 				,bptno ,line ,flag))))
		 ()
	       (with-current-buffer (find-file-noselect file 'nowarn)
		 (gdb-init-buffer)
		 ;; Only want one breakpoint icon at each location.
		 (gdb-put-breakpoint-icon (string-equal flag "y") bptno
					  (string-to-number line))))))))))

;; After fixing this bug, GDB kept hanging. I added a timeout to a command below
;; to fix this problem.

(eval-after-load "tramp-sh"
  '(defun tramp-send-command (vec command &optional neveropen nooutput)
     "Send the COMMAND to connection VEC.
Erases temporary buffer before sending the command.  If optional
arg NEVEROPEN is non-nil, never try to open the connection.  This
is meant to be used from `tramp-maybe-open-connection' only.  The
function waits for output unless NOOUTPUT is set."
     (unless neveropen (tramp-maybe-open-connection vec))
     (let ((p (tramp-get-connection-process vec)))
       (when (tramp-get-connection-property p "remote-echo" nil)
	 ;; We mark the command string that it can be erased in the output buffer.
	 (tramp-set-connection-property p "check-remote-echo" t)
	 ;; If we put `tramp-echo-mark' after a trailing newline (which
	 ;; is assumed to be unquoted) `tramp-send-string' doesn't see
	 ;; that newline and adds `tramp-rsh-end-of-line' right after
	 ;; `tramp-echo-mark', so the remote shell sees two consecutive
	 ;; trailing line endings and sends two prompts after executing
	 ;; the command, which confuses `tramp-wait-for-output'.
	 (when (and (not (string= command ""))
		    (string-equal (substring command -1) "\n"))
	   (setq command (substring command 0 -1)))
	 ;; No need to restore a trailing newline here since `tramp-send-string'
	 ;; makes sure that the string ends in `tramp-rsh-end-of-line', anyway.
	 (setq command (format "%s%s%s" tramp-echo-mark command tramp-echo-mark)))
       ;; Send the command.
       (tramp-message vec 6 "%s" command)
       (tramp-send-string vec command)

       ;; added a 1 here because otherwise it randomly hangs
       
       (unless nooutput (tramp-wait-for-output p 1)))))
