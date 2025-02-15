;John Piotrowski - 7410x - HW2
;4.1-4.23, 5.2-5.7

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

;;;4.6
(defun my-abs (x) 
  (cond ((< x 0) (* x -1))
        (t x)))

;;;4.7
;; (cond (symbolp x) ’symbol
;;       (t ’not-a-symbol))
;; Incorrect, correct is below:
;; (cond ((symbolp x) ’symbol)
;;       (t ’not-a-symbol))


;; (cond ((symbolp x) ’symbol)
;;       (t ’not-a-symbol))
;; Correct!


;; (cond ((symbolp x) (’symbol))
;;       (t ’not-a-symbol))
;; Incorrect - don't need the extra parenthesis around 'symbol


;; (cond ((symbolp x) ’symbol)
;;       ((t ’not-a-symbol)))
;; Incorrect - don't need the extra parenthesis around (t ’not-a-symbol) 

;;;4.8
(defun emphasize3 (x)
  (cond ((equal (first x) 'good)
         (cons 'great (rest x)))
         ((equal (first x) 'bad)
          (cons 'awful (rest x)))
         (t (cons 'very x))))

;; CL-USER> (emphasize3 '(very long day))
;; (VERY VERY LONG DAY)

;;;4.9 
;; (defun make-odd (x)
;;   (cond (t x)
;;         ((not (oddp x)) (+ x 1))))

;; CL-USER> (make-odd 3)
;; 3
;; CL-USER> (make-odd -2)
;; -2
;; CL-USER> (make-odd  4)
;; 5
;; This function had the clauses in the wrong order 

(defun make-odd (x)
  (cond ((not (oddp x)) (+ x 1))
        (t x)))

;;;4.10
(defun constraint (x min max)
  (cond ((< x min) min)
        ((> x max) max)
        (t x)))

(defun constraint-ifs (x min max)
  (if (< x min) min x)
   (if (> x max) max x))

;;;4.11
(defun firstzero (x)
  (cond ((zerop (first x)) 'first)
        ((zerop (second x)) 'second)
        ((zerop (third x)) 'third)
        (t 'none)))
;;(firstzero 3 0 4) -> invalid number of arguments: 3

;;;4.12
(defun cycle (x)
  (if (equal x 99) 1 (+ x 1)))

;;;4.13
