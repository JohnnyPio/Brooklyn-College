#lang scheme
(require malt)
(require racket/trace)

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
;; (plot (list (function (λ (x) (* 2 x)) -100 100)(x-axis)(y-axis)))

;;;;;;;CHAPTER 3
;;Successive approximation to find the well-fitted theta
;;(going off the simple line example)
;; Start with (@=theta) @0=0 and @1=0

(define line
  (lambda (x)
    (lambda (theta)
      (+ (* x (ref theta 0))
         (ref theta 1)))))


;Starting dataset we're going to train to get thetas
(define xs (tensor 2.0 1.0 4.0 3.0))
(define ys (tensor 1.8 1.2 4.2 3.3))

((line xs)(list 0.0 0.0))

;; in this case the results is (tensor 0.0 0.0 0.0 0.0) is the x axis.

;;THE LOSS
;;Find LOSS by subtracting predicted ys from expected ys
;;we don't want our loss to be a tensor, we want it to be a scalar to easily adjust theta

(- ys ((line xs)(list 0.0 0.0)))
;(tensor 1.8 1.2 4.2 3.3)

;; sum that all together to get a scalar
;; but first we need to normalize it in case we have neg and pos numbers we're summing
;; we normalize it by squaring it

(sum (sqr (tensor 4.0 -3.0 0.0 -4.0 3.0)))

;; LOSS function (l squared)
(define l2-loss-initial
  (lambda (xs ys)
    (lambda (theta)
      (let ((pred-ys ((line xs) theta)))
        (sum
         (sqr
          (- ys pred-ys)))))))

;; we would like to generalize l2-loss so it works on more than just lines
;; we want to be able to apply it to any function to find the loss
;; given x's y's and theta, so lets allow us to pass it a function

;;We want to generalize l2-loss so it works on more than just lines

(define l2-loss
  (lambda (target)
    (lambda (xs ys)
      (lambda (theta)
        (let ((pred-ys ((target xs) theta)))
              (sum
               (sqr
                (- ys pred-ys))))))))

;;(l2-loss line) line) produces an expectant function (function that's expecting a dataset)
;;((l2-loss line) xs ys) produces an objective function
;;(l2-loss theta) is the objective function
;;The objective function takes returns a scalar representing the loss

(((l2-loss line) xs ys) (list 0.0 0.0))
;;loss is 33.21

;;we begin by revising theta by just revisiting theta-0 (w)
;;let's change theta-0 by a tiny amount

(((l2-loss line) xs ys) (list 0.0099 0.0))
;;hooray our loss went down and changed by - 0.62, which is delta

;;if we divide the two (change of loss/change of theta) we'll get the rate of change (-.62/.0099)

(/ -.62 .0099)
;;-62.63 is a very big rate of change, we should be careful we don't overshoot

(((l2-loss line) xs ys) (list 62.63 0.0))
;; our new loss is 113763.027 - that's much worse

;;to be more careful let's take 1% of the rate of change (LEARNING RATE)
(* .01 -62.63)

(((l2-loss line) xs ys) (list (- 0.0 -.6263) 0.0))
;; loss is 5.52

;;We don't keep applying this chage to theta-0, we find the new rate of change
;;We use GRADIENT DESCENT to find the new rates of change
;;Graph theta-0 against the loss at theta-0 at -1.0 0.0 1.0 2.0 3.0


(((l2-loss line) xs ys) (list -1.0 0.0)) ;;126.21
(((l2-loss line) xs ys) (list 0.0 0.0))  ;;33.21
(((l2-loss line) xs ys) (list 1.0 0.0))  ;;0.21
(((l2-loss line) xs ys) (list 2.0 0.0))  ;;27.21
(((l2-loss line) xs ys) (list 3.0 0.0))  ;;114.21
;;This gives us a curve, the slope of which is the gradient

(define obj-func  ((l2-loss line) xs ys))

(obj-func (list -1.0 0.0))
(obj-func (list -0.0 0.0))
(obj-func (list 1.0 0.0))
(obj-func (list 2.0 0.0))
(obj-func (list 3.0 0.0))

(define grad-obj
  (lambda (theta)
    ;; example gradient function; modify as needed
    (map (lambda (x) (* x x)) theta))) ; gradient = theta ^ 2


;;GRADIENT DESCENT
;;For every theta was get a loss, the gradient descent curve is the graph of the theta (X) and loss (Y)
;;The malt package has a function taht will return the slope of the tangent line GRADIENT-OF


;; (define gradient-descent-old
;;   (lambda (object s-theta)
;;     (let ((f (lambda (b-theta)
;;                (map (lambda (p g)
;;                       (- p (* a g)))
;;                     b-theta
;;                     (grad-obj b-theta)))))
;;       (revise f revs s-theta))))

;; (gradient-descent-old obj-func (list 0.0 0.0))

;; Let's take x^2 as example, If we want to know the slope of function, we can use gradient-of in malt.

(gradient-of (lambda (x) (sqr x)) 18) ;;36.0
(gradient-of (lambda (x) (sqr x)) 12) ;;24.0

;; usually theta is amde up on more than one param, so gradient-of will find the gradient with respect to each parameter
(gradient-of (lambda (x) (sqr x)) (tensor 5.0 3.0))  ;;(Tensor 10.0 6.0)

;; in the previous example, we use theta0 to approximate rate of change

(gradient-of (lambda (theta) (obj-func theta)) (list 0.0 0.0))  ;;(-63.0 -21.0)

;; We need to keep revising theta until we find the optimal theta
;; we can apply the grandient-of function repeatdedly to determine the rate-of-change at each theta
;; we use revise, a recursive function that applies a revision func to theta a REVS number of times

(define revise
  (lambda (f revs theta)
    (cond
      ((zero? revs) theta)
          (else
           (revise f (sub1 revs) (f theta))))))

(define minus-3 (lambda (theta)
                  (map (lambda (p)
                         (- p 3)) theta)))

(minus-3 '(3 6 9))
(revise minus-3 5 '(9 12 15))

;; We need to come up with a revision function to pass to revise, takes 3 args
;; Learning rate = alpha
;; Number of revs = revisions


(let ((f (lambda (theta)
           (let ((gs (gradient-of (lambda (theta) (((l2-loss line) xs ys) theta)) theta)))
             (list
              (- (ref theta 0) (* .01 (ref gs 0)))
              (- (ref theta 1) (* .01 (ref gs 1))))))))
  (revise f 1000 (list 0.0 0.0)))

;; Now need to cleanup the revision function, it only works on a obj. func. that takes thetas of two params. We need to generalize.

;; (map (lambda (param gradient)
;;        (- param (* alpha gradient)))
;;      theta
;;      gradients)

(define revs 1000)
(define alpha .01)


;; (let ((f (lambda (theta)
;;              (map (lambda (param gradient)
;;                     (- param (* alpha gradient)))
;;                   theta
;;                   (gradient-of (lambda (theta) (((l2-loss line) xs ys) theta)) theta)))))
;;   (revise f revs (list 0.0 0.0)))

(define gradient-descent
  (lambda (obj theta)
    (let ((f (lambda (big-theta)
               (map (lambda (param gradient)
                      (- param (* alpha gradient)))
                    big-theta
                    (gradient-of (lambda (big-theta) (obj big-theta)) big-theta)))))
      (revise f revs theta))))

;; (trace gradient-descent)
;; (trace revise)
;; (trace l2-loss)

;;here we call our gradient descent function we call 
(gradient-descent
 ((l2-loss line) xs  ys)
 (list 0.0 0.0))

;; (declare-hyper smaller)
;; (declare-hyper larger)

;; (with-hypers
;;   ((smaller 1)
;;    (larger 2000))
;;   (+ smaller larger))

;;;;;;; CHAPTER 5

;; (declare-hyper alpha)
;; (declare-hyper revs)

(with-hypers
  ((alpha .01)
   (revs 1000))
  (gradient-descent
   ((l2-loss line) xs ys)
   (list 0.0 0.0)))


;;Try it on a more complex, quadratic equation
(define q-xs (tensor -1.0 0.0 1.0 2.0 3.0))
(define q-ys (tensor 2.55 2.1 4.35 10.2 18.25))

(define quad
  (lambda (t)
    (lambda (theta)
      (+ (* (ref theta 0) (sqr t))
         (+ (* (ref theta 1) t) (ref theta 2))))))

(gradient-descent ((l2-loss quad) q-xs q-ys) (list 0.0 0.0 0.0))

;; Try it on plane
(define plane
  (lambda (t)
    (lambda (theta)
      (+ (dot-product  (ref theta 0)  t) (ref theta 1)))))

;; this is our data set of planes arguments
(define p-xs (tensor
              (tensor 1.0 2.05)
              (tensor 1.0 3.0)
              (tensor 2.0 2.0)
              (tensor 2.0 3.91)
              (tensor 3.0 6.13)
              (tensor 4.0 8.09)))

;; these are the givne y's
(define p-ys (tensor 13.99 15.99 18.0 22.4 30.2 37.94))

(define our-dot
  (lambda (w t)
    (sum (* w t))))

(with-hypers
  ((revs 1000)
   (alpha .001))
  (gradient-descent
   ((l2-loss plane) p-xs p-ys)
   (list (tensor 0.0 0.0) 0.0)))
