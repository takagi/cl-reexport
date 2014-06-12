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
;;; Sub packages to be reexported
;;;

(in-package :cl-user)

;; BAR-PACKAGE.A package from which export only symbol X
(defpackage bar-package.a
  (:use :cl)
  (:export :x :y :z))

;; BAR-PACKAGE.B package from which export only symbol Q and R
(defpackage bar-package.b
  (:use :cl)
  (:export :p :q :r))


;;;
;;; Test case 2
;;;

(in-package :cl-user)
(defpackage bar-package
  (:use :cl))

(in-package :bar-package)

(cl-reexport:reexport-from :bar-package.a
                           :include '(:x))
(cl-reexport:reexport-from :bar-package.b
                           :exclude '(:p))

(in-package :cl-reexport-test)

(multiple-value-bind (symbol status) (find-symbol "X" :bar-package)
  (is symbol 'bar-package.a:x)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "Q" :bar-package)
  (is symbol 'bar-package.b:q)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "R" :bar-package)
  (is symbol 'bar-package.b:r)
  (is status :external))

(multiple-value-bind (symbol status) (find-symbol "Y" :bar-package)
  (is symbol nil)
  (is status nil))

(multiple-value-bind (symbol status) (find-symbol "Z" :bar-package)
  (is symbol nil)
  (is status nil))

(multiple-value-bind (symbol status) (find-symbol "P" :bar-package)
  (is symbol nil)
  (is status nil))


;;;
;;; Test case 3
;;;

(is-error (cl-reexport:reexport-from :bar-package.a
                                     :include '(:x)
                                     :exclude '(:x))
          simple-error)



(finalize)
