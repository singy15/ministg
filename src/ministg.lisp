
(defpackage ministg
  (:use cl cl-user)
  (:export main))
(in-package :ministg)

(defun lg:user-init ()
  (defparameter *game* (make-instance 'game)))

(defun lg:user-display ()
  (tick *game*))

(defun main ()
  (lg:main))

(in-package :cl-user)
