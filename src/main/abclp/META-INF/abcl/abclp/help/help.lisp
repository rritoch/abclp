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

(defun command-documentation (cmd)

  (let* ((package (string-upcase (concatenate 'string "abclp/" cmd)))
         (cmdfun (string-upcase (concatenate 'string package "::" cmd)))
         (cmd-sym (find-symbol (string-upcase cmd) (load-package package)))
         (rval (documentation cmd-sym 'function)))
	(or rval (concatenate 'string "?" (string cmd-sym) "?"))))

(defun help (project args)
	"Display available documentation"
	(trace documentation) ;;; REMOVE ME!	
	(format t "~%Commands~%")
	(format t "--------------------------------------~%")
	(dolist (x (find-commands))
	   (format t x)
	   (format t " - ")
	   (format t (command-documentation x))
	   (format t "~%"))
	(format t "~%Done.~%"))
	  