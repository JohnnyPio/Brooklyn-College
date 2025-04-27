#lang scheme
(require malt)

;; using (define)
(define pi 3.14)

(define x 100)

;; functions are created using lambda keyword
(define add (lambda (x y) (+ x y)))

;; you can pass values to the function if it's not named
((lambda (x y) (+ x y)) 99 101)

;; you can name the function using (define)
(define area-of-circle
  (lambda (radius)
    (* pi (* radius radius))))

;eval (area-of-circle 1)
;eval (area-of-circle 10)

;; functions can also resolve to values that are also functions
(define area-of-rectangle
  (lambda (width)
    (lambda (height)
      (* width height))))

;(area-of-rectangle 3)
;((area-of-rectangle 3) 9)

;((lambda (height)
;   (* 1.3 height)) 4)

(define add3
  (lambda (x)
    (+ 3 x)))

(define double-the-result
  (lambda (apply-f-to)
    (lambda (z)
      (* 2 (apply-f-to z)))))

(add3 4)

;;this returns a function/procedure that we can pass formals to
(double-the-result add3)

((double-the-result add3) 10)

(define dd (double-the-result add3))

;; we can use the named function in the same way
(dd 10)

;;in scheme cond uses else instead of t for its default
(define pie 2)

(cond
  ((= pie 4) 28)
  ((= pie 2) 33)
  (else 17))

;; no loops in scheme only recursion
;; example remainder function

(define remainder
  (lambda (dividend divisor)
    (cond
      ((< dividend divisor) dividend)
      (else (remainder (- dividend divisor) divisor)))))

(remainder 10 3)
(remainder 13 4)

;;CHAPTER 1. WHAT IS LEARNING?
;;(require plot)
(plot (list (function (λ (x) (* 2 x)) -100 100)(x-axis)(y-axis)))