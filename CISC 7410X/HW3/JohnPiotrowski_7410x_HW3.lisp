;John Piotrowski - 7410x - HW3
;6.1-6.42, 7.1-7.29

;;;6.1. (NTH 4 '(A B C)) is equal to NIL because the 4th CDR of is NIL and the CAR of NIL is NIL.

;;;6.2. The value of (NTH 3 '(A B C . D)) is an error of TYPE-ERROR. The 3rd CDR is equal to D and the CAR of D is an error because D is not a list.

;;;6.3. (LAST '(ROSEBUD)) returns (ROSEBUD)

;;;6.4. (LAST '((A B C))) returns ((A B C)) because there is only 1 top-level list element and the last of that list returns that element.

;;;6.5.
;(setf line '(ROSES ARE RED))
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
;;I would usually use setf but it doesn't work within the context of this lisp file, only on the slime-repl sbcl
(defvar books '((war-and-peace . leo-tolstoy) (angelas-ashes . frank-mccourt) (romeo-and-juliet . william-shakespeare) (catch-22 . joseph-heller) (the-scarlet-letter . nathaniel-hawthorne)))

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

;;;7.10d
