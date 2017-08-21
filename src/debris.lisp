
(defpackage debris
  (:use cl cl-user)
  (:export ))
(in-package :debris)

(in-package :ministg)

(defclass debris (actor) ())

(defmethod initialize-instance :around ((this debris) &key) 
  (setf (dx this) (- (random 1.0) 0.5))
  (setf (dy this) (- (random 1.0) 0.5))
  (set-lifetime this 50)
  (call-next-method this))

(defmethod draw ((this debris))
  (lg:rndline-wca (x this) (y this) (x this) (y this) 1.0 1.0 1.0 1.0 0.5 10.0) 
  (call-next-method))

(in-package :cl-user)

