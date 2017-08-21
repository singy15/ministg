
(defpackage game
  (:use cl cl-user)
  (:export exec-with-fps-control))
(in-package :game)

(defparameter *now-t* 0)
(defparameter *next-frame-t* 0)
(defparameter +fps+ 60.0)

;; Keep 60FPS
(defun exec-with-fps-control (fn)
  (setf *now-t* (get-internal-real-time))
  (if (< *now-t* *next-frame-t*)
    (funcall fn))
  (setf *now-t* (get-internal-real-time))
  (if (< *now-t* *next-frame-t*)
  (sleep (/ (- *next-frame-t* *now-t*) 1000.0)))
  (setf *next-frame-t* (+ (get-internal-real-time)
                        (* 1000.0 (/ 1.0 +fps+)))))

(in-package :ministg)

(defclass game () 
  ((ls-my-bullet
     :accessor ls-my-bullet
     :initform (list))
   (ls-enemy
     :accessor ls-enemy
     :initform (list))
   (ls-missile
     :accessor ls-missile
     :initform (list))
   (ls-debris
     :accessor ls-debris
     :initform (list))
   (mychar
     :accessor mychar
     :initform nil)
   (tm
     :accessor tm
     :initform 0)))

(defmethod initialize-instance :around ((this game) &key) 
  (setf (mychar this) (make-instance 'mychar))
  (call-next-method this))

(defmethod register ((this game) (obj my-bullet))
  (setf (ls-my-bullet this) (cons obj (ls-my-bullet this))))

(defmethod register ((this game) (obj missile))
  (setf (ls-missile this) (cons obj (ls-missile this))))

(defmethod register ((this game) (obj enemy))
  (setf (ls-enemy this) (cons obj (ls-enemy this))))

(defmethod register ((this game) (obj debris))
  (setf (ls-debris this) (cons obj (ls-debris this))))

(defmethod cleanup ((this game))
  (setf (ls-enemy this) (remove-if #'p-dead (ls-enemy this)))
  (setf (ls-my-bullet this) (remove-if #'p-dead (ls-my-bullet this)))
  (setf (ls-missile this) (remove-if #'p-dead (ls-missile this)))
  (setf (ls-debris this) (remove-if #'p-dead (ls-debris this))))

(defmethod kill-collided ((this game) ls-a ls-b)
  (mapc (lambda (b)
        (mapc (lambda (a)
                (if (p-collide a b)
                  (progn
                    (kill a)
                    (kill b)
                    (spawn-explosion (make-instance 'effect) this (x a) (y a)))))
              ls-a))
      ls-b))

(defmethod draw ((this game))
  (lg:rect-fca 0.0 0.0 lg:*width* lg:*height* 0.2 0.2 0.2 0.8)

  (mapc (lambda (e)
          (draw e))
        (ls-enemy this))
  (mapc (lambda (e)
          (draw e))
        (ls-my-bullet this))
  (mapc (lambda (e)
          (draw e))
        (ls-missile this))
  (mapc (lambda (e)
          (draw e))
        (ls-debris this))
  (draw (mychar this)))

(defmethod spawn-enemy ((this game))
  (if (equal 0 (mod (tm this) 20))
    (register this (make-instance 'enemy))))

(defmethod updt ((this game))
  (incf (tm this))
  (spawn-enemy this)
  
  (mapc (lambda (e)
          (updt/game e this))
        (ls-enemy this))
  (mapc (lambda (e)
          (updt/game e this))
        (ls-my-bullet this))
  (mapc (lambda (e)
          (updt/game e this))
        (ls-missile this))
  (mapc (lambda (e)
          (updt/game e this))
        (ls-debris this))
  (updt/game (mychar this) this)
  
  (kill-collided this (ls-my-bullet this) (ls-enemy this))
  (kill-collided this (ls-missile this) (ls-enemy this))
  (cleanup this))

(defmethod tick ((this game))
  (game:exec-with-fps-control 
    (lambda ()
      (updt this)
      (draw this))))

(in-package :cl-user)

