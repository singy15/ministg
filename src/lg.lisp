
;; define package lg
(in-package :cl-user)
(defpackage lg
  (:use :cl :cl-opengl)
  (:export
    :main
    :user-init
    :user-display
    :line-wca
    :rndline-wca
    :rect-fca
    :*width*
    :*height*
    :*keys*))
(in-package :lg)

;; constances
(defparameter *width* 500)
(defparameter *height* 500)

;; window class
(defclass main-window (glut:window) ()
	(:default-initargs :title "lg test" :mode '(:double :rgb :depth) :width *width* :height *height*))

;; variable
(defparameter *keys-ls* '(#\w #\s #\a #\d #\j #\Esc))

(defparameter *keys* 
  (let ((ht (make-hash-table)))
    (mapc
      (lambda (x)
        (setf (gethash x ht) nil))
      *keys-ls*)
    ht))

(defun hash-keys (hash-table)
  (loop for key being the hash-keys of hash-table collect key))

;; Key pressed.
(defmethod glut:keyboard ((window main-window) key x y)
  ;; Exit on esc pressed.
  (if (equal key #\Esc)
    (glut:destroy-current-window))

  (mapc
    (lambda (x)
      (if (equal x key)
        (setf (gethash x *keys*) t)))
    (hash-keys *keys*)))

;; Key released.
(defmethod glut:keyboard-up ((window main-window) key x y )
  (mapc
    (lambda (x)
      (if (equal x key)
        (setf (gethash x *keys*) nil)))
    (hash-keys *keys*)))

;; draw colored transparent width line
(defun line-wca (x y x2 y2 w r g b a)
  (gl:enable :blend)
  (gl:hint :line-smooth-hint :fastest)
  (gl:enable :line-smooth)
  (gl:line-width w)
  (gl:begin :lines)
  (gl:color r g b a)
  (gl:vertex x y 0.0)
  (gl:vertex x2 y2 0.0)
  (gl:end)
  (gl:disable :blend)
  (gl:disable :line-smooth)
  (gl:line-width 1))
  
;; draw line randomly
(defun rndline-wca (x y x2 y2 w r g b a size)
	(line-wca x y x2 y2 w r g b a)
	(line-wca (+ (random size) (- x (/ size 2.0)) ) (+ (random size) (- y (/ size 2.0))) x2 y2 w r g b a))

;; draw filled rect colored
(defun rect-fca (x y x2 y2 r g b a)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (gl:enable :blend)
  (gl:begin :polygon)
  (gl:color r g b a)
  (gl:vertex x y 0.0)
  (gl:vertex x2 y 0.0)
  (gl:vertex x2 y2 0.0)
  (gl:vertex x y2 0.0)
  (gl:end)
  (gl:disable :blend)
  (gl:color 1.0 1.0 1.0))

;; user functions
;; overwrite these function
(defun user-display () ())
(defun user-init () ())

;; draw
(defmethod glut:display ((window main-window))
  (gl:shade-model :flat)
  (gl:normal 0 0 1)
  (user-display)
  (glut:swap-buffers))

;; idle
(defmethod glut:idle ((window main-window))
  (glut:post-redisplay))

;; reshape
(defmethod glut:reshape ((w main-window) width height)
  (gl:viewport 0 0 width height)
  (gl:load-identity)
  (glu:ortho-2d 0.0 *width* *height* 0.0))

;; draw
(defmethod glut:display-window :before ((window main-window)) )

(defun main ()
  (user-init)
  (glut:display-window (make-instance 'main-window)))

(in-package :cl-user)
