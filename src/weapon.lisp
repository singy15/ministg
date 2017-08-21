
(defpackage weapon
  (:use cl cl-user)
  (:export ))
(in-package :weapon)

(in-package :ministg)

(defclass weapon () 
  ((recharge
     :accessor recharge
     :initform 0)
   (recharge-max
     :accessor recharge-max
     :initform 0)
   (parent
     :accessor parent
     :initform 0)))

(defmethod initialize-instance :around ((this weapon) &key parent) 
  (setf (parent this) parent)
  (call-next-method this))

(defmethod charge ((this weapon))
  (incf (recharge this))
  (if (> (recharge this) (recharge-max this))
    (setf (recharge this) (recharge-max this))))

(defmethod updt ((this weapon))
  (charge this))

(defmethod p-recharged ((this weapon))
  (equal (recharge-max this) (recharge this)))

(defmethod fire ((this weapon) game)
  (when (p-recharged this)
    (launch this game)
    (setf (recharge this) 0)))

(defmethod launch ((this weapon) game))

(in-package :cl-user)

