;;;; ABC Lisp Packager Java Compiler
;;;
;;; @package abclp/lispc
;;; @version 0.0.1
;;; @author Ralph Ritoch <rritoch@gmail.com>
;;; @copyright (c) Ralph Ritoch 2015 - ALL RIGHTS RESERVED

(defpackage abclp/lispc (:use abclp common-lisp java) (:export "LISPC"))
(in-package abclp/lispc)

(setq *default-fasl-ext* "abcl")

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

(defun get-source-paths (project)
  (cdr (assoc :source-paths project)))

(defun all-sources (project)
   (let ((source-dirs (get-source-paths project)))
      (loop for dir in source-dirs
            append (map 'list (lambda (x) (list x dir)) (all-files-deep dir nil)))))

(defun get-compile-path (project)
   (let ((raw-path (cdr (assoc :compile-path project))))
      (if (string= "/" 
                   (subseq raw-path 
                           (- (length raw-path) 1)))
          raw-path
          (format nil "~a/" raw-path))))

(defun set-pathname-ext (file ext)
  (let* ((file-name (namestring file))
         (m (search "." file-name :from-end t)))
    (if m
        (pathname (concatenate 'string (subseq file-name 0 m) "." ext))
        (pathname (concatenate 'string file-name "." ext)))))

(defun remap-pathname (file orig-base new-base)
  (let ((file-name (namestring file))
        (orig-base-name (if (is-directory orig-base) 
                            (namestring orig-base) 
                            (concatenate 'string (namestring orig-base) "/")))
        (new-base-name (if (is-directory new-base) 
                            (namestring new-base) 
                            (concatenate 'string (namestring new-base) "/"))))
       (pathname (concatenate 'string new-base-name (subseq file-name (length orig-base-name))))))

(defun lisp-compile-low (project files)
  (let ((compile-path (truename (get-compile-path project))))
       (loop for job in files
            do (compile-file (first job)
                             :output-file (set-pathname-ext (remap-pathname  (truename (first job)) 
                                                                             (truename (second job)) 
                                                                             compile-path) 
                                                            *default-fasl-ext*)))))

(defun lisp-compile (project files)
   (ensure-directories-exist (get-compile-path project))
   (handler-case (lisp-compile-low project files)
                 (condition (err) (display-error err))))

(defun lispc (project args)
	"Compile Lisp Sources"
  (lisp-compile project (all-sources project)))
	
