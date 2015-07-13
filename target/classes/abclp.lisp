;;;; ABC Lisp Packager
;;;
;;; @package abclp
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED


(provide 'abclp)
(in-package 'abclp)


(defun hello ()
	"Hello World!"
	(print "ABC Lisp Packager"))

(defun main (args)
	"ABCLP Main entry point"
	(hello)
	(exit))
