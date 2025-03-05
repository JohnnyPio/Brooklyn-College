(defstruct name 
  First
  Middle
  Last
  (yr 2015))

(defvar x (make-name :first 'john :last 'piotrowski))

(intersection '(a b c) '(a b c d e))

;; (eq '(1 2 3) '(1 2 3)) => nil
;; (equal '(1 2 3) '(1 2 3)) => t
;; (eql '(1 2 3) '(1 2 3)) => nil

(equal "Joe" "Joe")
(equalp "Joe" "Joe")
(= 4 12/3)

;How do we executive functions?
;;; funcall                 
;;; apply
;;; #' is a shorthand for the function call (Function). Gets the function from the function cell of the symbol.

(funcall #'+ 1 2 3 4 5)

(defvar name 10 "docstring") ;;best for when var will change
(defparameter name 12 "docstring") ;;var won't change
;;;always use *name* "earmuffs" to declare it a global variable - for convention

;;;both defs declare it then set it, setf only sets it

(defvar *gl* 10)

(defun fnc ()
  (+ 1 *gl*)
  )

(fnc)

(let ((*gl* 10000))
  (fnc))

;;;let and let* - evaluate AND then bind those values to the variables AND then evaluate
(let ((x 10) (y (+ 1 5))))

;;push and pop are built into lists, treat your lists like a stack, which does have side effects
(setf lst (cons (x lst)))

(defvar my_list '(1 2 3))

(push '4 (my_list))

;;;(incf x 1) x++
;;;(decf x 1)

;;;lambda functions and lexical closures
;; lets are similar to lambdas
(let ((x 40) (y (+ 1 1))) (+ x y)) => 42

((lambda (x y) (+ x y)) 40 (+ 1 1)) => 42

;;When lambda is created and passed into a HOF, it retains variables it had access to at the time it was created.

(defun adder (c) #'(lambda (x) (+ x c)))

(defvar add2 (adder 2))

(funcall add2 3) => 5

;;;;;;

(defun make-counter (initval)
  (let ((count initval))
    (lambda () incf count))
  )

(defvar *c1* (make-counter 0))

(funcall *c1*) => 1


;;;;;;


