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

(defun str-starts-with (s prefix)
  (if (>= (length s) (length prefix))
      (string= prefix (subseq s 0 (length prefix))))) 

(defun relative-path-str (p-base p-ref)
   (subseq (directory-namestring p-ref) (length (directory-namestring p-base)))) 

(defun is-directory (p)
  (let ((name (namestring p)))
     (if (< 0 (length name))
         (string= "/" (subseq name (- (length name) 1))))))

(defun all-files-deep (basepath path)
  (let* ((canonical-basepath (truename basepath))
         (current-dir (truename (merge-pathnames (or path ".") canonical-basepath))))
        (if (str-starts-with (namestring current-dir) (namestring canonical-basepath))
            (loop for p in (directory (make-pathname :name "*" :type nil :defaults current-dir))
                  append (if (is-directory p)
                             (all-files-deep basepath (relative-path-str canonical-basepath p))
                             (list p)))
            (list))))

(defun javac (project args)
	"Compile Java Sources"	
	nil)
