
(defpackage weap-missile
  (:use cl cl-user)
  (:export +init-msl-spd+))
(in-package :weap-missile)

(defvar +init-msl-spd+ 5.0)

(in-package :ministg)

(defclass weap-missile (weapon) ())

(defmethod initialize-instance :around ((this weap-missile) &key parent) 
  (setf (recharge-max this) 20)
  (call-next-method this :parent parent))

(defmethod launch-single-msl ((this weap-missile) game dx dy)
  (let (b)
    (setf b (make-instance 'missile))
    (setf (:x b) (:x (parent this)))
    (setf (:y b) (:y (parent this)))
    (setf (:dx b) dx)
    (setf (:dy b) dy)
    (register game b)))

(defmethod launch ((this weap-missile) game)
  (launch-single-msl this game weap-missile:+init-msl-spd+ 0.0)
  (launch-single-msl this game (- weap-missile:+init-msl-spd+) 0.0)
  (call-next-method))

(in-package :cl-user)

