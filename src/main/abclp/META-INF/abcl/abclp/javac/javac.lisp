;;;; ABC Lisp Packager Java Compiler
;;;
;;; @package abclp/javac
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp/javac (:use abclp common-lisp java) (:export "HELP"))
(in-package abclp/javac)

(defun get-compiler ()
  (jcall (jmethod (jclass "javax.tools.ToolProvider") "getSystemJavaCompiler") nil))

(defun to-str-array (items)
  (let ((ret (jnew-array (jclass "java.lang.String") (length items))))
       (loop for x from 0 to (- (length items) 1)
             do (jarray-set ret (nth x items) x))
       ret))

(defun javac (project args)
	"Compile Java Sources"	
	nil)
