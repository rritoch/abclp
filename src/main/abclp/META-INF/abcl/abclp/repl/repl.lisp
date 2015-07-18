;;;; ABC Lisp Packager REPL
;;;
;;; @package abclp-repl
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp-repl (:use abclp common-lisp java))
(in-package abclp-repl)

(defun prompt ()
  (format t "" #\newline)
  (format t "> ")
  (finish-output))

(defun display-error (err)
   (print err))

(defun repl (project args)
	"ABCLP REPL"
	(loop 
	  (prompt)
	  (handler-case (print (eval (read)))
	    (condition (condition) (display-error condition)))))
	  
	  
