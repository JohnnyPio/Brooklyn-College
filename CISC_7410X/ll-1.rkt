#lang racket

;; make sure you have malt installed MAchine learning toolkit
;; from the command line  after installing racket
;; raco pkg install malt
(require malt)
(require plot)

;;using (define)
(define pi 3.14)
pi

(define x 100)
x

;; functions are created using lambda keyword

(define add (lambda (x y) (+ x y)))

;; you can pass values to the function if it's not named
((lambda (x y) (+ x y)) 99 101)
(add 99 101)


;; you can named the function using (define )
(define area-of-circle
  (lambda (radius)
    (* pi (* radius radius))))

(area-of-circle 1)
(area-of-circle 10)

;; functions are values and can be used just like any other value
(+ (area-of-circle 1) 100)

;; functions can also resolve to values that are also functions
(define area-of-rectangle
  (lambda (width)
    (lambda (height)
      (* width height))))

(area-of-rectangle 5)

((lambda (height)
  (* 1.3 height)) 4)

;; area-of-rectangle returns a function that remembers the formal that
;; was passed to the context when it was created. This call returns
;; a function that remembers 3 as it's width. so the value is
;; (lambda (height) (* 3 height))
(area-of-rectangle 3)

;; (area-of-rectangle 3) returns a function that takes a single formal.
((area-of-rectangle 3) 9)


;; functions can take functions as formals and return functions that
;; use those functions :)

(define add3
  (lambda (x)
    (+ 3 x)))


(define double-the-result
  (lambda (apply-f-to)
    (lambda (z)
      (* 2 (apply-f-to z)))))

(add3 4)



n;;this returns a function/procedure that we can pass formals to
(double-the-result add3)

;; =>    (lambda (z)
;;       (* 2 (add3 z)))))

;; we can pass a value
((double-the-result add3) 10)
;;we can name it
(define dd (double-the-result add3))
;; we can use the named function in the same way.
(dd 10)

;; in scheme cond uses else instead of t for it's default
;; (define pie 4)
;; (define pie 2)
(define pie 100)

(cond
  ((= pie 4) 28)
  ((< pie 4) 33)
  (else 17))

;; let we know 
((lambda (x)
  (let ((x-is-negative (< x 0)))
    (cond
      (x-is-negative (- x))
      (else x)))) -2)

;; there are no loops in scheme only recursion
;; example remainder function
;; when we divide we count how many times one number can fit in
;; another number, whatever is left over is the remainder
;; we divide the dividend by the divisor

(define remainder
  (lambda (dividend divisor)
    (cond
      ((< dividend divisor) dividend)
      (else (remainder (- dividend divisor) divisor)))))

(remainder 10 3)
(remainder 13 4)

#|
same-as-table
1. (remainder 13 4)
2. (remainder (- 13 4) 4)
3. (remainder 9 4)
4. (remainder (- 9 4) 4)
5. (remainder 5 4)
6. (remainder (- 5 4) 4)
7. (remainder 1 4)
8. 1
|#



;; CHAPTER 1.  WHAT IS LEARNING ?
;; (require plot)
(plot (list (function (λ (x) (* 2 x)) -100 100)(x-axis) (y-axis)))

#|
- When we draw a 2 dimensional line, we specify
a relationship between the x dimension and the y dimension.  In a line for every x dimension there
is a related y dimension, for all x from (-infiniti to +infiniti)

- we can specify this relationship between x and y
using some extra parameters that form an equation, representing the relationship.

- if y is a multiple of x by a constant factor the line passes thru the origin, we can call this constant factor it's slope and call it w. 
notice in the function that we plotted
(λ (x) (* 2 x))
y is a multiple of x with a constant factor of 2
so in this equation the slope is 2 thus the paramater w = 2.
|#

#|we can lift or drop the line up and down the y axis
by adding another paramater , we can call it be. aka the y intercept. Below we add 3 to the equation y = 2x, to become y = 2x + 3 + 3|#

(plot (list (function (λ (x) (+ (* 2 x) 3 )) -5 5)(x-axis) (y-axis)))

;;we can attempt at a functional defintion of line as follows
;;the outer function named line, takes one argument and returns an inner function that takes 2 arguments w and b, and returns a value for y.

(define line
  (lambda (x)
    (lambda (w b)
      (let ((y (+ (* w x) b)))
        y))))

#| when we call line we are setting a value for x. We are doing this
because ultimately what we are trying to learn is the value for the paramaters w and b. that will make a certain x hit a certain y.

-- we can refine line slightly to make it cleaner, we don't really need the let statement because we can just return the value fo the calculation.
|#

(define line
  (lambda (x)
    (lambda (w b)
      (+ (* w x ) b))))

#| here we set x to 8 with (line 8) which returns the function
(lambda (w b)
(+ (* w 8 ) b))
in this function w and b are used to determine the y corresponding with a given x, this is called a paramaterized function, because we are using paramaters w and b on an argument x to get result y.
|#

;;with argument of x=8 and paramters 4 and 6 we get y of 38

((line 8) 4 6)
;;rememeber we can also give (line 8) a name. which gives us the same results line8 is a paramaterized function.

(define line8 (line 8))
(line8 4 6)

#| we use paramaterized function when what to find the right values for the paramaters. When we are learning we will be given an x and y and try discover the correct values for the paramaters w and b. Once we have the correct paramaters for w and b we will be able to predict a y for any given x.|#

;; for example suppose we define 2 lists. see page 24 of the book and page
;; xxiii for the notaion translation


(define line-xs (tensor 2.0 1.0 4.0 3.0))
(define line-ys (tensor 1.8 1.2 4.2 3.3))
line-xs
line-ys

#| if we graph these corrsponding x and y coordinates
we can estimate a line and see that the y is appoximately (* 1 x) and it
will go thru the origin because x = 0 will be approx y = 0. so our paramaters would be w = 1 and b = 0, now we can predict any y for any given x. our goal will be to write functions that help up learn the correct values for w and b give sets of x's and y's. those functions are a examples of machine learning. |#



#| the parameters w and b are collectively known as the paramater set,
we use theta to represent the paramater set and theta0 for the first paramater w and theta1 for the second parameter, so we can rewrite our line function as follows, theta is a list |#

(define line
  (lambda (x)
    (lambda (theta)
      (+ (* x (ref theta 0))
         (ref theta 1)))))

;; here is an example of having our paramaters as list
((line 7.3) (list 1.0 0.0))


(shape (tensor(tensor (tensor 8) (tensor 9)) (tensor(tensor 4) (tensor 7))))
#|same-as-chart
1. ((line 7.3) (list 1.0 0.0))
2.
((lambda (theta)
        (+ (* (ref theta 0) 7.3) (ref theta 1)))
      (list 1.0 0.0))
3. (+ (* 7.3 (ref (1.0 0.0) 0)) (ref (1.0 0.0) 1))
4. (+ (* 7.3 1.0) 0.0)
5. 7.3

so using the paramater set we learnt previously we can predict that for input 7.3 ouput will be 7.3
|#
 
;; TENSORS

;; natural numbers are positive integers >= 0
5
0
;; real numbers (natural numbers are a subset of real numbers)
7.18
-13.713

;; scalars are another name we use for real numbers
;; is pi => 3.141592653589793 a scalar ?
(define pi 3.141592653589793)
;; we have predicate to tell us wether is is or not?

(scalar? pi)
(scalar? (tensor 2.0 1.0))

#|there are different categories of tensors. we can start with a
tensor-1 that is made up of only scalars|#

;;tensor-1's
(tensor 1.0 2.0 3.0 4.4 pi)
(tensor 2)

;; there are also tensor-2's that is made up of equal length tensor-1's
;;tensor-2's
(tensor (tensor 1.0 2.0) (tensor 3.0 4.0))

;; the tensor-1 elements of a tensor-2 must be all of the same length and all be tensor-1's.
(tensor (tensor 1.0 2.0) (tensor 3.0 4.0 5.0))
(tensor (tensor 1.0 2.0) 2.0 )

;;tensor->m+1 is made up of elements that are tensor-m all of the same length. you can find the length with (tlen t)

(tlen (tensor (tensor 1.0 2.0) (tensor 3.0 4.0))) ;tensor 2
(tlen (tensor 1.0 2.0 3.0 4.0)) ;tensor 1

#| [[[[8]]]] tensor 4 with a single tensor 3 with a single tensor 2 with a single tensor 1 that has a scalar 8,we can consider a scalar a tensor 0|#

(tensor (tensor (tensor (tensor 8))))

;;what is this ? [ [ [5] [6] [7] ] [ [8] [9][10] ] ]
;;can you describe what this is? can you write it in scheme notation?


#| the tensor number is known as it's rank. tensor-1 is rank1 tensor-2 is rank 2, tensor->m+1 is rank m+1, the rank of a tensor tells us how deeply nested it's elements are, the tensor notation in the book uses brackets and the number of brackets on the left tells us the rank
[[2.0 3.0]] -> rank 2 => 2 brackets on the left =>
tensor-2 with a single tensor 1 as an element with 2 tensor 0's (scalars )
as elements |#

;; we can write a recursive function to fine the rank of any tensor
;; we use (tref t i) to get the i'th element from tensor t

(define rank
  (lambda (t)
    (cond ((scalar? t) 0)
          (else (add1 (rank (tref t 0)))))))

(rank (tensor 1.0 2.0 3.0 4.0))
(rank (tensor (tensor (tensor 1 2))(tensor (tensor 1 2))))

#|same as chart for
1. (rank [[[8] [9]] [[4] [7]]] )
2. (add1 (rank [[8] [9]]))
3. (add1 (add1 (rank [8])))
4. (add1 (add1 (add1 (rank 8))))
5. (add1 (add1 (add1 (0))))
6. (add1 (add1 1))
7. (add1 2)
7. 3

;; SHAPE OF A TENSOR
;; in rank we only need to keep looking at the 0th element of t because
all the inneer tensors need to be the same len, that is they all need to have the same number of elements, so the 0th,1st,2nd ..ith tensor elements of any tensor will all have the same number of elements.
The shape of a tensor is a description of the nested elements inside.
ie a tensor-3 may have 2 tensors-2's with 3 tensor-1's  with 5 scalars so the shape would be '(2 3 5)
|#

;; The shape of a tensor is specified by a list of natural numbers
;; ie (list 2 3)

;; shape of [[2.0 3.0]] tensor with rank 2, it's elements are
;; 1 tensor-1 with 2 tensor-0(scalars) that is '(1 2)
(list 1 2)

;; shape of [[1.0 2.0 3.0][2.3 3.2 32.2]] is '(2 3) that is 2 elements
;; with 3 elements

;; what is the rank and shape of [[[5] [6] [7]] [[8] [9][10]]]

;; what is the rank and shape of [9 4 7 8 1] ?

;; the shape of a scalar is '() the empty list nil. because
;; a scalar has no elements.
(list)

;lets define a recursive function to find the shape, we will use
;(tlen t) to find the length of each nested tensor

(define shape
  (lambda (t)
    (cond
      ((scalar? t) '())
      (else (cons (tlen t) (shape (tref t 0)))))))

(rank (tensor 1.0 2.0 3.0 4.0))
(shape (tensor 1.0 2.0 3.0 4.0))

(rank (tensor (tensor 1.0 2.0) (tensor 3.0 4.0)))
(shape (tensor (tensor 1.0 2.0) (tensor 3.0 4.0)))

(rank (tensor (tensor (tensor (tensor 8)))))
(shape (tensor (tensor (tensor (tensor 8)))))

;; notice that number of elements in the shape is equal to the rank


(= (rank (tensor 1.0 2.0 3.0 4.0))
   (len (shape (tensor 1.0 2.0 3.0 4.0))))

(tlen t) ; gets the length of a tensor
(len l) ; gets the len of t a list
(tref t i) ;gets the i'th element of a tensor
(ref l i) ; gets the i'th member of a list

;; ALL ELEMENTS OF A TENSOR-M MUST HAVE THE SAME SHAPE!!

#|we need to alter our version of rank because we want it to
be tail call optimized. If we keep a back log of add1's to very deeply
nested tensors we may very well hit a call stack overflow. We will alter rank to use an accumlator.|#

;;first version-> remember from our same-as table the add1's got very nested

(define rank
  (lambda (t)
    (cond ((scalar? t) 0)
          (else (add1 (rank (tref t 0)))))))


#|same as chart for
1. (rank [[[8] [9]] [[4] [7]]] )
2. (add1 (rank [[8] [9]]))
3. (add1 (add1 (rank [8])))
4. (add1 (add1 (add1 (rank 8))))
5. (add1 (add1 (add1 (0))))
6. (add1 (add1 1))
7. (add1 2)
8. 3

new version uses an accumulator, it is called UNWRAPPED, there
is no build up of recursive calls, every call is unwrapped, this is  allows for the compiler to do tail call optimization, which  converts the recursive functioncalls to behave like a loop under the hood, instead of building up and deeply nesting  the call stack.  |#

(define rank
  (lambda (t)
    (ranked (t 0))))

(define ranked
  (lambda (t acc)
    (cond
      ((scalar? t) acc)
      (else (ranked (tref t 0) (add1 acc))))))

;; ADDING TENSORS
;; add 2 tensors results in 1 tensor, each scalar element gets
;; added to the corresponding one of the same shape

(+ (tensor 2.0)
   (tensor 3.0))

(+ (tensor 5 6 7)
   (tensor 2 0 1))

(+ (tensor (tensor 4 6 7) (tensor 2 0 1))
   (tensor (tensor 1 2 2) (tensor 6 3 1)))

;; ADDING TENSORS USING EXTENDED FUNCTION
;; in general tensors must be the same shape to add them
;; but in malt + is an extened function that cal  also work on arbitrary ;; ranks

(+ 4
   (tensor 1 2 3))

(+ (tensor 6 9 1)
   (tensor (tensor 4 3 8) (tensor 7 4 7)))

;; MULTIPLICATION OF TENSORS
(* (tensor 2) (tensor 3))

(* (tensor 2 3) (tensor 4 6))


(+ (tensor (tensor 3)) (tensor 3 4))
;; extended function *
(* (tensor (tensor 4 6 5) (tensor 6 9 7)) 3)


;; sqrt
(sqrt 9)

(sqrt (tensor 9 16 25))

(sqrt (tensor
       (tensor 49 81 16)
       (tensor 64 25 36)))

;;sqrt decends down to scalar level  and takes the sqrt of each.
;;

;; SUM FUNCTION pages 53,54,55

;; HOMEWORK-> UNDERSTAND EVERYTHING DEEPLY thru page 55, there will
;; be a quiz on everything. Tensors ranks, shapes, tail call optimazation
;; closures(b-substitution), operations on tensors.

;; PAGE 56 -> lecture 2


;; in the last lecture we eyeballed a set of data points to come up with a theta
;; that would produce a well fitted line. 
;; So our goal is, given a vector of x's with predicted y's to create an algorithm that will learn our paramaters set theta for the best fit line. in this case theta-0 is w and theta-1 is b. 

;; we will use the ideas of SUCCESIVE APPRXIMATION to find the well fitted theta.

;; how do we do that ?

;; we start at theta-0 = 0 and theta 1 = 0,  and repeatedly revise @ to bring it closer to the best fit.

;; we apply theta to each x in our set to get a tensor of y's.
;; our function line can be applied to a tensor of x's and given theta list
;; the resulting tensor will be the y'sn

(define line
  (lambda (x)
    (lambda (theta)
      (+ (* x (ref theta 0))
         (ref theta 1)))))

(define xs (tensor 2.0 1.0 4.0 3.0))
(define ys (tensor 1.8 1.2 4.2 3.3))


;; when we apply line to the x's with our starting theta we get back a tensor of y's
;; this is called our PREDICTED y's
((line xs) (list 0.0 0.0))

;; in this case the result (tensor 0.0 0.0 0.0 0.0)is the x axis.

;;  THE LOSS
;; we need to figure out how to adjust theta based on the results.
;; we do this by finding a scalar which we call THE LOSS
;; every time we revise and test theta we determine the lOSS
;; and use the loss to determine our new theta.

;; to determine the loss first  we get a tensor by substracting the  predicted y's from
;; our original target y's set

(- ys ((line xs) (list 0.0 0.0)))

;; the result is a tensor -> (tensor 1.8 1.2 4.2 3.3)
;; that is still a tensor and now we must convet it to a scalar by adding all the
;; elements together using our exteneded sum function from page 54

(sum (- ys ((line xs) (list 0.0 0.0))))

;; we need to normalize prior to summing though because if any of the lements in the loss tensor are negative it will skew the resuls for exampled if the loss tensor is
(tensor 4.0 -3.0 0.0 -4.0 3.0)
;;when we sum it the loss will be 0 THE PERFECT SCORE! but as you can see it's not ;;perfect.

(sum (tensor 4.0 -3.0 0.0 -4.0 3.0))

;; so we sqr it  first

(sum (sqr (tensor 4.0 -3.0 0.0 -4.0 3.0))) ;; this loss seems more accurate.

;; Now we can write our loss function.
(define l2-loss
  (lambda (xs ys)
    (lambda (theta)
      (let ((pred-ys ((line xs) theta)))
        (sum
         (sqr
          (- ys pred-ys)))))))


;; we would like to generalize l2-loss so it works on more than just lines.
;; we want to be able to apply it to any function to find the loss
;;given x's y's and theta, so lets allow us to pass it a function as well

(define l2-loss
  (lambda (line)
    (lambda (xs ys)
      (lambda (theta)
        (let ((pred-ys ((line xs) theta)))
          (sum
           (sqr
            (- ys pred-ys))))))))

;; since line is so specific  lets change the name to target
;; now we have a function to find the loss of any function given
;; a the function, the  x's y's and a theta list

(define l2-loss
  (lambda (target)
    (lambda (xs ys)
      (lambda (theta)
        (let ((pred-ys ((target xs) theta)))
          (sum
           (sqr
            (- ys pred-ys))))))))

;; to use this function on the line function we just call
(l2-loss line) ;; produces an -> expectant function

;; that generates a function that will take 2 tensors x's and y's as arguments
;; this function is  called an expectant function because it EXPECTS a data set as ;;arguments os (l2-loss line)is an expectant function


;; this function alsor returns a function that takes a theta list as an argument
;; this produces an objective function because it takes a theta list as an arugment
;; and produces a scalar which is the loss
((l2-loss line) xs ys) ;; produces an -> objective function which takes a theta list as
;; ana argument

;; the objective function returns a scalar representing the loss
;; which is a  measure of how far we are away from a well fitted line

(((l2-loss line) xs ys) (list 0.0 0.0)) ;; loss is 33.21


;; we can step thru the same-as table 64 and 65 if you like to see the above in action
;; again  ??? DO YOU WANT TO?

;; so our loss is 33.21 for the above theta list
;; how do we revise our theta ?

;; we wil begin revising theta by just revising theta-0 (w->the slope).
;; lets change theta-0 by a tiny amount to see what happens     .0099

(((l2-loss line) xs ys) (list 0.0099 0.0))  ;loss = 32.5892403

;; so our loss went down slightly, what is the change in loss the delta ?

(- (((l2-loss line) xs ys) (list 0.0 0.0))
(((l2-loss line) xs ys) (list 0.0099 0.0))) 

;; by increasing theta-0 by .0099 we  decreased the loss by .62

;; we dont want to keep changing theta-0 by a constant arbitrary number like .0099
;; because it may be too small of a change and take to long.

;; we want to get closer to a loss of 0 with out overshooting it.

;; we will use what we call the RATE OF CHANGE to iteratively determine how we should change, how do we determine the RATE OF CHANGE ?
;; we divide change in loss / chane of theta


;; change in loss
(- (((l2-loss line) xs ys) (list 0.0 0.0))
   (((l2-loss line) xs ys) (list 0.0099 0.0))) ; -.62

;; change in theta .0099


;; RATE OF CHANGE of the objective function -62.63
(/ -.62 .0099)

;; we use the rate of change to determine our next theta
;; this is a fairly large number. 62.63 is a very big rate of change.
;; that means we have to be very careful.
;;; remember we want to move quickly to a well fitted line but not to overshoot it.
;; we can take the whole rate of change apply that as the change to theta. lets'try that.

(((l2-loss line) xs ys) (list 62.63 0.0)) ;; loss is now 113763
;;; holy cow that is much worse than before!!!

;; so to be very careful lets lake 1% of the rate of change and use that
;; we will call the scalare that we multiply against the rate of change to be the ;;LEARNING RATE, so in this case our learning reate is .01 we refer to the learning rate
;;as alpha and it is usullay between 0.0 and 0.01 

(* .01 -62.63)


;; we only used the .0099 to find the rate of change which was -62.63
;; we then multiplied the rate of change by our learning rate of .01 to give us
;; -.6263
;; we need to increate theta-0 so we subtract the value from theta-0 to get a new theta

;; we use our new theta

;;; new theta = old theta - rate of change * learning rate

(((l2-loss line) xs ys) (list (- 0.0 -.6263) 0.0))

;; and our new loss is 5.52
;; notice how much a great improvement in loss we had by going thru this process instead
;; of increments of .0099

;; WE DONT KEEP APPLYING THIS CHANGE TO THETA-0
;; WE FIND THE NEW RATE OF CHANGE FOR THIS PARTICULIAR THETA and THIS PARTICULIAR  ;;LOSS, THE RATE OF CHANGE DEPENDS ON THE CURRENT THETA.

;; HOW DO WE CONTINUE FINDING THE CORRECT RATE OF CHANGE? DO WE KEEP adding .0099 to ;;Current theta ? NO!!!! WE USE GRADIENT DESCENT!!

;;GRADIENT DESCENT PAGE 73
;; we can graph the loss for example by choosing a few  values for the theta 0
;; the slope and calculating the l2-loss for each. we keep theta1 static at 0.0 for this
;; calculation

; if we take a set of theta 0's  -1.0 0.0 1.0 2.0 3.0 we can determine the loss at each ;;theta 0 by pluggin them into our l2-loss function

(((l2-loss line) xs ys) (list -1.0 0.0)) ; 126.21
(((l2-loss line) xs ys) (list  0.0 0.0)) ; 33.21
(((l2-loss line) xs ys) (list 1.0 0.0)) ;.2099
(((l2-loss line) xs ys) (list 2.0 0.0)) ;27.21
(((l2-loss line) xs ys) (list 3.0 0.0)) ;114.21

;; what you notice is that the graph creates a curve whose loss is
;; lowest at the bottom of the curve. we need to roll down the curve
;; to get to the bottom to find the best fit theta-0
;; we can do this by finding the rate of change at each point.
;; THE RATE OF CHANGE IS THE SLOPE OF TANGENT OF THE CURVE AT THAT
;; A POINT. THIS IS WHAT IS CALLED THE GRADIENT.

;; Up until now  we have only been thinking about theta-0 we have kept
;; theta-1 constant. The gradient must take theta-1 into consideration ;; as well, we must analyze the objective function using all of it's ;; parameters.


;;************************************************ DELTA THE DERIVATIVE function***************************************************************
#| Little recap |#

;; 1.Learning: we are trying to figure out an algorithm that will find the best theta paramater for an equation to best fit a data set.
;; 2.Paramterized function: we start with an linear equation
;; 2a we establish a paramterized function for a line. where for each x we can try different theta's to see how close to the given y we come. 

(define line
  (lambda (x)
    (lambda (theta)
      (+ (* x (ref theta 0))
         (ref theta 1)))))

;;3. LOSS:  To find the best theta, we use the ideas of successive approximation.
;; we start with a theta, using our data set, we determine a scalar which we call LOSS.
;; to find the loss at a theta we apply theta to each x in our set to get a set of predicted y's
;; we subtract the predicted y's from the actual y's and square each difference. then add them all
;; together to get the scalar which we call loss. We call the function that does this, the l2-loss function

(define xs (tensor 2.0 1.0 4.0 3.0))
(define ys (tensor 1.8 1.2 4.2 3.3))

(define l2-loss
  (lambda (target)
    (lambda (xs ys)
      (lambda (theta)
        (let ((pred-ys ((target xs) theta)))
          (sum
           (sqr
            (- ys pred-ys))))))))


;; l2-loss:  when we call l2-loss and pass it a function like line, it produces a expectant function
;; that is expecting to get a dataset a list of xs corrsponding y's
;; when we call the expectent function it produces an objective function that takes theta and produces the loss.

;; the scalar LOSS represents how far our predicted y's are from our actual y's, we would like our loss to be 0.
;; which is a perfectly fit line.


;; REVISING THETA: we need to revise theta to reduce loss.

;; RATE OF CHANGE: each theta gives us a LOSS. so if we take 2 theta we can compare CHANGE of LOSS TO THE CHANGE of THETA.
;; that is called the rate of change   CHANGE of LOSS / CHANGE of THETA
;; once we have the rate of change, we apply the learning rate to the rate of change to determine the value that
;; we we should add to the current theta. The learning rate is usuually between 0.00 and 0.01

;; new-theta = old-theta - (rate-of-change * learning rate)

;;GRADIENT DESCENT
;; There is a data set that we can call the theta to loss data set.
;; if we graph it forms a curve, the bottom of the curve is the best fit theta.
;; YOU CAN DETERMINE THE RATE OF CHANGE ALONG THE CURVE at ANY GIVEN POINT BY FINDING
;; THE SLOPE OF THE TANGENT LINE TO THE CURVE AT THAT POINT.
;; THE SLOPE OF THE TANGENT LINE CHANGES, it decreses  as it descends down the curve.
;; when it is at the bottom of the curve the slope will it's minimum value

;; GRADIENT-OF FUNCTION
;; the malt package has a function that will return the slope of the tangent line
;; for each point passed to it.  or given a set a point it will return a list
;; of slopes/gradients for each one. 


;; Example: lets take the square function as an example. x^2
;; if we want to know the slope of the tangent line we can use
;; the gradient of function. the gradient function will return the
;; corrspondig slope for each arg passed to it.
;; so below given the square function the slope of the tangent line to x,y for sqr
;; x = 18, 36
;; x = 12, 24
(gradient-of (lambda (x) (sqr x)) 18)  #| 36.0 |#
(gradient-of (lambda (x) (sqr x)) 12)  #| 24.0 |#

;; usually theta is made up of more than one parameter, so gradient of find the gradient
;; with respect to each parameter
(gradient-of (lambda (x) (sqr x)) (tensor 5.0 3.0)) ;=> (tensor 10.0 6.0)

(gradient-of (lambda (x) (sqr x)) (tensor 5.0 3.0))

;;in our previous example we used theta of (0.0 0.0) using only theta-0, altering slightly by .0099
;;we were able to determine the approx rate of change at 0.0. we were deteriming the slope of the tangent line
;;of l2-loss  objective function that was produced by a given data set

(define xs (tensor 2.0 1.0 4.0 3.0))
(define ys (tensor 1.8 1.2 4.2 3.3))

(define l2-loss
  (lambda (target)
    (lambda (xs ys)
      (lambda (theta)
        (let ((pred-ys ((target xs) theta)))
          (sum
           (sqr
            (- ys pred-ys))))))))

(define objs-func ((l2-loss line) xs ys))

(objs-func '(0.0 0.0)) ;=> 33.21

(obj-func '(0.0099 0.0)) =>32.58 

;; our rate of change (slope of the tangent line)  was (- 32.59 33.21) / .0099 
;; 62.62626262626236 rounded to 62.63

;; we can try with the gradient of function
(gradient-of (lambda (theta) (objs-func theta)) (list 0.0 0.0))

;; we pass the objectvie function to gradient-of with our original theta
;; and we get back the gradient value for each paramter'(-63.0 -21.0)
;; taking the first derivative is a more accurate (gradient-of function)

;; REVISING THETA
;; we need to keep revising theta until we find the optimal one
;; our orignal formula to determin new theta was
;;; new theta = old theta - (rate of change * learning rate)
;; we can apply the gradient-of function repeatedly to determine the rate-of change
;; at each theta and then alter to descend down 
;; the curve.


;; we will use a function we call revise, it is an iteration function
;; that recursively  applies a revision function to theta revs number of times.
;; it is an iteration function. (rememebr no loops in racket)
;; this is tail call optimized.

(define revise
  (lambda (f revs theta)
    (cond
      ((zero? revs) theta)
      (else
       (revise f (sub1 revs) (f theta))))))

;; lets try revise on this revision function
;; this function returns uses map.
;; map applies the function passed to it, on
;; every argument of the list to passed to it.
;; and returns a list of the results.

(define minus-3 (lambda (theta)
                 (map (lambda (p)
                        (- p 3)) theta)))
(minus-3 '(3 6 9))

;'(0 3 6)

;; you can also pass a function that takes more multiple arugments and apply it to multiple lists

(map + '(1 2 3) '(4 5 6))

;; we can use revise to apply minus-3 n number of times
(revise minus-3 5 '(9 12 15))


;; so we need a revision function to pass to revise that we will apply to theta
;; new-theta is equal to  old-theta - (learning rate * gradient-of theta)
;; we call learning rate alpha

;; we need to use the objective function for this prariculiar data set so lets set it to
;; to keep our code a little cleaner

(define obj-func ((l2-loss line) xs ys))

;; we need to apply gradient-of using our objective function to theta
;; and multiply the result * the learning rate for each paramater
;; this is th example with theta-0 and theta-1 both set 0.0

(gradient-of (lambda (theta) (objs-func theta)) (list 0.0 0.0))

;; our revise  iteration function takes 3 args,
;; - a  revsions function
;; - number of revs
;; - a list that the revisions function will be applied to and accum revs number of times. 
;; we will us a let block to define all of these and pass them to revise.

(let ((f (lambda (theta)
           (let ((gs (gradient-of (lambda (theta) (((l2-loss line) xs ys) theta)) theta)))
             (list
              (- (ref theta 0) (* .01 (ref gs 0)))   ;.01 is alpha learning rate
              (- (ref theta 1) (* .01 (ref gs 1))))))))
  (revise f 1000 (list 0.0 0.0))) ;; revision function defined in the let statments


;; reminder of how revise works
(define revise
  (lambda (f revs theta)
    (cond
      ((zero? revs) theta)
      (else
       (revise f (sub1 revs) (f theta))))))



;; gradient descent with 1000 iterations rendered a theta of '(1.0499993623489503 1.8747718457656533e-6) 
;; this operation is known as optimization by gradient descent



;; we need to make a change to our revision function, because it right now it only works on
;; objective functions that take theta's of two parameters. we need to generalize
;; instead of calculating that value of each param individually we
;; can create a new function that MAPS across all params.
             (list
              (- (ref theta 0) (* .01 (ref gs 0)))   
              (- (ref theta 1) (* .01 (ref gs 1))))))))


;; remember gradient-of returns a list of slopes for each paramater in theta
;; and theta is a list of params so we can walk thru each corresponding
;; param and gradient and retrun a list if we use map.


(map (lambda (param gradient)
       (- param (* alpha gradient)))
     theta
     gradients)
 
;; this make our let block more general


  (let ((f (lambda (theta)
           (let ((gs (gradient-of (lambda (theta) (((l2-loss line) xs ys) theta)) theta)))
             (map (lambda (param gradient)
                    (- param (* .01 gradient)))
                  theta
                  gs)))))
  (revise f 1000 (list 0.0 0.0)))

;; we also need to specify alpha and the obj-func so lets create an outer let block
;; to include them and instead of defining gradients and the passing it to map lets
;; just pass it to map


;; this is a complete gradient descent

(define revs 1000)
(define alpha .01) ;; learning rate

(let ((f (lambda (theta)
           (map (lambda (param gradient)
                  (- param (* alpha gradient)))
                theta
                (gradient-of (lambda (theta) (((l2-loss line) xs ys) theta)) theta)))))
  (revise f revs (list 0.0 0.0)))


;; one more iteration we define the objective function in an outter block

(let ((obj ((l2-loss line) xs ys)))
  (let ((f (lambda (theta)
             (map (lambda (param gradient)
                    (- param (* alpha gradient)))
                  theta
                  (gradient-of (lambda (theta) (obj theta)) theta)))))
    (revise f revs (list 0.0 0.0))))



;; and our final gradient decent function
;; the outer function takes the objective function and theta as formals
;; the inner function rnames the theta to big-theta as it descends the
;; and refines itself.
;; we call theta The argument to the revision function big-theta

(define gradient-descent
  (lambda (obj theta)
    (let ((f (lambda (big-theta)
               (map (lambda (param gradient)
                      (- param (* alpha gradient)))
                    big-theta
                    (gradient-of (lambda (big-theta) (obj big-theta)) big-theta)))))
      (revise f revs theta))))

;;; here we call our gradient descent function we call 
(gradient-descent
 ((l2-loss line) xs  ys)
 (list 0.0 0.0))

;; This is our first tool for learning.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HYPER PARAMETERS;;;;;;;;;;;;;;;;;;;;


;; in gradient descent
;; the learning rate(alpha) and the number of revisions(revs) ,both scalars, are known as HYPERPARAMETERS.
;; The value of the hyper params must be chosen with care and consideration as well as experimentation.
;; the book introduces some constructs to enable us to experiment with hyperparams.


;; we can declare hypers like this
(declare-hyper smaller)
(declare-hyper larger)

;; but if we evaluate them they are unset
smaller
larger


;; we can set their values within a (with-hypers block

(with-hypers
  ((smaller 1)
   (larger 2000))
  (+ smaller larger))

;; outside the block they are still unset

smaller
larger


;; this is not like a let experssion because the hypers must be declared outside the block
;; with declare-hyper the following is an error

(with-hypers
  ((me 1)
   (you 2))
   (+ me you))


;; any function used inside a with-hypers block will have access to those hypers, once
;; the block is fully evaluated they become unset. ie

;;we define a function
(define nonsense?
  (lambda (x)
    (= (sub1 x) smaller)))


;; we can use that function in a hyperblock

(with-hypers
  ((smaller 5))
  (nonsense? 6))

;; it returns true? how we didnt pass smaller to nonsense and nonsense was declared outside of
;; with-hypers.. inside with-hypers blocks you have to imaging that the functions being used
;; are defined within the block so they have access to the hypers as if they wre closures.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;::CHAPTER 5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lets make our learning rate and revs into proper hypers

(declare-hyper alpha)
(declare-hyper revs)

;; we can call gradient-descent as we recently did but let's use these hypes in the calle
;; and lets make the call in a with-hypers blocki

;;previously we had defined these as stand alone defs using define.
;; here we define them in the block

;; this call produces the same result, because we are using all the same values
(with-hypers
  ((alpha .01)
   (revs 1000))
  (gradient-descent
   ((l2-loss line) xs  ys)
   (list 0.0 0.0)))

;; remember l2-loss? we pass it line (l2-loss line) because we are trying to find the loss and futher more the rate-of-change for a certain theta of a LINEAR FUNCTION.

;; but l2-loss takes a target as formal. so we can pass another type of function to l2-loss. then use that to
;; produce a differnet objective function to be used in gradient-descent. we can find theta for many differnt
;; kinds of functions.

;; here are some points that make a curve

(define q-xs (tensor -1.0 0.0 1.0 2.0 3.0))
(define q-ys (tensor 2.55 2.1 4.35 10.2 18.25))


;; so we need to fine theta for A NON LINEAR FUNCTION
;; what makes a function linear and non linear

;; linear functions only use scaling and addition on it's arguments.
;; the arguments in line are x and its paramaters are theta
;; line scales x by theta-0 and adds theta-1 to it.


;; lets assume the dataset above is quadratic. meaning it can be predicted by a quadratic function

(define quad
  (lambda (t)
    (lambda (theta)
      (+ (* (ref theta 0) (sqr t)) 
         (+ (* (ref theta 1) t) (ref theta 2))))))

;; a quadratic equation has 3 paramaters in theta and uses the (sqr x) in the first term, because
;; we use (sqr x) this is no longer linear, it uses something ohter than scaling and addition.
;; remember quad is an expectant function that produces and objective function

((quad 3.0) (list 4.5 2.1 7.8))


;; we can take use our definition of a quatderatic equation in l2-loss. and in turn
;; use that in gradient descent.

((l2-loss quad) q-xs q-ys) ;objective function

;; we call gradient descent with our objective function and start theta at 0.0 for all params
(gradient-descent ((l2-loss quad) q-xs q-ys) (list 0.0 0.0 0.0))

;; but we need to decide on the scalar values for our hyperparams
;; we need the learning rate and number of revisions.
;; since our first term is squared, we have to be careful with the size of our learning rate.
;; because our gradients could be very large. Rates of change approach infinity as the angle of the
;; tangent line approaches 90deg, so we will pick .001 as our learning rate.

;; we declared these earlier
;; (declare-hyper alpha)
;; (declare-hyper revs)

(with-hypers
  ((alpha .001)
   (revs 1000))
  (gradient-descent ((l2-loss quad) q-xs q-ys) (list 0.0 0.0 0.0)))


;; wow we just used our tools to find the best params for our quadratic function
;;'(1.4787394427094362 0.9928606519360353 2.0546423148479684) 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLANAR FUNCTIONS-> the dot product


;; A plane can be defined as
;;   y = w₁x₁ + w₂x₂ + b 
;; a dot product takes two vectors
;; lets say an argument  vector
;; and a weights(parameters) vector
;; and does the calculation in the formula above
;; so we can define a plane function to be
;; where the formal t below is tensor that contains
;; x1 and x2
;; and theta-0 is a tensor that contains w1 and w2
;; the paramaters that will scale x1 and x2
;; the dot product given (tensor x1 x2) and (tensor w1 w2)
;; evaluates to  w1x1 + w2x2 from the plane equation above
;; theta-1 is a single scalar that is the bias from above

(define plane
  (lambda (t)
    (lambda (theta)
      (+ (dot-product  (ref theta 0)  t) (ref theta 1))))))


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

;; notice the tensors in our learning set have different shapes
(shape p-xs) ; 6 t-1's with 2 t-0's in each not t-0 is scalars
(shape p-ys) ; 6 t-0's

;; the length of the tensors are the same though and they must be the same
(= (tlen p-xs)(tlen p-ys)) ; this must be true


;; here is our implementation of dot product, but
;; there is one alos included with malt
(define our-dot
  (lambda (w t)
    (sum (* w t))))


(our-dot (tensor 2 3) (tensor 3 4)) ;; our dot
(dot-product (tensor 2 3) (tensor 3 4)) ;; built in


;; above I told you aleady but we need to determine
;; the shape of theta0 and theta1
;; we need theta-0 to be the same shape as p-xs or
;; we will get an error
(dot-product (tensor 2 3) (tensor 3 4 5)) ;; built in

;; we know that p-ys are scalars so our plane function
;; must evaluate to a scalar

;; so theta has different shapes just like our data set does.
;; we can consider every element of theta a tensor.

(with-hypers
  ((revs 1000)
   (alpha .001))
  (gradient-descent
   ((l2-loss plane) p-xs p-ys)
   (list (tensor 0.0 0.0) 0.0)))


;;; RULES
#|
1. In data set (xs ys) both xs and ys must have the same
number of elements but the X shapes may be different from the y shapes.

2. Every paramater theta0 theta1 ... theta-n are tensors
remember even scalars are t-0's

3. theta  is a list of parameters that can have different shapes. 

;; see page 110 frame 40 for wrap up.






