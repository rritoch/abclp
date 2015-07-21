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
        (cmdfun (string-upcase (concatenate 'string package "::" cmd))))
    (load-package package)
	(or (documentation (make-symbol cmdfun) 'function) (concatenate 'string "?" cmdfun "?"))))

(defun help (project args)
	"Display available documentation"
	
	(format t "~%Commands~%")
	(format t "--------------------------------------~%")
	(dolist (x (find-commands))
	   (format t x)
	   (format t " - ")
	   (format t (command-documentation x))
	   (format t "~%"))
	(format t "~%Done.~%"))
	  