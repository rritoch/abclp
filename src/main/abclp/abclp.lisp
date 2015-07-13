;;;; ABC Lisp Packager
;;;
;;; @package abclp
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED


(defpackage abclp (:use common-lisp java))
(in-package abclp)


(defun exit ()
	"Exit"
	(jcall (jmethod (jclass "java.lang.System") "exit" (jclass "int")) nil 0))

(defun hello ()
	"Hello World!"
	(format t "ABC Lisp Packager~%"))

(defun main (args)
	"ABCLP Main entry point"
	(hello)
	(exit))
