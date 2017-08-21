
(defpackage actor
  (:use cl cl-user)
  (:export ))
(in-package :actor)

(in-package :ministg)

;; Actor
(defclass actor ()
  ((is-alive
     :accessor is-alive
     :initform t)
   (col-size
     :accessor col-size
     :initform 0.0
     :initarg :col-size)
   (x
     :accessor x
     :initform 0.0)
   (y
     :accessor y
     :initform 0.0)
   (dx
     :accessor dx
     :initform 0.0)
   (dy
     :accessor dy
     :initform 0.0)
   (d-dump
     :accessor d-dump
     :initform 1.0)
   (lifetime
     :accessor lifetime
     :initform 0)
   (lifetime-enabled
     :accessor lifetime-enabled
     :initform nil)
   (spd
     :accessor spd
     :initform 0.0)))

(defmethod updt/game ((this actor) game)
  (when (lifetime-enabled this)
    (if (<= (setf (lifetime this) (- (lifetime this) 1)) 0 )
      (setf (is-alive this) nil)))

  (setf (x this) (+ (x this) (dx this)))
  (setf (y this) (+ (y this) (dy this)))
  (setf (dx this) (* (dx this) (d-dump this)))
  (setf (dy this) (* (dy this) (d-dump this)))
  this)

(defmethod p-collide ((this actor) (they actor))
  (< (distance this they) (+ (col-size this) (col-size they))))

(defmethod distance ((this actor) (they actor))
  (sqrt (+ (expt (- (x this) (x they)) 2) 
           (expt (- (y this) (y they)) 2))))

(defmethod draw ((this actor)))

(defmethod set-lifetime ((this actor) lifetime)
  (setf (lifetime this) lifetime)
  (setf (lifetime-enabled this) t))

(defmethod kill ((this actor))
  (setf (is-alive this) nil))

(defmethod p-dead ((this actor))
  (not (is-alive this)))

(in-package :cl-user)
