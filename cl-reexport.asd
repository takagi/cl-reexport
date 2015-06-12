#|
  This file is a part of cl-reexport project.
  Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-reexport-asd
  (:use :cl :asdf))
(in-package :cl-reexport-asd)

(defsystem cl-reexport
  :version "0.1"
  :author "Masayuki Takagi"
  :license "LLGPL"
  :depends-on (:alexandria)
  :components ((:module "src"
                :components
                ((:file "cl-reexport"))))
  :description "Reexport external symbols in other packages."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op cl-reexport-test))))
