#|
  This file is a part of cl-reexport project.
  Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-reexport
  (:use :cl)
  (:export :reexport-from))
(in-package :cl-reexport)


;;;
;;; Helpers
;;;

(defun external-symbols (package)
  (let (ret)
    (do-external-symbols (var package ret)
      (push var ret))))

(defun exclude-symbols (exclude symbols)
  (flet ((aux (symbol)
           (member symbol exclude :key #'symbol-name
                                  :test #'string=)))
    (remove-if #'aux symbols)))

(defun include-symbols (include symbols)
  (flet ((aux (symbol)
           (member symbol include :key #'symbol-name
                                  :test #'string=)))
    (if include
        (remove-if-not #'aux symbols)
        symbols)))


;;;
;;; Syntax:
;;;
;;;   REEXPORT-FROM package-from &key include exclude
;;;
;;; Arguments and values:
;;;
;;;   package-from --- a package designator from which symbols are reexported
;;;

(defun reexport-from (package-from &key include exclude)
  (unless (not (and include exclude))
    (error "INCLUDE option and EXCLUDE option are exclusive."))
  (let ((symbols (include-symbols include
                   (exclude-symbols exclude
                     (external-symbols package-from)))))
    (import symbols)
    (export symbols)))
