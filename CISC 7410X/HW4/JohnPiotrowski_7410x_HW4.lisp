;John Piotrowski - 7410x - HW4
;8.1-8.60

;;;8.1
(defun anyoddp (x)
  (cond ((null x) nil)
        ((oddp (first x)) t)
        (t (anyoddp (rest x)))))


;; CL-USER> (trace anyoddp)
;; (ANYODDP)
;; CL-USER> (anyoddp '(3142 5798
;;                     6550 8914))
;; 0: (ANYODDP (3142 5798 6550 8914))
;; 1: (ANYODDP (5798 6550 8914))
;; 2: (ANYODDP (6550 8914))
;; 3: (ANYODDP (8914))
;; 4: (ANYODDP NIL)
;; 4: ANYODDP returned NIL
;; 3: ANYODDP returned NIL
;; 2: ANYODDP returned NIL
;; 1: ANYODDP returned NIL
;; 0: ANYODDP returned NIL
;; NIL

;;;8.2
(defun anyoddp-if (x)
  (if (null x) nil
      (if (oddp (first x)) t (anyoddp (rest x)))))

;;;8.3. (FACT 20.0) produces a different result than (FACT 20) because FACT 20.0 uses floating point calculations while FACT 20 uses bignum calculations which have much higher precision (limited only by total memory available). FACT 0 and FACT 0.0 produce the same result because they hit the first zerop condition which returns 1.

(defun fact (n)
  (cond ((zerop n) 1)
        (t (* n (fact (- n 1))))))

;; CL-USER> (FACT 20)
;; 2432902008176640000
;; CL-USER> (FACT 20.0)
;; 2.432902e18
;; CL-USER> (FACT 0.0)
;; 1
;; CL-USER> (FACT 0)
;; 1

;;;8.4
(defun laugh (num)
  (cond ((zerop num) ())
        (t (cons 'ha (laugh (- num 1)))))
  )

;; CL-USER> (trace laugh)
;; (LAUGH)
;; CL-USER> (laugh 3)
;; 0: (LAUGH 3)
;; 1: (LAUGH 2)
;; 2: (LAUGH 1)
;; 3: (LAUGH 0)
;; 3: LAUGH returned NIL
;; 2: LAUGH returned (HA)
;; 1: LAUGH returned (HA HA)
;; 0: LAUGH returned (HA HA HA)
;; (HA HA HA)

;; CL-USER> (laugh 0)
;; NIL  

;; (laugh -1) produces an infinite loop because we don't have error handling for if num is a negative number.


;;;8.5
;;8.5a. We stop when there is an empty list. Having an empty list would return a sum value of 0.

;;8.5b. The single step should be adding the first element of the list to the add-up of the rest of the list.

;;8.5c. 
(defun add-up (num_list)
  (cond ((null num_list) 0)
        (t (+ (first num_list) (add-up (rest num_list))))
        )
  )

;;;8.6
(defun alloddp (num_list)
  (cond ((null num_list) t)
        ((evenp (first num_list)) nil)
        (t (alloddp (rest num_list)))
        )
  )

;;;8.7
(defun rec-member (element my_list)
  (cond ((null my_list) nil)
        ((equal (first my_list) element) my_list)
        (t (rec-member element (rest my_list))))
  )

;;;8.8
(defun rec-assoc (key table)
  (cond ((null table) nil)
        ((equal key (first (first table))) (first table))
        (t (rec-assoc key (rest table)))
  ))

;;;8.9
(defun rec-nth (n my_list)
  (cond ((zerop n) (first my_list))
        (t (rec-nth (- n 1) (rest my_list))))
        )

;;;8.10
(defun add1 (num)
  (+ num 1)
  )

(defun sub1 (num)
  (- num 1)
  )

(defun rec-plus (x y)
  (cond ((zerop y) x)
        (t (rec-plus (add1 x) (sub1 y))))
  )

;;;8.11
(defun fib (x)
  (cond ((equal x 0) 1)
        ((equal x 1) 1)
        (t (+ (fib (- x 1))
              (fib (- x 2))))
        )
  )

;;;8.12.
;; CL-USER> (any-7-p '(1 2 3 4 7))
;; T
;; CL-USER> (any-7-p '(1 2 3 4)) - any list without 7 will recurse indefinitely.

(defun any-7-p (x)
  (cond ((equal (first x) 7) t)
        (t (any-7-p (rest x)))))

;;;8.13. Any input that is a negative number will cause FACT to recurse indefinitely as it doesn't have any handling for negative numbers.

;;;8.14.
(defun inf-rec-add (x)
  (+ 1 (inf-rec-add x))
  )

;;;8.15. The CAR is x. The CDR points to the list itself. COUNT-SLICES will recurse indefinitely as the list keeps pointing to itself with no stop condition.

;;;8.16. This below works very similarly to anyoddp except when there is an empty list. This function returns a TYPE error when that happens instead of a NIL.
(defun anyoddp-alt (x)
  (cond ((oddp (first x)) t)
        ((null x) nil)
        (t (anyoddp (rest x)))
        ))

;;;8.17
(defun find-first-odd (x)
  (cond ((null x) nil)
        ((oddp (first x)) (first x))
        (t (find-first-odd (rest x)))))

;;;8.18.
(defun last-element (my_list)
  (cond ((atom (cdr my_list)) (car my_list))
        (t (last-element (rest my_list))))
  )

;;;8.19. Without the COND clause with the NULL text, ANYODDP will still work correctly when there is a list containing one or more odd numbers. However, it won't work if the list doesn't contain any odd numbers it will return an error.

;;;8.20. FACT uses single test tail augmenting recursion.
;; Func: fact
;; End-test: (zerop n)
;; End-value: 1
;; Aug-fun: *
;; Aug-val: n
;; Reduced-x: (- n 1)

;;8.21.
(defun add-nums (n)
  (cond ((zerop n) 0)
        (t (+ n (add-nums (- n 1)))))
  )

;;;8.22. This does not require augmentation. This is solved via double-test tail recursion. 
(defun all-equal (my_list)
  (cond ((< (length my_list) 2) t)
        ((not (equal (first my_list) (second my_list))) nil)
        (t (all-equal (rest my_list)))
        )
  )

;;;8.23.
  ;;CL-USER> (laugh 5)
  ;; 0: (LAUGH 5) - first input = 5, second input  = (LAUGH 4)
  ;;   1: (LAUGH 4) - first input = 4, second input  = (LAUGH 3)
  ;;     2: (LAUGH 3) - first input = 3, second input  = (LAUGH 2)
  ;;       3: (LAUGH 2) - first input = 2, second input  = (LAUGH 1)
  ;;         4: (LAUGH 1) - first input = 1, second input  = (LAUGH 0)
  ;;           5: (LAUGH 0)
  ;;           5: LAUGH returned NIL
  ;;         4: LAUGH returned (HA)
  ;;       3: LAUGH returned (HA HA)
  ;;     2: LAUGH returned (HA HA HA)
  ;;   1: LAUGH returned (HA HA HA HA)
  ;; 0: LAUGH returned (HA HA HA HA HA)
  ;;(HA HA HA HA HA)

;;;8.24
(defun count-down (n)
  (cond ((zerop n) nil)
        (t (cons n (count-down (- n 1))))
        )
  )

;;;8.25
(defun fact-red (n)
  (reduce #'* (count-down n))
  )

;;;8.26
(defun count-down-var1 (n)
  (cond ((equal n -1) nil)
        (t (cons n (count-down (- n 1))))
        )
  )

(defun count-down-var2 (n)
  (cond ((minusp n) nil)
        (t (cons n (count-down (- n 1))))
        )
  )

;;;8.27

   
