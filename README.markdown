# Cl-Reexport

Cl-reexport makes a package reexport symbols which are external symbols in other packages. This fanctionality is intended to be used with (virtual) hierarchical packages. For detail, see Usage section.

## Usage

Think about a (virutal) hierarchical package structure. Since Common Lisp standard has just a flat package system, the three packages are naturally at the same level, but you can regard the packages constituting a hierarchy virtually.

    FOO-package
    - FOO-PACKAGE.BAR
    - FOO-PACKAGE.BAZ

Here, their definitions are:

    (in-package :cl-user)

    (defpackage foo-package.bar
      (:use :cl)
      (:export x))

    (defpackage foo-package.baz
      (:use :cl)
      (:export y))

    (defpackage foo-package
      (:use :cl))

If you want reexport external symbols in FOO-PACKAGE.BAR and FOO-PACKAGE.BAZ from FOO-PACKAGE, you may just write as below:

    (in-package :foo-package)
    (cl-reexport:reexport-from :foo-package.bar)
    (cl-reexport:reexport-from :foo-package.baz)

    (in-package :cl-user)

    (describe 'x)
    >> FOO-PACKAGE.BAR:X
    >>   [symbol]

    (describe 'y)
    >> FOO-PACKAGE.BAZ:Y
    >>   [symbol]

You can also write like this in one line:

    (cl-reexport:reexport-from '(:foo-package.bar :foo-package.baz))

cl-reexport is more useful when sub-packages have many external symbols.


## Difference from ASDF 3's one-package-per-file fanctionality

ASDF 3 has one-package-per-file fanctionality and its runtime support. The structural difference between (virtual) hierarchical packages and ASDF 3's one-package-per-file fanctionality is:

* (Virtual) hierarchical packages have one system definition and several packages constitute a hierarchical structure.
* ASDF 3's one-package-per-file style has hierarchical system definitions and hierarchical packages, whcih are corresponding each other.

When you use former style, you can use cl-reexport.

## Author

* Masayuki Takagi (kamonama@gmail.com)

## Copyright

Copyright (c) 2014 Masayuki Takagi (kamonama@gmail.com)

## License

Licensed under the LLGPL License.
