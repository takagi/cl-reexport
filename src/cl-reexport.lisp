#|
  This file is a part of cl-reexport project.
  Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-reexport
  (:use :cl)
  (:export :reexport-from)
  (:import-from :alexandria
                :ensure-list))
(in-package :cl-reexport)


;;;
;;; Syntax:
;;;
;;;   REEXPORT-FROM packages-from &optional package
;;;
;;; Arguments and values:
;;;
;;;   packages-from --- packages from which symbols are reexported
;;;   package --- package which reexports symbols
;;;
(defun reexport-from (packages-from &optional package)
  (let ((symbols (let (ret)
                   (let ((packages-from1 (ensure-list packages-from)))
                     (dolist (package-from packages-from1 ret)
                       (do-external-symbols (var package-from ret)
                         (push var ret)))))))
    (if package
        (progn
          (use-package packages-from package)
          (export symbols package))
        (progn
          (use-package packages-from)
          (export symbols)))))
