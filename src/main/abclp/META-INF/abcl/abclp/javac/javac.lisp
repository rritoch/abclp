;;;; ABC Lisp Packager Java Compiler
;;;
;;; @package abclp/javac
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp/javac (:use abclp common-lisp java) (:export "JAVAC"))
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

(defun all-files-deep (basepath path)
  (when (probe-file basepath)
    (let* ((canonical-basepath (truename basepath))
           (current-dir (truename (merge-pathnames (or path ".") canonical-basepath))))
          (when (str-starts-with (namestring current-dir) (namestring canonical-basepath))
              (loop for p in (directory (make-pathname :name "*" :type nil :defaults current-dir))
                    append (if (is-directory p)
                               (all-files-deep basepath (relative-path-str canonical-basepath p))
                               (list p)))))))

(defun all-sources (project)
   (let ((source-dirs (cdr (assoc :java-source-paths project))))
      (loop for dir in source-dirs
            append (map 'list (lambda (x) (list x dir)) (all-files-deep dir nil)))))

(defun get-compile-path (project)
   (let ((raw-path (cdr (assoc :compile-path project))))
      (if (string= "/" 
                   (subseq raw-path 
                           (- (length raw-path) 1)))
          raw-path
          (format nil "~a/" raw-path))))

(defun java-compile-low (cfg)
  (jcall (jmethod (jclass "javax.tools.JavaCompiler") 
                                "run" 
                                (jclass "java.io.InputStream") 
                                (jclass "java.io.OutputStream") 
                                (jclass "java.io.OutputStream")
                                (jclass "[Ljava.lang.String;")) 
                       (get-compiler) 
                       +null+
                       +null+ 
                       +null+
                       (to-str-array cfg)))

(defun java-compile (project files)
   (ensure-directories-exist (get-compile-path project))
   (let ((cfg (append (list "-d" (namestring (truename (get-compile-path project)))) 
                      (map 'list (lambda (x) (namestring (truename (first x)))) files))))
        (format t "javac args = ~a~%" cfg)
        (handler-case (java-compile-low cfg)
                      (condition (err) (display-error err)))))

(defun javac (project args)
	"Compile Java Sources"
  (java-compile project (all-sources project)))
	
