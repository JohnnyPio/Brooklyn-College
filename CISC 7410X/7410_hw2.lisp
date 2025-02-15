;John Piotrowski - 7410x - HW2

;;; 4.1
(defun make-even (x)
  (if (oddp x) (+ x 1) x))

;;; 4.2
(defun further (x)
  (if (> x 0) (+ x 1) (- x 1)))
; x=0, that makes the condition NIL so it subtracts 1.

;;; 4.3
(defun my-not (x)
  (if x nil t))


;;;4.4
(defun ordered (x y)
  (if (< x y) (list x y) (list y x)))

;;;4.5
(defun compare (x y)
  (cond ((equal x y) 'numbers-are-the-same)
  ((< x y) 'first-is-smaller)
  ((> x y) 'first-is-bigger)))

;first-is-bigger (compare 9 1)
;first-is-smaller (compare (+ 2 2) 5)
;numbers-are-the-same (compare 6 (* 2 3))

;;;4.5
(defun my-abs (x) 
  (cond ((< x 0) (* x -1))
        (t x)))

;;;4.6
