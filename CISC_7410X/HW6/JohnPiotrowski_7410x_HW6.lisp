;;John Piotrowski - 7410x - HW6
;;GPS v2

;; Order

;;Top-Level Function
(defun GPS (state goals &optional (*ops* *ops*))
  "General Problem Solver: from state, achieve goals using *ops*."
  (remove-if #'atom (achieve-all (cons '(start) state) goals nil)))

(defun GPS_bound (state goals &optional (ops *ops*))
  "General Problem Solver: from state, achieve goals using *ops*."
  (let ((old-ops *ops*))
    (setf *ops* ops)
    (let ((result (remove-if #'atom (achieve-all
                                     (cons '(start) state)
                                     goals nil))))
      (setf *ops* old-ops)
      result)))


;;Special Variables
(defvar *ops* nil  "A list of available operators.")


;;Data Types
(defstruct op
  "An operation."
  (action nil) (preconds nil) (add-list nil) (del-list nil))


;;Major Functions
(defun achieve-all (state goals goal-stack)
  "Achieve each goal, and make sure they still hold at the end."
  (let ((current-state state))
    (if (and (every #'(lambda (g)
                        (setf current-state
                              (achieve current-state g goal-stack)))
                    goals)
             (subsetp goals current-state :test #'equal))
        current-state)))

(defun achieve (state goal goal-stack)
  "A goal is achieved if it already holds, or if there is an appropriate op for it that is applicable."
  (dbg-indent :gps (length goal-stack) "Goal: ~a " goal)
  (cond ((member-equal goal state) state)
        ((member-equal goal goal-stack) nil)
        (t (some #'(lambda (op) (apply-op state goal op goal-stack))
                 (find-all goal *ops* :test #'appropriate-p)))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if it is in its add list." 
  (member-equal goal (op-add-list op)))

(defun apply-op (state goal op goal-stack)
  "Return a new, transformed state if op is applicable."
  (dbg-indent :gps (length goal-stack) "Consider: ~a" (op-action op))
  (let ((state2 (achieve-all state (op-preconds op)
                             (cons goal goal-stack))))
    (unless (null state2)
      ;; Return an updated state
      (dbg-indent :gps (length goal-stack) "Action: ~a" (op-action op))
      (append (remove-if #'(lambda (x)
                             (member-equal x (op-del-list op)))
                         state2)
              (op-add-list op)))))

;;Auxiliary Functions
(defun executing-p (x)
  "Is x of the form: (executing ... ) ?"
  (starts-with x 'executing))

(defun starts-with (list x)
  "Is this a list whose first element is x?"
  (and (consp list) (eql (first list) x)))

(defun convert-op (op)
  "Make op conform to the (EXECUTING op) convention."
  (unless (some #'executing-p (op-add-list op))
    (push (list 'executing (op-action op)) (op-add-list op)))
  op)

(defun op (action &key preconds add-list del-list)
  "Make a new operator that obeys the (EXECUTING op) convention."
  (convert-op
   (make-op :action action :preconds preconds
            :add-list add-list :del-list del-list)))

(defun use (oplist)
  "Use oplist as the default list of operators."
  ;; Return something useful, but not too verbose: the number of operators,
  (length (setf *ops* oplist)))

(defun member-equal (item list)
  (member item list :test #'equal))


;;Debugging
(defvar *dbg-ids* nil "Identifiers used by dbg")

(defun dbg (id format-string &rest args)
  "Print debugging info if (DEBUG ID) has been specified."
  (when (member id *dbg-ids*)
    (fresh-line *debug-io*)
    (apply #'format *debug-io* format-string args)))

(defun dbg-indent (id indent format-string &rest args)
  "Print indented debugging info if (DEBUG ID) has been specified."
  (when (member id *dbg-ids*)
    (fresh-line *debug-io*)
    (dotimes (i indent) (princ " " *debug-io*))
    (apply #'format *debug-io* format-string args)))

(defun debug2 (&rest ids)
  ;; I had to change the name as 'debug' was giving me [Condition of type SYMBOL-PACKAGE-LOCKED-ERROR] on compile.
  "Start dbg output on the given ids."
  (setf *dbg-ids* (union ids *dbg-ids*)))

(defun undebug (&rest ids)
  "Stop dbg on the ids. With no ids, stop dbg altogether."
  (setf *dbg-ids* (if (null ids) nil
                      (set-difference *dbg-ids* ids))))


;;Operators
(defparameter *school-ops*
  (list
   (make-op :action 'drive-son-to-school
            :preconds '(son-at-home car-works)
            :add-list '(son-at-school)
            :del-list '(son-at-home))
   (make-op :action 'shop-installs-battery
            :preconds '(car-needs-battery shop-knows-problem shop-has-money)
            :add-list '(car-works))
   (make-op :action 'tell-shop-problem
            :preconds '(in-communication-with-shop)
            :add-list '(shop-knows-problem))
   (make-op :action 'telephone-shop
            :preconds '(know-phone-number)
            :add-list '(in-communication-with-shop))
   (make-op :action 'look-up-number
            :preconds '(have-phone-book)
            :add-list '(know-phone-number))
   (make-op :action 'give-shop-money
            :preconds '(have-money)
            :add-list '(shop-has-money)
            :del-list '(have-money))
   (make-op :action 'ask-phone-number
            :preconds '(in-communication-with-shop)
            :add-list '(know-phone-number))
   )
  )

(mapc #'convert-op *school-ops*)

;;;;;Outputs - Drive son to school 
;; CL-USER> (use *school-ops*)
;; 7

;; CL-USER> (gps '(son-at-home car-needs-battery have-money have-phone-book) '(son-at-school))
;; 0: (GPS (SON-AT-HOME CAR-NEEDS-BATTERY HAVE-MONEY HAVE-PHONE-BOOK) (SON-AT-SCHOOL))
;; 0: GPS returned
;; ((START) (EXECUTING LOOK-UP-NUMBER) (EXECUTING TELEPHONE-SHOP)
;;          (EXECUTING TELL-SHOP-PROBLEM) (EXECUTING GIVE-SHOP-MONEY)
;;          (EXECUTING SHOP-INSTALLS-BATTERY) (EXECUTING DRIVE-SON-TO-SCHOOL))
;; ((START) (EXECUTING LOOK-UP-NUMBER) (EXECUTING TELEPHONE-SHOP)
;;          (EXECUTING TELL-SHOP-PROBLEM) (EXECUTING GIVE-SHOP-MONEY)
;;          (EXECUTING SHOP-INSTALLS-BATTERY) (EXECUTING DRIVE-SON-TO-SCHOOL))

;; CL-USER> (debug2 :gps)
;; (:GPS)

;; CL-USER> (gps '(son-at-home car-needs-battery have-money have-phone-book) '(son-at-school))
;; 0: (GPS (SON-AT-HOME CAR-NEEDS-BATTERY HAVE-MONEY HAVE-PHONE-BOOK) (SON-AT-SCHOOL))
;; Goal: SON-AT-SCHOOL 
;; Consider: DRIVE-SON-TO-SCHOOL
;; Goal: SON-AT-HOME 
;; Goal: CAR-WORKS 
;; Consider: SHOP-INSTALLS-BATTERY
;; Goal: CAR-NEEDS-BATTERY 
;; Goal: SHOP-KNOWS-PROBLEM 
;; Consider: TELL-SHOP-PROBLEM
;; Goal: IN-COMMUNICATION-WITH-SHOP 
;; Consider: TELEPHONE-SHOP
;; Goal: KNOW-PHONE-NUMBER 
;; Consider: LOOK-UP-NUMBER
;; Goal: HAVE-PHONE-BOOK 
;; Action: LOOK-UP-NUMBER
;; Action: TELEPHONE-SHOP
;; Action: TELL-SHOP-PROBLEM
;; Goal: SHOP-HAS-MONEY 
;; Consider: GIVE-SHOP-MONEY
;; Goal: HAVE-MONEY 
;; Action: GIVE-SHOP-MONEY
;; Action: SHOP-INSTALLS-BATTERY
;; Action: DRIVE-SON-TO-SCHOOL  0: GPS returned
;; ((START) (EXECUTING LOOK-UP-NUMBER) (EXECUTING TELEPHONE-SHOP)
;;          (EXECUTING TELL-SHOP-PROBLEM) (EXECUTING GIVE-SHOP-MONEY)
;;          (EXECUTING SHOP-INSTALLS-BATTERY) (EXECUTING DRIVE-SON-TO-SCHOOL))
;; ((START) (EXECUTING LOOK-UP-NUMBER) (EXECUTING TELEPHONE-SHOP)
;;          (EXECUTING TELL-SHOP-PROBLEM) (EXECUTING GIVE-SHOP-MONEY)
;;          (EXECUTING SHOP-INSTALLS-BATTERY) (EXECUTING DRIVE-SON-TO-SCHOOL))

;; CL-USER> (undebug)
;; NIL

;; CL-USER> (gps '(son-at-home car-works) '(son-at-school))
;; 0: (GPS (SON-AT-HOME CAR-WORKS) (SON-AT-SCHOOL))
;; 0: GPS returned ((START) (EXECUTING DRIVE-SON-TO-SCHOOL))
;; ((START) (EXECUTING DRIVE-SON-TO-SCHOOL))

;; CL-USER> (gps '(son-at-home car-needs-battery have-money have-phone-book) '(have-money son-at-school))
;; 0: (GPS (SON-AT-HOME CAR-NEEDS-BATTERY HAVE-MONEY HAVE-PHONE-BOOK) (HAVE-MONEY SON-AT-SCHOOL))
;; 0: GPS returned NIL
;; NIL

;; CL-USER> (gps '(son-at-home car-needs-battery have-money have-phone-book) '(son-at-school have-money))
;; 0: (GPS (SON-AT-HOME CAR-NEEDS-BATTERY HAVE-MONEY HAVE-PHONE-BOOK) (SON-AT-SCHOOL HAVE-MONEY))
;; 0: GPS returned NIL
;; NIL

;; CL-USER> (gps '(son-at-home car-needs-battery have-money) '(son-at-school))
;; 0: (GPS (SON-AT-HOME CAR-NEEDS-BATTERY HAVE-MONEY) (SON-AT-SCHOOL))
;; 0: GPS returned NIL
;; NIL

;; CL-USER> (gps '(son-at-home) '(son-at-home))
;; 0: (GPS (SON-AT-HOME) (SON-AT-HOME))
;; 0: GPS returned ((START))
;; ((START)

;;;;;Monkey and Bananas
(defparameter *banana-ops*
  (list
       (op 'climb-on-chair
           :preconds '(chair-at-middle-room at-middle-room on-floor)
           :add-list '(at-bananas on-chair)
           :del-list '(at-middle-room on-floor))
       (op 'push-chair-from-door-to-middle-room
           :preconds '(chair-at-door at-door)
           :add-list '(chair-at-middle-room at-middle-room)
           :del-list '(chair-at-door at-door))
       (op 'walk-from-door-to-middle-room
           :preconds '(at-door on-floor)
           :add-list '(at-middle-room)
           :del-list '(at-door))
       (op 'grasp-bananas
           :preconds '(at-bananas empty-handed)
           :add-list '(has-bananas)
           :del-list '(empty-handed))
       (op 'drop-ball
           :preconds '(has-ball)
           :add-list '(empty-handed)
           :del-list '(has-ball))
       (op 'eat-bananas
           :preconds '(has-bananas)
           :add-list '(empty-handed not-hungry)
           :del-list '(has-bananas hungry)))
       )

(mapc #'convert-op *banana-ops*)
  
;;;;;Outputs - Monkey and Bananas
;; CL-USER> (use *banana-ops*)
;; 6

;; CL-USER> (GPS '(at-door on-floor has-ball hungry chair-at-door) '(not-hungry))
;; 0: (GPS (AT-DOOR ON-FLOOR HAS-BALL HUNGRY CHAIR-AT-DOOR) (NOT-HUNGRY))
;; 0: GPS returned
;; ((START) (EXECUTING PUSH-CHAIR-FROM-DOOR-TO-MIDDLE-ROOM)
;;          (EXECUTING CLIMB-ON-CHAIR) (EXECUTING DROP-BALL)
;;          (EXECUTING GRASP-BANANAS) (EXECUTING EAT-BANANAS))
;; ((START) (EXECUTING PUSH-CHAIR-FROM-DOOR-TO-MIDDLE-ROOM)
;;          (EXECUTING CLIMB-ON-CHAIR) (EXECUTING DROP-BALL) (EXECUTING GRASP-BANANAS)
;;          (EXECUTING EAT-BANANAS))

;;;;;
