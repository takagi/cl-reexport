#|
  This file is a part of cl-reexport project.
  Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-reexport-test-asd
  (:use :cl :asdf))
(in-package :cl-reexport-test-asd)

(defsystem cl-reexport-test
  :author "Masayuki Takagi"
  :license "LLGPL"
  :depends-on (:cl-reexport
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "cl-reexport"))))
  :description "Test for cl-reexport."
  :perform (load-op :after (op c) (asdf:clear-system c)))
