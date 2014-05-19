#|
  This file is a part of cl-reexport project.
  Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-reexport-test
  (:use :cl
        :cl-reexport
        :cl-test-more))
(in-package :cl-reexport-test)


(plan nil)


;;;
;;; Sub packages to be reexported
;;;

(in-package :cl-user)

;; FOO-PACKAGE.BAR package from which export symbol X
(defpackage foo-package.bar
  (:use :cl)
  (:export :x))

;; FOO-PACKAGE.BAZ package from which export symbol Y
(defpackage foo-package.baz
  (:use :cl)
  (:export :y))


;;;
;;; Test case 1
;;;

(in-package :cl-user)
(defpackage foo-package1
  (:use :cl :foo-package.bar :foo-package.baz))

(in-package :foo-package1)

(cl-reexport:reexport-from :foo-package.bar)
(cl-reexport:reexport-from :foo-package.baz)

(in-package :cl-reexport-test)

(multiple-value-bind (symbol status) (find-symbol "X" :foo-package1)
  (is symbol 'foo-package.bar:x)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "Y" :foo-package1)
  (is symbol 'foo-package.baz:y)
  (is status :external))


;;;
;;; Test case 2
;;;

(in-package :cl-user)
(defpackage foo-package2
  (:use :cl))

(cl-reexport:reexport-from :foo-package.bar :foo-package2)
(cl-reexport:reexport-from :foo-package.baz :foo-package2)

(in-package :cl-reexport-test)

(multiple-value-bind (symbol status) (find-symbol "X" :foo-package2)
  (is symbol 'foo-package.bar:x)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "Y" :foo-package2)
  (is symbol 'foo-package.baz:y)
  (is status :external))


;;;
;;; Tets case 3
;;;

(in-package :cl-user)
(defpackage foo-package3
  (:use :cl))

(in-package :foo-package3)

(cl-reexport:reexport-from '(:foo-package.bar :foo-package.baz))

(in-package :cl-reexport-test)

(multiple-value-bind (symbol status) (find-symbol "X" :foo-package3)
  (is symbol 'foo-package.bar:x)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "Y" :foo-package3)
  (is symbol 'foo-package.baz:y)
  (is status :external))


(finalize)
