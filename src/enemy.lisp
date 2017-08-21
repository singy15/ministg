
(defpackage enemy
  (:use cl cl-user)
  (:export +spd+
           +col-size+))
(in-package :enemy)

(defvar +spd+ 2.0)
(defvar +col-size+ 20.0)

(in-package :ministg)

(defclass enemy (actor) ())

(defmethod initialize-instance :around ((this enemy) &key) 
  (setf (col-size this) enemy:+col-size+)
  (setf (dy this) enemy:+spd+)
  (setf (x this) (random lg:*width*))
  (setf (y this) 0.0)
  (set-lifetime this 300)
  (call-next-method this))

(defmethod draw ((this enemy))
	(lg:line-wca (x this) (y this) (- (x this) 15.0) (- (y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
	(lg:line-wca (x this) (y this) (+ (x this) 15.0) (- (y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
	(lg:line-wca (x this) (- (y this) 15.0) (+ (x this) 15.0) (- (y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
	(lg:line-wca (x this) (- (y this) 15.0) (- (x this) 15.0) (- (y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
	(lg:line-wca (x this) (y this) (x this) (- (y this) 15.0) 3.0 1.0 1.0 1.0 1.0)
  (call-next-method))

(in-package :cl-user)

