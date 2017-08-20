
(in-package :cl-user)
(defpackage ministg-asd
  (:use :cl :asdf))
(in-package :ministg-asd)

(defsystem ministg
  :depends-on (:cl-opengl :cl-glut :cl-glu :cl-singleton-mixin)
  :components (
    (:module "src"
      :components (
        (:file "lg")
        (:file "package")
        (:file "weapon")
        (:file "weap-bullet")
        (:file "weap-missile")
        (:file "actor")
        (:file "my-bullet")
        (:file "debris")
        (:file "missile")
        (:file "mychar")
        (:file "enemy")
        (:file "effect")
        (:file "game")
        (:file "ministg")))))

