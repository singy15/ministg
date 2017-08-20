
(defpackage effect
  (:use cl cl-user)
  (:export))
(in-package :effect)

(in-package :ministg)

(defclass effect (cl-singleton-mixin:singleton-mixin) ())

(defmethod spawn-debris ((this effect) game x y)
  (let ((d (make-instance 'debris)))
    (setf (:x d) x)
    (setf (:y d) y)
    (set-lifetime d 10)
    (register game d)))

(defmethod spawn-explosion ((this effect) game x y)
  (loop for i from 0 to 10 do
    (let ((d (make-instance 'debris)))
      (setf (:x d) x)
      (setf (:y d) y)
      (set-lifetime d 50)
      (register game d))))

(in-package :cl-user)

