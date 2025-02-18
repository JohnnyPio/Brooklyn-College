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
(defun howcompute (n1 n2 n3)
  (cond ((equal (+ n1 n2) n3) 'sum-of)
        ((equal (* n1 n2) n3) 'product-of)
        (t '(beats me))))
;; to extend howcompute you could add more clauses for other basic mat operations like subtraction and division, along with exponents and modulo

;;;4.14
;; CL-USER> (and 'fee 'fie 'foe)
;; FOE

;; CL-USER> (or 'fee 'fie 'foe)
;; FEE

;; CL-USER> (or nil 'foe nil)
;; FOE

;; CL-USER> (and 'fee 'fie nil)
;; NIL

;; CL-USER> (and (equal 'abc 'abc) 'yes)
;; YES

;; CL-USER> (or (equal 'abc 'abc) 'yes)
;; T

;;;4.15
(defun ged (n1 n2)
  (or (> n1 n2) (equal n1 n2)))

;;;4.16
(defun square_double_or_divide (x)
  (cond ((and (oddp x) (plusp x)) (* x x))
        ((and (oddp x) (minusp x)) (* x 2))
        (t (/ x 2))))

;;;4.17
(defun sex_agep (sex stage)
  (or (and (or (equal sex 'boy) (equal sex 'girl)) (equal stage 'child))
        (and (or (equal sex 'man) (equal sex 'woman)) (equal stage 'adult))))

;;;4.18
(defun play (p1 p2)
  (cond ((or(and (equal p1 'rock)(equal p2 'scissors))
            (and (equal p1 'paper)(equal p2 'rock))
            (and (equal p1 'scissors)(equal p2 'paper)))  'first-wins)
        ((or(and (equal p2 'rock)(equal p1 'scissors))
            (and (equal p2 'paper)(equal p1 'rock))
            (and (equal p2 'scissors)(equal p1 'paper))) 'second-wins)
      (t 'tie)))

;;;4.19
;; Commenting the below expressions to not cause errors compiling this file.
;; (cond ((not x) nil)
;;       ((not y) nil)
;;       ((not z) nil)
;;       (t w))

;; (if x
;;     (if y
;;         (if z w)))

;;;4.20
;; (defun compare (x y)
;;   (cond ((equal x y) ’numbers-are-the-same)
;;         ((< x y) ’first-is-smaller)
;;         ((> x y) ’first-is-bigger)))

(defun compare-ifs (x y)
  (if (equal x y) 'numbers-are-the-same
      (if (< x y) 'first-is-smaller 'first-is-bigger)))

(defun compare-and-or (x y)
 (or (and (equal x y) 'numbers-are-the-same)
     (and (< x y) 'first-is-smaller)
     'first-is-bigger))

;;;4.21
;; (defun gtest (x y)
;;   (or (> x y)
;;       (zerop x)
;;       (zerop y)))

(defun gtest-if (x y)
  (if (> x y) t
      (if (zerop x) t (zerop y))))

(defun gtest-cond (x y)
  (cond ((> x y) t)
        ((zerop x) t)
        (t (zerop y))))

;;; 4.22
(defun boilingp-cond (temp scale) 
  (cond ((equal scale 'fahrenheit) (>= temp 212))
        ((equal scale 'celsius) (>= temp 100))
        (t nil)))

(defun boilingp-ifs (temp scale)
  (if (equal scale 'fahrenheit) (> temp 212))
  (if (equal scale 'celsius) (> temp 100) nil))

(defun boilingp-or-and (temp scale)
  (or (and (> temp 212) (equal scale 'fahrenheit))
      (and (> temp 100) (equal scale 'celsius))))

;;;4.23
;; If WHERE-IS has 8 CONDs, it will need 7 IFs. WHERE-IS-3 will need 1 OR and 7 ANDs.


;;;;;; CHAPTER 5
;;;5.2. Actions functions take besides returning a value, such as changing the value of a variable.

;;;5.3. A global variable is not local to any specific function and is accessible everywhere. A local variable is a variable who's scope is restricted to the body of a function.

;;;5.4. SETF must be a macro function instead of a regular function because it doesn't evaluate the first argument - the variable name.

;;;5.5. Yes, LET and LET* are equivalent when only setting 1 local variable as there are no possible dependent variables.

;;;5.6.
;;5.6a.
(defun throw-die ()
  (+ 1 (random 6)))

;;5.6b.
(defun throw-dice ()
  (list (throw-die) (throw-die)))

;;5.6c.
(defun snake-eyes-p (throw)
  (equal throw '(1 1)))

(defun boxcars-p (throw)
  (equal throw '(6 6)))

;;5.6d.
(defun sum-throw (throw)
  (+ (first throw) (second throw)))

(defun instant-win-p (throw)
  (if (member (sum-throw throw) '(7 11)) t))

(defun instant-loss-p (throw)
  (if (member (sum-throw throw) '(2 3 12)) t))

;;5.6e.
 (defun say-throw (throw)
   (or (if (snake-eyes-p throw) 'snake-eyes)
       (if (boxcars-p throw) 'boxcars)
       (sum-throw throw)))

;;5.6f.
(defun craps ()
  (let ((throw (throw-dice)))
  (list 'throw (first throw) 'and (second throw) '-- (say-throw throw) '--)
    (if (instant-win-p throw) 'you-win
        (if (instant-loss-p throw) 'you-lose
            (list 'your 'point 'is (sum-throw throw))))))

;;5.6g.
;; This gave me much trouble - lots of warnings when compiling on line 273
(defun try-for-point (point)
  (let* ((throw (throw-dice))
         (val (sum-throw throw)))
    (append 
     (list ’throw (first throw)
                   'and (second throw) 
                   ’-- 
                    (say-throw throw) 
                    ’--)
     (cond ((equal val point) '(you win))
           ((equal val 7) '(you lose))
           (t '(throw again)
            )))))
