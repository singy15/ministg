
(defpackage weap-bullet
  (:use cl cl-user)
  (:export))
(in-package :weap-bullet)

(in-package :ministg)

(defclass weap-bullet (weapon) ())

(defmethod initialize-instance :around ((this weap-bullet) &key parent) 
  (setf (recharge-max this) 10)
  (call-next-method this :parent parent))

(defmethod launch ((this weap-bullet) game)
  (let (b)
    (setf b (make-instance 'my-bullet))
    (setf (:x b) (:x (parent this)))
    (setf (:y b) (:y (parent this)))
    (register game b)))

(in-package :cl-user)

