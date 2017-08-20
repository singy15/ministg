
(defpackage missile
  (:use cl cl-user)
  (:export +spd+
           +col-size+
           +d-dump+
           +lifetime+
           +debris-lifetime+))
(in-package :missile)

(defvar +spd+ 0.3)
(defvar +col-size+ 10.0)
(defvar +d-dump+ 0.97)
(defvar +lifetime+ 200)

(in-package :ministg)

(defclass missile (actor) ())

(defmethod initialize-instance :around ((this missile) &key) 
  (set-lifetime this missile:+lifetime+) 
  (setf (:col-size this) missile:+col-size+)
  (setf (:d-dump this) missile:+d-dump+)
  (call-next-method this))

(defmethod guide ((this missile) game)
  (let ((nearest nil) (dist 9999.0))
    (mapc
      (lambda (e)
        (when (< (distance this e) dist)
          (setf nearest e)
          (setf dist (distance this e))))
      (:ls-enemy game))

    (when nearest
      (if (< (:x this) (:x nearest))
        (incf (:dx this) missile:+spd+)
        (decf (:dx this) missile:+spd+))
      (if (< (:y this) (:y nearest))
        (incf (:dy this) missile:+spd+)
        (decf (:dy this) missile:+spd+)))))

(defmethod updt/game ((this missile) game)
  (guide this game)
  (spawn-debris (make-instance 'effect) game (:x this) (:y this))
  
  (call-next-method))

(defmethod draw ((this missile))
  (let (theta d-theta cs sn)
    (setf d-theta 0.3)
    (setf theta (+ PI (atan (:dy this) (:dx this))))
    (lg:line-wca (:x this) (:y this) (+ (:x this) (* 10.0 (cos (+ theta d-theta)))) (+ (:y this) (* 10.0 (sin (+ theta d-theta)))) 2.0 1.0 1.0 1.0 1.0)
    (lg:line-wca (:x this) (:y this) (+ (:x this) (* 10.0 (cos (- theta d-theta)))) (+ (:y this) (* 10.0 (sin (- theta d-theta)))) 2.0 1.0 1.0 1.0 1.0)
    (lg:line-wca (+ (:x this) (* 10.0 (cos (+ theta d-theta)))) (+ (:y this) (* 10.0 (sin (+ theta d-theta)))) 
                 (+ (:x this) (* 10.0 (cos (- theta d-theta)))) (+ (:y this) (* 10.0 (sin (- theta d-theta)))) 2.0 1.0 1.0 1.0 1.0)

    (setf cs (cos theta))
    (setf sn (sin theta))
    (loop for x from 0 to 10 do
      (lg:rndline-wca (+ (:x this) (* 10.0 cs)) (+ (:y this) (* 10.0 sn)) (+ (:x this) (* 10.0 cs)) (+ (:y this) (* 10.0 sn)) 2.0 1.0 1.0 1.0 1.0 10.0)))
  (call-next-method))

(in-package :cl-user)

