;;;; ABCL Packager
;;;
;;; @package abclp
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp (:use common-lisp java sys) (:export "DISPLAY-ERROR" "MAIN" "LOAD-PACKAGE" "IS-DIRECTORY"))
(in-package abclp)

;; TODO: See http://paste.lisp.org/display/152082#3
;; TODO: See http://paste.lisp.org/display/152082#2

(defun interpose (col sep)
   (reverse (cdr (reverse (loop for x in col
                                collect x 
                                collect sep)))))

(defun display-error (err)
   (format t "ERROR: ~a~%" err))

(defun partition-list (list length)
  (loop
     while list
     collect (subseq list 0 length)
     do (setf list (nthcdr length list))))

(defun string-split (string &optional (separator " "))
  (let ((s1 
      (lambda (s1 s-in sep r)
        (let ((n (search sep s-in
                             :from-end t)))
          (if n
             (funcall s1 
                      s1 
                      (subseq s-in 0 (- n (- (length sep) 1))) 
                      sep 
                      (cons (subseq s-in (1+ n)) r))
             (cons s-in r))))))
    (funcall s1 s1 string separator nil)))


(defun string-join (list &optional (delimiter " "))
  (format nil "~{~a~}" (interpose list delimiter)))

(defun read-file (fn)
  (let* ((in (open fn :if-does-not-exist nil))
         (result (if in (read in))))
     (close in)
     result))

(defun is-directory (p)
  (let ((name (namestring p)))
     (if (< 0 (length name))
         (string= "/" (subseq name (- (length name) 1))))))

(defun exit ()
  "Exit"
  (jcall (jmethod (jclass "java.lang.System") "exit" (jclass "int")) nil 0))

(defun hello ()
  "Hello World!"
  (format t "ABC Lisp Packager~%"))

(defun package-source (pkg)
  (let* ((parts (string-split (string-downcase pkg) "/"))
         (name (first (last parts))))
    (format nil 
            "~{~a~}"
            (list "/META-INF/abcl/" 
                  (string-join parts "/")
                  "/"
                  name
                  ".lisp")))) 

(defun read-project ()
  (if (probe-file "project.lisp")
      (let* ((in (rest (read-file "project.lisp")))
             (name (first in))
             (version (second in))
             (cfg (map 'list 
                       (lambda (x) 
                        (first (pairlis (list (first x))
                                        (list (second x))))) 
                       (partition-list (nthcdr 2 in) 2))))
         (acons :name name (acons :version version cfg)))))

(defun dyncall (package fname &rest args)
  "Call function by package name and name with provided arguments"
  (apply (intern (string-upcase fname) (make-symbol (string-upcase package))) args))

(defun load-package (package)
  (load-system-file (package-source package))
  (find-package package))

(defun main (args)
  "ABCLP Main entry point"
  (hello)
  (let* ((cmd (or (first args) "help"))
         (package (string-upcase (concatenate 'string "abclp/" cmd))))
    (or (find-package package) (load-package package))
    (dyncall package cmd (read-project) args))
  (exit))
  
