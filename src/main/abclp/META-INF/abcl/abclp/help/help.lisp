;;;; ABC Lisp Packager Help
;;;
;;; @package abclp/help
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp/help (:use abclp common-lisp java) (:export "HELP"))
(in-package abclp/help)

(defun find-commands ()
   (list "help" "repl"))

(defun load-documentation (cmd)
  (let ((package (string-upcase (concatenate 'string "abclp/" cmd))))
    (or (find-package package) (load-package package))))

(defun command-documentation (cmd)
  (let* ((package (string-upcase (concatenate 'string "abclp/" cmd)))
         (package-sym (find-package package))
         (cmd-sym (find-symbol (string-upcase cmd) package-sym))
         (rval (documentation cmd-sym 'function)))
	(or rval (concatenate 'string "?" (string cmd-sym) "?"))))

(defun help (project args)
	"Display available documentation"
	;;(trace documentation) ;;; REMOVE ME!	
	(format t "~%Commands~%")
	(format t "--------------------------------------~%")
	(dolist (cmd (find-commands))
	   (load-documentation cmd)
	   (format t "~a" cmd)
	   (format t " - ")
	   (format t "~a" (command-documentation cmd))
	   (format t "~%"))
	(format t "~%Done.~%"))
