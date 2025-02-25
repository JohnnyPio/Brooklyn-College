;John Piotrowski - 7410x - HW3
;6.1-6.42, 7.1-7.29

;;;6.1. (NTH 4 '(A B C)) is equal to NIL because the 4th CDR of is NIL and the CAR of NIL is NIL.

;;;6.2. The value of (NTH 3 '(A B C . D)) is an error of TYPE-ERROR. The 3rd CDR is equal to D and the CAR of D is an error because D is not a list.

;;;6.3. (LAST '(ROSEBUD)) returns (ROSEBUD)

;;;6.4. (LAST '((A B C))) returns ((A B C)) because there is only 1 top-level list element and the last of that list returns that element.

;;;6.5.
(setf line '(ROSES ARE RED))
;; CL-USER> (reverse line)
;; (RED ARE ROSES)
;; CL-USER> (first (last line))
;; RED
;; CL-USER> (nth 1 line)
;; ARE
;; CL-USER> (reverse (reverse line))
;; (ROSES ARE RED)
;; CL-USER> (append line (list (first line)))
;; (ROSES ARE RED ROSES)
;; CL-USER> (append (last line) line)
;; (RED ROSES ARE RED)
;; CL-USER> (list (first line) (last line))
;; (ROSES (RED))
;; CL-USER> (cons (last line) line)
;; ((RED) ROSES ARE RED)
;; CL-USER> (remove 'are line)
;; (ROSES RED)
;; CL-USER> (append line '(violets are blue))
;; (ROSES ARE RED VIOLETS ARE BLUE)

;;;6.6.
(defun last-element (list)
  (first (last list))
  )

(defun last-element-rev (list)
  (first (reverse list))
  )

(defun last-element-nth-len (list)
  (and list 
  (nth (- (length list) 1) list)))

;;;6.7.
(defun next-to-last-rev (list)
  (second (reverse list))
  )

(defun next-to-last-nth (list)
  (and (rest list)
  (nth (- (length list) 2) list)))

;;;6.8
(defun my-butlast (list)
  (remove (first (reverse list)) list))

;;;6.9
;; It reduces to first.

;;;6.10
(defun palindromep (list)
  (equal (reverse list) list)
  )

;;;6.11
(defun make-palindrome (list)
  (append list (reverse list))
  )

;;;6.12. No member doesn't copy its input as it returns either NIL or  a pointer to the list element(s).

;;;6.13. The result is NIL.

;;;6.14. The result is the set itself.

;;;6.15. 
(defun contains-articlep-inter (sent)
  (not (equal (intersection sent '(the a an)) nil)))
; ^^ Whoops forgot that everything is T besides NIL, didn't need the not and equal but leaving it for now :)

 
(defun contains-articlep-member-or (sent)
  (or (member 'the sent)
      (member 'a sent)
      (member 'an sent)
      ))

;; Yes, you could solve this problem with NOT/AND with 3 clauses using NOT statements.

;;;6.16. The result is the set.

;;;6.17. The result is the set.

;;;6.18.
(defun add-vowels (set)
  (union set '(a e i o u))
  )

;;;6.19. If NIL is the first input, set-difference will return NIL. If NIL is the second input, it will return the first set.

;;;6.20. set-difference copies it's first input, it never needs to copy the second. It copies the first input and removes the elements of that set contained in the second set.

;;;6.21
(defun my-subsetp (x y)
  (not (set-difference x y))
  )

;;;6.22
;; (setf a '(soap water))
;; (SOAP WATER)
;; CL-USER> a
;; (SOAP WATER)
;; CL-USER> (union a '(no soap radio))
;; (RADIO NO SOAP WATER)
;; CL-USER> (intersection a (reverse a))
;; (WATER SOAP)
;; CL-USER> (set-difference a '(stop for water))
;; (SOAP)
;; CL-USER> (set-difference a a)
;; NIL
;; CL-USER> (member 'soap a)
;; (SOAP WATER)
;; CL-USER> (member 'water a)
;; (WATER)
;; CL-USER> (member 'washcloth a)
;; NIL

;;;6.23. LENGTH determines the cardinality of a set.

;;;6.24.
(defun set-equal (set1 set2)
  (and (not (set-difference set1 set2))
       (not (set-difference set1 set2)))
  )

;;;6.25.
(defun proper-subsetp (subset set)
  (if (and (subsetp subset set)
           (set-difference set subset)
           ) t nil))

;;;6.26a
(defun right-side (list)
  (rest (member '-vs- list))
  )

;;;6.26b
(defun left-side (list)
  (reverse  (rest (member '-vs- (reverse list))))
  )

;;;6.26c
(defun count-common (list)
  (length (intersection (left-side list) (right-side list)))
  )

;;;6.26d
(defun compare (list)
  (list (count-common list) 'COMMON 'FEATURES)
  )

;;;6.26e
;; CL-USER> (compare '(small red metal cube -vs- red plastic small cube))
;; (3 COMMON FEATURES)

;;; 6.27. If MEMBER is considered a predicate than ASSOC should be too. While it doesn't return T if the condition is met it does return a true value like MEMBER.

;;;6.28.
;; CL-USER> (assoc 'banana produce)
;; (BANANA . FRUIT)
;; CL-USER> (rassoc 'fruit produce)
;; (APPLE . FRUIT)
;; CL-USER> (assoc 'lettuce produce)
;; (LETTUCE . VEGGIE)
;; CL-USER> (rassoc 'veggie produce)
;; (CELERY . VEGGIE)

;;;6.29. LENGTH returns the number of entries in a table.

;;;6.30
(setf books '((war-and-peace . leo-tolstoy) (angelas-ashes . frank-mccourt) (romeo-and-juliet . william-shakespeare) (catch-22 . joseph-heller) (the-scarlet-letter . nathaniel-hawthorne)))

;;;6.31
(defun who-wrote (name)
  (rest (assoc name books))
  )

;;;6.32. If we do (SETF BOOKS (REVERSE BOOKS)), it will reverse the order of the list of books leaving the WHO-WROTE function unchanged.

;;;6.33. No. WHAT-WROTE could be done using RASSOC and the current table.
;; (defun what-wrote (name)
;;   (first (rassoc name books))
;;   )

;;;6.34.
;; Commenting to avoid compiling errors
;; (setf redesigned-atlas
;;       ’((pennsylvania (pittsburgh johnstown))
;;         (new-jersey (newark princeton trenton))
;;         (ohio (columbus))))

;;;6.35a. A table would be the best way to represent and easily visualize this data.
;;I would usually use setf but it doesn't work within the context of this lisp file, only on the slime-repl sbcl
(setf nerd-states
  '((sleeping   . eating)
    (eating     . waiting)
    (waiting    . programming)
    (programming. debugging)
    (debugging  . sleeping)))

;;;6.35b.
(defun nerdus (state)
  (cdr (assoc state nerd-states))
  )

;;;6.35c. (NERDUS ’PLAYING-GUITAR) => NIL

;;;6.35d.
(defun sleepless-nerd (state)
  (let ((x (nerdus state)))
    (if (equal x 'sleeping)
        (nerdus x)
        x)))

;;;6.35e
(defun nerd-on-caffeine (state)
  (nerdus(nerdus state)))

;;;6.35f. It would go through3 state changes, programming -> sleeping, sleeping -> waiting, then waiting -> debugging.

;;;6.36
(defun swap-first-last (list_in)
  (let* ((a (reverse (rest list_in)))       
         (b (reverse (rest a))))
    (cons (first a)
          (append b (list (first list_in))))))

;;;6.37
(defun rotate-left  (list_in)
  (append (rest list_in) (list (first list_in)))
  )

(defun rotate-right  (list_in)
  (append (last list_in) (reverse (rest (reverse list_in))))
  )

;;;6.38. X=(A B C), Y=(C B A). X=(A B C D), Y=(D C B A). For unequal set differences, the sets must not be the same (e,g. X=(A B C) and Y=(A B))

;;;6.39. APPEND performs unary addition.

;;;6.40.
;; ((A B C D)
;;  (B C D)
;;  (C D)
;;  (D))

;;;6.41.
(setf rooms
             '((living-room (north front-stairs)
                            (south dining-room)
                            (east kitchen))
               (upstairs-bedroom (west library)
                                 (south front-stairs))
               (dining-room (north living-room)
                            (east pantry)
                            (west downstairs-bedroom))
               (kitchen (west living-room)
                        (south pantry))
               (pantry (north kitchen)
                       (west dining-room))
               (downstairs-bedroom (north back-stairs)
                                   (east dining-room))
               (back-stairs (south downstairs-bedroom)
                            (north library))
               (front-stairs (north upstairs-bedroom)
                             (south living-room))
               (library (east upstairs-bedroom)
                        (south back-stairs))))

;;;6.41a
(defun choices (room)
  (rest (assoc room rooms))
  )

;;;6.41b
(defun look (dir room)
  (second (assoc dir (choices room)))
  )

;;;6.41c
(setf loc 'pantry)

(defun set-robbie-location (place)
  "Moves Robbie to PLACE by setting the variable LOC."
  (setf loc place))

;;;6.41d
(defun how-many-choices ()
  (length (choices loc))
  )

;;;6.41e
(defun upstairsp (room)
  (or (equal room 'library)
      (equal room 'upstairs-bedroom)))

(defun onstairsp (room)
  (or (equal room 'front-stairs)
      (equal room 'back-stairs))
  )

;;;6.41f
(defun where ()
  (if (onstairsp loc) (list 'ROBBIE 'IS 'ON 'THE loc)
  (if (upstairsp loc) (list 'ROBBIE 'IS 'UPSTAIRS 'IN 'THE loc)
      (list 'ROBBIE 'IS 'DOWNSTAIRS 'IN 'THE loc))))


;;;6.41g
(defun move (dir)
  (let ((new_loc (look dir loc)))
    (if (not (equal new_loc nil))
        (and (set-robbie-location new_loc) (where))
        '(OUCH! ROBBIE HIT A WALL))))

;;;6.41h
;; CL-USER> loc
;; PANTRY
;; CL-USER> (move 'west)
;; (ROBBIE IS DOWNSTAIRS IN THE DINING-ROOM)
;; CL-USER> (move 'west)
;; (ROBBIE IS DOWNSTAIRS IN THE DOWNSTAIRS-BEDROOM)
;; CL-USER> (move 'north)
;; (ROBBIE IS ON THE BACK-STAIRS)
;; CL-USER> (move 'north)
;; (ROBBIE IS UPSTAIRS IN THE LIBRARY)
;; CL-USER> loc
;; LIBRARY
;; CL-USER> (move 'east)
;; (ROBBIE IS UPSTAIRS IN THE UPSTAIRS-BEDROOM)
;; CL-USER> (move 'south)
;; (ROBBIE IS ON THE FRONT-STAIRS)
;; CL-USER> (move 'south)
;; (ROBBIE IS DOWNSTAIRS IN THE LIVING-ROOM)
;; CL-USER> (move 'east)
;; (ROBBIE IS DOWNSTAIRS IN THE KITCHEN)
;; CL-USER> loc
;; KITCHEN


;;;6.42
(defun royal-we (list)
  (subst 'we 'i list)
  )

;;;;; CHAPTER 7
;;;7.1
(defun add1 (n)
  (+ n 1)
  )

; (mapcar #'add1 '(1 3 5 7 9)) => (2 4 6 8 10)

;;;7.2
(setf daily-planet '((olsen jimmy 123-76-4535 cub-reporter)
                      (kent clark 089-52-6787 reporter)
                      (lane lois 951-26-1438 reporter)
                      (white perry 355-16-7439 editor))
  )

;(mapcar #'third daily-planet) => (|123-76-4535| |089-52-6787| |951-26-1438| |355-16-7439|)         

;;;7.3
; (mapcar #'zerop '(2 0 3 4 0 -5 -6)) => (NIL T NIL NIL T NIL NIL)

;;;7.4
(defun greater-than-five-p (num)
  (> num 5)
  )

; (mapcar #'greater-than-five-p '(2 0 6 4 0 -5 -6)) => (NIL NIL T NIL NIL NIL NIL)

;;;7.5.
(lambda (n) (- n 7))

;;;7.6.
(lambda (x)
  (if (or (equal x t) (equal x nil))
      t nil)
    )

;;;7.7
(defun flips-each (list)
  (mapcar #'(lambda (x)
              (if (equal x 'up) 'down 'up))
          list))

;;;7.8
(defun rough-equal-to (element k)
  (and (not (< element (- k 10)))
       (not (> element (+ k 10))))
  )

(defun find-equal-k (x k)
  (find-if #'(lambda (element) (rough-equal-to element k))
           x))

;;;7.9
(defun find-nested (list)
  (find-if #'listp list))

;;;7.10a.
(setf table-of-notes '((c . 1) (f-sharp . 7)
                               (c-sharp . 2) (g . 8)
                                (d . 3) (g-sharp . 9)
                                (d-sharp . 4) (a . 10)
                                (e . 5) (a-sharp . 11)
                                (f . 6) (b . 12)))

;;;7.10b
(defun convert-note-to-number (note)
  (cdr (assoc note table-of-notes))
  )


(defun numbers (list)
  (mapcar #'convert-note-to-number list))

;;;7.10c
(defun convert-number-to-note (num)
  (car (rassoc num table-of-notes))
  )

(defun notes (list)
  (mapcar #'convert-number-to-note list))

;;;7.10d. Both return a list of NILs.
;; CL-USER> (NOTES (NOTES '(5 3 1 3 5 5 5)))
;; (NIL NIL NIL NIL NIL NIL NIL)
;; CL-USER> (NUMBERS (NUMBERS '(E D C D E E E)))
;; (NIL NIL NIL NIL NIL NIL NIL)

;;;7.10e.
(defun raise (n list)
  (mapcar #'(lambda (x) (+ x n)) list)
  )

;;;7.10f.
(defun normalize (list)
  (mapcar #'(lambda (x) (cond ((> x 12) (- x 12))
                              ((< x 1) (+ x 12))
                              (t x)))
              list))

;;;7.10g.
(defun transpose-song (half-steps song)
  (notes
   (normalize
    (raise half-steps
           (numbers song)
           )
    )
   )
  )

;; CL-USER> (TRANSPOSE-song 11 '(E D C D E E E))
;; (D-SHARP C-SHARP B C-SHARP D-SHARP D-SHARP D-SHARP)
;; CL-USER> (TRANSPOSE-song 12 '(E D C D E E E))
;; (E D C D E E E)
;; CL-USER> (TRANSPOSE-song -1 '(E D C D E E E))
;; (D-SHARP C-SHARP B C-SHARP D-SHARP D-SHARP D-SHARP)

;;;7.11
(defun one-to-five (x)
  (remove-if-not #'(lambda (x)
                     (and (> x 1) (< x 5)))
                 x)
  )

;;;7.12
(defun count-the (list)
  (length
   (remove-if-not #'(lambda (x)
                      (equal x 'the))
                  list)))

;;;7.13
(defun pick-lists-of-twos (list)
  (remove-if-not #'(lambda (x)
                     (equal (length x) 2))
                 list)
  )

;;;7.14
(defun my-union (x y)
     (append x
             (remove-if
              #'(lambda (e)
                  (member e x))
              y)))
  
(defun my-intersection (x y)
  (remove-if-not
   #'(lambda (e)
       (member e y))
   x))

;;;7.15
;;7.15a
(defun rank (card)
  (first card)
  )

(defun suit (card)
  (second card)
  )

;;7.15b
(setf my-hand '((3 hearts)
                 (5 clubs)
                 (2 diamonds)
                 (4 diamonds)
                  (ace spades)))

(defun count-suit (suit hand)
  (length
   (remove-if-not #'(lambda (x)
                (equal (second x) suit))
                  hand))
  )

;;7.15c
(defvar colors '((clubs black)
                 (diamonds red)
                 (hearts red)
                 (spades black)))

(defun color-of (card)
  (second
   (find-if #'(lambda (x)
                (equal (suit card) (first x)))
            colors))
  )

;;7.15d
(defun first-red (hand)
  (find-if #'(lambda (x)
               (equal (color-of x) 'red))
           hand)
  )

;;;7.15e
(defun black-cards (hand)
  (remove-if-not #'(lambda (x)
                     (equal (color-of x) 'black))
                 hand)
  )

;;;7.15f
(defun what-ranks (suit hand)
  (mapcar #' rank
   (remove-if-not #'(lambda (x)
                        (equal (suit x) suit))
                  hand)
   )
  )

;;;7.15g
(defvar all-ranks '(2 3 4 5 6 7 8 9 10 jack queen king ace))

(defun higher-rank-p (c1 c2)
  (if (member c1 (member c2 all-ranks)) t nil)
  )

;;;7.15h
(defun higher-rank (c1 c2)
  (if (higher-rank-p c1 c2) c1 c2)
  )

(defun high-card (hand)
  (reduce #'higher-rank hand)
  )

;;;7.16. We should use UNION instead of APPEND.

;;;7.17.
(defun len-list-of-lists (list)
  (length(reduce #'append list))
  )

;;;7.18. The identity value for addition is 0 - any number +0 is that number. For multiplication the identity value is 1 - any number *1 is that number.

;;;7.19
(defun all-odd (list)
  (every #'oddp list)
  )

;;;7.20
(defun none-odd (list)
  (every #'evenp list)
  )

;;;7.21
(defun not-all-odd (list)
  (find-if #'evenp list)
  )

;;;7.22
(defun not-none-odd (list)
  (find-if #'oddp list)
  )

;;;7.23. Yes, all 4 functions are distinct from one another. not-all-odd should be called find-even and not-none-odd should be called find-odd.

;;;7.24. An applicative operator is a function that takes another function as an argument, and then applies that higher-order function to data.

;;;7.25. Lambda expressions are useful when we don't want to define a function only within the context of another function - mostly for one-time use. We can do without them but need to define a function every time using DEFUN, even when only being used once within the context of a parent function. We would not be able to utilize the helpful feature that lambdas expressions can refer to local variables in the parent function.

;;;7.26
(defun my-find-if (pred my_list)
  (first (remove-if-not pred my_list))
  )

;;;7.27
(defun my-every (pred my_list)
  (not (remove-if pred my_list)))

;;;7.28

;;   □ □ □ □
;;   ?  ?  ?  ? -> ○

;;;7.29
(defvar database
      '((b1 shape brick)
        (b1 color green)
        (b1 size small)
        (b1 supported-by b2)
        (b1 supported-by b3)
        (b2 shape brick)
        (b2 color red)
        (b2 size small)
        (b2 supports b1)
        (b2 left-of b3)
        (b3 shape brick)
        (b3 color red)
        (b3 size small)
        (b3 supports b1)
        (b3 right-of b2)
        (b4 shape pyramid)
        (b4 color blue)
        (b4 size large)
        (b4 supported-by b5)
        (b5 shape cube)
        (b5 color green)
        (b5 size large)
        (b5 supports b4)
        (b6 shape brick)
        (b6 color purple)
        (b6 size large)))

;;7.29a
(defun match-element (s1 s2)
  (if (or (equal s1 s2) (equal s2 '?)) t nil)
  )

;;7.29b
(defun match-triple (asrt pat)
  (if (and (match-element (first asrt) (first pat))
           (match-element (second asrt) (second pat))
           (match-element (third asrt) (third pat)))
      t nil)
  )

;;;7.29c
(defun fetch (pat)
  (remove-if-not #'(lambda (x)
                     (match-triple x pat))
                 database))

;;;7.29d
;; CL-USER> (FETCH '(B4 SHAPE ?))
;; ((B4 SHAPE PYRAMID))
;; CL-USER> (FETCH '(? SHAPE BRICK))
;; ((B1 SHAPE BRICK) (B2 SHAPE BRICK) (B3 SHAPE BRICK) (B6 SHAPE BRICK))
;; CL-USER> (FETCH '(B2 ? B3))
;; ((B2 LEFT-OF B3))
;; CL-USER> (FETCH '(? COLOR ?))
;; ((B1 COLOR GREEN) (B2 COLOR RED) (B3 COLOR RED) (B4 COLOR BLUE)
;;                   (B5 COLOR GREEN) (B6 COLOR PURPLE))
;; CL-USER> (FETCH '(B4 ? ?))
;; ((B4 SHAPE PYRAMID) (B4 COLOR BLUE) (B4 SIZE LARGE) (B4 SUPPORTED-BY B5))

;;;7.29e
(defun color-pattern-ask (block)
  (list block 'color '?)
  )

;;;7.29f
(defun supporters (block)
  (mapcar #'first
          (fetch (list '? 'supports block)))
  )

;;;7.29g
(defun supp-cube (block)
  (let ((supps (supporters block)))
    (remove-if-not #'(lambda (x)
                       (fetch (list x 'shape 'cube)))
                   supps)
  ))

;;;7.29h
(defun desc1 (block)
  (fetch (list block '? '?))
  )

;;;7.29i
(defun desc2 (block)
  (mapcar #'(lambda (x)
             (rest x))
          (desc1 block)
          )
  )

;;;7.29j
(defun description (block)
  (reduce #'append (desc2 block)))

;;;7.29k
;; CL-USER> (DESCRIPTION 'B1)
;; (SHAPE BRICK COLOR GREEN SIZE SMALL SUPPORTED-BY B2 SUPPORTED-BY B3)
;; CL-USER> (DESCRIPTION 'B4)
;; (SHAPE PYRAMID COLOR BLUE SIZE LARGE SUPPORTED-BY B5)

;;;7.29l. I would add these two lists to the database (B1 MATERIAL WOOD) (B2 MATERIAL PLASTIC).

  
