
(defpackage mychar
  (:use cl cl-user)
  (:export +spd+
           +d-dump+
           +col-size+))
(in-package :mychar)

(defvar +spd+ 1.5)
(defvar +d-dump+ 0.80)
(defvar +col-size+ 5.0)

(in-package :ministg)

(defclass mychar (actor) 
  ((ls-weapons
     :accessor ls-weapons
     :initform nil)))

(defmethod initialize-instance :around ((this mychar) &key) 
  (setf (:d-dump this) mychar:+d-dump+)
  (setf (:spd this) mychar:+spd+)
  (setf (:x this) (/ lg:*width* 2.0))
  (setf (:y this) (/ lg:*height* 2.0))
  (setf (:col-size this) mychar:+col-size+)
  (setf (ls-weapons this) 
        (list (make-instance 'weap-bullet :parent this) 
              (make-instance 'weap-missile :parent this)))
  (call-next-method this))

(defmethod off-screen ((this mychar))
  (if (< (:x this) 0.0)
    (setf (:x this) 0.0))
  (if (> (:x this) lg:*width*)
    (setf (:x this) lg:*width*))
  (if (< (:y this) 0.0)
    (setf (:y this) 0.0))
  (if (> (:y this) lg:*height*)
    (setf (:y this) lg:*height*)))

(defmethod updt-weapons ((this mychar))
  (mapc #'updt (ls-weapons this)))

(defmethod fire-weapons ((this mychar) game)
  (mapc (lambda (w) (fire w game)) 
        (ls-weapons this)))

(defmethod control ((this mychar) game)
  (if (gethash #\w lg:*keys*)
    (setf (:dy this) (- (:dy this) (:spd this))))
  (if (gethash #\s lg:*keys*)
    (setf (:dy this) (+ (:dy this) (:spd this))))
  (if (gethash #\a lg:*keys*)
    (setf (:dx this) (- (:dx this) (:spd this))))
  (if (gethash #\d lg:*keys*)
    (setf (:dx this) (+ (:dx this) (:spd this))))
  (if (gethash #\j lg:*keys*)
    (fire-weapons this game)))

(defmethod updt/game ((this mychar) game)
  (control this game)

  (updt-weapons this)
  (off-screen this)
  (call-next-method))

(defmethod draw ((this mychar))
  (lg:line-wca (:x this) (- (:y this) 10.0) (- (:x this) 10.0) (+ (:y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
  (lg:line-wca (:x this) (- (:y this) 10.0) (+ (:x this) 10.0) (+ (:y this) 10.0) 3.0 1.0 1.0 1.0 1.0)
  (lg:line-wca (:x this) (- (:y this) 10.0) (- (:x this) 5.0) (+ (:y this) 15.0) 3.0 1.0 1.0 1.0 1.0)
  (lg:line-wca (:x this) (- (:y this) 10.0) (+ (:x this) 5.0) (+ (:y this) 15.0) 3.0 1.0 1.0 1.0 1.0)
  (call-next-method))

(in-package :cl-user)

