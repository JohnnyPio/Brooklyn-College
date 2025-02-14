;John Piotrowski - 7410x - HW2

;;; 4.1
(defun make-even (x)
  (if (oddp x) (+ x 1) x))

;;; 4.2
(defun further (x)
  (if (> x 0) (+ x 1) (- x 1)))
; x=0, that makes the condition NIL so it subtracts 1.

;;; 4.3

