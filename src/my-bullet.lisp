
(defpackage my-bullet
  (:use cl cl-user)
  (:export +spd+
           +col-size+
           +lifetime+))
(in-package :my-bullet)

(defvar +spd+ -20.0)
(defvar +col-size+ 10.0)
(defvar +lifetime+ 30)

(in-package :ministg)

(defclass my-bullet (actor) ())

(defmethod initialize-instance :around ((this my-bullet) &key) 
  (setf (:dy this) my-bullet:+spd+)
  (setf (:col-size this) my-bullet:+col-size+)
  (set-lifetime this my-bullet:+lifetime+)
  (call-next-method this))

(defmethod draw ((this my-bullet))
	(loop for x from 0 to 10 do
    (lg:rndline-wca (:x this) (:y this) (:x this) (:y this) 2.0 1.0 1.0 1.0 1.0 10.0))
  (call-next-method))

(in-package :cl-user)

