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
(defun square-list (my_list)
  (cond ((null my_list) nil)
        (t (cons (* (first my_list) (first my_list)) (square-list (rest my_list))))
        )
  )

;;;8.28
(defun my-nth (n x)
  (cond ((null x) nil)
        (t (my-nth (- n 1) (rest x)))))

;;;8.29
(defun my-member (e my_list)
  (cond ((null my_list) nil)
        ((equal e (first my_list)) my_list)
        (t (my-member e (rest my_list)))
        )
  )

;;;8.30
(defun my-assoc (key table)
  (cond ((null table) nil)
        ((equal key (first (first table))) (first table))
        (t (my-assoc key (rest table))))
  )

;;;8.31
(defun compare-lengths (l1 l2)
  (cond ((and (null l1) (null l2) 'same-length))
        ((null l2) 'first-is-longer)
        ((null l1) 'second-is-longer)
        (t (compare-lengths (rest l1) (rest l2))))
  )

;;;8.32
(defun sum-numeric-elements (my_list)
  (cond ((null my_list) 0)
        ((numberp (first my_list)) (+ (first my_list) (sum-numeric-elements (rest my_list))))
        (t (sum-numeric-elements (rest my_list))))
  )

;;;8.33
(defun my-remove (e my_list)
  (cond ((null my_list) nil)
        ((equal e (first my_list)) (my-remove e (rest my_list)))
        (t (cons (first my_list) (my-remove e (rest my_list))))
        ))

;;;8.34
(defun my-intersection (s1 s2)
  (cond ((null s1) nil)
        ((member (first s1) s2)
         (cons (first s1) (my-intersection (rest s1) s2)))
        (t (my-intersection (rest s1) s2))
        )
  )

;;;8.35
(defun my-set-difference (s1 s2)
  (cond ((null s1) nil)
        ((not (member (first s1) s2))
         (cons (first s1) (my-set-difference (rest s1) s2)))
        (t (my-set-difference (rest s1) s2))
        )
  )

;;;8.36
(defun count-odd-cond-aug (my_list)
  (cond ((null my_list) 0)
        ((oddp (first my_list)) (+ 1 (count-odd-cond-aug (rest my_list))))
        (t (count-odd-cond-aug (rest my_list)))))

(defun count-odd-reg-aug (my_list)
  (cond ((null my_list) nil)
        (t (+ (if (oddp (first my_list)) 1 0)
              (count-odd-reg-aug (rest my_list))))))

;;;8.37
(defun combine (n1 n2)
  (+ n1 n2)
  )

(defun fib-with-combine (x)
  (cond ((equal x 0) 1)
        ((equal x 1) 1)
        (t (combine (fib (- x 1)) (fib (- x 2))))
        ))

;; CL-USER> (fib 4)
;; 0: (FIB 4)
;; 1: (FIB 3)
;; 2: (FIB 2)
;; 3: (FIB 1)
;; 3: FIB returned 1
;; 3: (FIB 0)
;; 3: FIB returned 1
;; 2: FIB returned 2
;; 2: (FIB 1)
;; 2: FIB returned 1
;; 1: FIB returned 3
;; 1: (FIB 2)
;; 2: (FIB 1)
;; 2: FIB returned 1
;; 2: (FIB 0)
;; 2: FIB returned 1
;; 1: FIB returned 2
;; 0: FIB returned 5
;; 5

;; Every nonterminal call to FIB makes a single call to COMBINE. Every call to COMBINE combines the results of two FIB calls.

;;;8.38. It appends an extra ". q" to the end of every list because the NILs convert to Qs.
(defun atoms-to-q (x)
  (cond ((null x) nil)
    ((atom x) 'q)
        (t (cons (atoms-to-q (car x))
                 (atoms-to-q (cdr x))))))

;;;8.39
(defun count-atoms (tree)
  (cond ((atom tree) 1)
        (t (+ (count-atoms (car tree)) (count-atoms (cdr tree)))))
  )

;;;8.40
(defun count-cons (tree)
  (cond ((atom tree) 0)
        (t (+ 1 (count-cons (car tree)) (count-cons (cdr tree)))))
  )

;;;8.41
(defun sum-tree (tree)
  (cond ((numberp tree) tree)
        ((atom tree) 0)
        (t (+ (sum-tree (first tree)) (sum-tree (rest tree)))))
  )

;;;8.42
(defun my-subst (x y tree)
  (cond ((equal tree x) y)
        ((atom tree) tree)
        (t (cons (my-subst x y (first tree)) (my-subst x y (rest tree)))))
  )

;;;8.43
(defun flatten (n_list)
  (cond ((null n_list) nil)
        ((atom n_list) (list n_list))
        (t (append (flatten (first n_list)) (flatten (rest n_list)))))
  )

;;;8.44
(defun tree-depth (tree)
  (cond ((atom tree) 0)
        (t (+ 1 (max (tree-depth (car tree))
                     (tree-depth (cdr tree)))))
        )
  )

;;;8.45
(defun paren-depth (tree)
  (cond ((atom tree) 0)
        (t (max (+ 1 (paren-depth (car tree)))
                (paren-depth (cdr tree))))
        )
  )

;;;8.46
(defun count-up (n)
  (cond ((zerop n) nil)
        (t (append (count-up (- n 1)) (list n))))
  )

;;;8.47
(defun make-loaf (n)
  (if (zerop n) nil
      (append (make-loaf (- n 1)) (list 'X)))
  )

;;;8.48. Single-test augmenting.
(defun bury (item n)
  (cond ((zerop n) nil)
        (t (list (bury item (- n 1)))))
  )

;;;8.49
(defun pairings (l1 l2)
  (cond ((null l1) nil)
        (t (cons (list (first l1) (first l2)) (pairings (rest l1) (rest l2))))
        )
  )

;;;8.50
(defun sublists (my_list)
  (cond ((null my_list) nil)
        (t (cons my_list (sublists (rest my_list))))
        )
  )

;;;8.51
(defun my-reverse (my_list)
  (my-reverse-recursive my_list nil)
  )

(defun my-reverse-recursive (my_list e)
  (cond ((null my_list) e)
        (t (my-reverse-recursive (rest my_list) (cons (first my_list) e)))
        )
  )

;;;8.52
(defun my-union (s1 s2)
  (append s1 (my-union-rec s1 s2))
  )

(defun my-union-rec (s1 s2)
  (cond ((null s2) nil)
        ((member (first s2) s1) (my-union-rec s1 (rest s2)))
        (t (cons (first s2) (my-union-rec s1 (rest s2))))
        )
  )

;;;8.53
(defun largest-even (my_list)
  (cond ((null my_list) 0)
        ((oddp (first my_list)) (largest-even (rest my_list)))
        (t (max (first my_list) (largest-even (rest my_list)))))
  )

;;;8.54
(defun huge (n)
  (huge-rec n 0)
  )

(defun huge-rec (n cnt)
  (cond ((equal cnt n) 1)
        (t (* n (huge-rec n (+ cnt 1)))))
  )

;;;8.55. A recursive function calls itself as an argument.

;;;8.56.
(defun every-other (my_list)
  (every-other-rec my_list 0)
  )

(defun every-other-rec (my_list cnt)
  (cond ((null my_list) nil)
        ((oddp cnt) (every-other-rec (rest my_list) (+ cnt 1)))
        (t (cons (first my_list) (every-other-rec (rest my_list) (+ cnt 1))))
        )
  )

;;;8.57
(defun left-half (my_list)
  (left-half-help my_list 0))


(defun left-half-help (my_list cnt)
  (cond ((null my_list) nil)
        ((< (ceiling (/ (length my_list) 2)) cnt) (left-half-help (rest my_list) (+ cnt 1)))
        (t (cons (first my_list) (left-half-help (rest my_list) (+ cnt 1)))))
  )

;;;8.58
(defun merge-lists (l1 l2)
  (cond ((null l2) l1)
        ((null l1) l2)
        ((> (first l2) (first l1)) (cons (first l1) (merge-lists (rest l1) l2)))
        (t (cons (first l2) (merge-lists l1 (rest l2))))
        )
  )

;;;8.59. Both equations are true. This definition is recursive but would cause an infinite loop for any inputs greater than zero because each call would be + 1 to the input indefinitely. It violates the first rule of recursion because there is no stopping point.

;; CL-USER> (fact 0)
;; 1
;; CL-USER> (/ (fact 6) 6)
;; 120
;; CL-USER> (fact 5)
;; 120

(defun fact-bad (n)
  (cond ((zerop n) 1)
        (t (/ (fact (+ n 1)) (+ n 1)))
        )
  )

;;;8.60.
(defvar family
      '((colin nil nil)
        (deirdre nil nil)
        (arthur nil nil)
        (kate nil nil)
        (frank nil nil)
        (linda nil nil)
        (suzanne colin deirdre)
        (bruce arthur kate)
        (charles arthur kate)
        (david arthur kate)
        (ellen arthur kate)
        (george frank linda)
        (hillary frank linda)
        (andre nil nil)
        (tamara bruce suzanne)
        (vincent bruce suzanne)
        (wanda nil nil)
        (ivan george ellen)
        (julie george ellen)
        (marie george ellen)
        (nigel andre hillary)
        (frederick nil tamara)
        (zelda vincent wanda)
        (joshua ivan wanda)
        (quentin nil nil)
        (robert quentin julie)
        (olivia nigel marie)
        (peter nigel marie)
        (erica nil nil)
        (yvette robert zelda)
        (diane peter erica)))

;;; 8.60a.                                  
(defun father (name)
  (second (assoc name family))
  )

(defun mother (name)
  (third (assoc name family))
  )

(defun parents (name)
  (remove nil (rest (assoc name family)))
  )

(defun children (name)
  (mapcar #'first (remove-if-not #'(lambda (x) (member name (rest x)))
                  family))
  )

;;;8.60b.
(defun siblings (name)
  (remove name (union (children (father name)) (children (mother name)))))

;;;8.60c.
(defun mapunion (fn my_list)
  (reduce #'union (mapcar fn my_list)
   )
  )

;;;8.60d
(defun grandparents (name)
  (mapunion #'parents (parents name))
  )

;;;8.60e
(defun cousins (name)
  (mapunion #'children (mapunion #'siblings (parents name)))
  )

;;;8.60f
(defun descended-from (person ancestor)
  (cond ((null person) nil)
        ((member ancestor (parents person)) t)
        (t (or (descended-from (mother person) ancestor)
               (descended-from (father person) ancestor))))
  )

;;;8.60g
(defun ancestors (person)
  (cond ((null person) nil)
        (t (union (parents person) (union (ancestors (mother person)) (ancestors (father person))))))
  )

;;;8.60
(defun generation-gap (person ancestor)
  (generation-gap-helper person ancestor 0))
 
(defun generation-gap-helper (person ancestor cnt)
  (cond ((null person) nil)
        ((equal person ancestor) cnt)
        (t (or (generation-gap-helper (father person) ancestor (+ cnt 1))
               (generation-gap-helper (mother person) ancestor (+ cnt 1))))
        )
  )

;;;8.60i.
;;;8.60i.1) No.
;; CL-USER> (GENERATION-GAP 'robert 'deirdre)
;; NIL

;;;8.60i.2)
;; CL-USER> (ancestors 'yvette)
;; (JULIE QUENTIN ELLEN GEORGE ARTHUR KATE LINDA FRANK DEIRDRE COLIN BRUCE SUZANNE
;;        VINCENT WANDA ROBERT ZELDA)

;;;8.60i.3)
;; CL-USER> (GENERATION-GAP 'olivia 'frank)
;; 3

;;;8.60i.4)
;; CL-USER> (cousins 'peter)
;; (ROBERT JOSHUA)

;;;8.60i.5)
;; CL-USER> (grandparents 'olivia)
;; (HILLARY ANDRE GEORGE ELLEN)

