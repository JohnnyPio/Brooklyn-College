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
