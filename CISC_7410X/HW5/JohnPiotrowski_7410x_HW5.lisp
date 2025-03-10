;John Piotrowski - 7410x - HW5
;GPS

; I want to get home from class. There are three ways I can get home: take the b6 and to the F train - cost $, take the b103 - cost $, or bike - doesn't cost money.

;; CL-USER> (GPS '(in-class class-over trains-running busses-running have-money) '(at-home) *route-ops*)
;; (EXECUTING WALK-TO-B6) 
;; (EXECUTING TAKE-B6) 
;; (EXECUTING ARRIVE-AT-BAY-PARKWAY-STATION) 
;; (EXECUTING TAKE-F-TRAIN) 
;; (EXECUTING ARRIVE-AT-CHURCH-AVE) 
;; (EXECUTING WALK-HOME-FROM-SUBWAY-STATION) 
;; SOLVED

;; CL-USER> (GPS '(in-class class-over busses-running have-money) '(at-home) *route-ops*)
;; (EXECUTING WALK-TO-B103) 
;; (EXECUTING TAKE-B103) 
;; (EXECUTING ARRIVE-AT-MCDONALD-AVE-BUS-STOP) 
;; (EXECUTING WALK-HOME-FROM-BUS-STOP) 
;; SOLVED

;; CL-USER> (GPS '(in-class class-over brought-bike have-key) '(at-home) *route-ops*)
;; (EXECUTING WALK-TO-BIKE) 
;; (EXECUTING UNLOCK-BIKE) 
;; (EXECUTING ARRIVE-AT-BUILDING) 
;; (EXECUTING LOCK-BIKE) 
;; (EXECUTING TAKE-ELEVATOR) 
;; SOLVED

;; Walking home is the fallback :)
;; CL-USER> (GPS '(in-class class-over trains-running have-money) '(at-home) *route-ops*)
;; (EXECUTING WALK-HOME-IN-AN-HOUR) 
;; (EXECUTING THIS-IS-LONGER-THAN-IDEAL) 
;; (EXECUTING FINALLY-HOME) 
;; SOLVED

(defvar *state* nil "The current state: a list of conditions.")

(defvar *ops* nil  "A list of available operators.")

(defstruct op
  "An operation."
  (action nil) (preconds nil) (add-list nil) (del-list nil))

(defun GPS (*state* goals *ops*)
  "General Problem Solver: achieve all goals using *ops*."
  (if (every #'achieve goals) 'solved))

(defun find-all (item sequence &rest keyword-args  &key (test #'eql) test-not &allow-other-keys)
  "Find all those elements of sequence that match item, according to the keywords. Doesn't alter sequence."
  (if test-not
      (apply #'remove item sequence
             :test-not (complement test-not) keyword-args)
      (apply #'remove item sequence
             :test (complement test) keyword-args)))

(defun achieve (goal)
  "A goal is achieved if it already holds, or if there is an appropriate op for it that is applicable."
  (or (member goal *state*)
      (some #'apply-op
            (find-all goal *ops* :test #'appropriate-p))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if it is in its add list." 
  (member goal (op-add-list op)))

(defun apply-op (op)
  "Print a message and update *state* if op is applicable."
  (when (every #'achieve (op-preconds op))
    (print (list 'executing (op-action op)))
    (setf *state* (set-difference *state* (op-del-list op)))
    (setf *state* (union *state* (op-add-list op)))
    t))

(defparameter *route-ops*
  (list
   ;;B6 and F train
  (make-op :action 'walk-to-b6
           :preconds '(class-over)
           :add-list '(wait-for-b6)
           :del-list '(in-class))
  (make-op :action 'take-b6
           :preconds '(busses-running have-money wait-for-b6)  
           :add-list '(on-b6)
           :del-list '(wait-for-b6))
  (make-op :action 'arrive-at-bay-parkway-station
           :preconds '(on-b6)  
           :add-list '(at-bay-parkway-station)
           :del-list '(on-b6))
  (make-op :action 'take-f-train
           :preconds '(trains-running have-money at-bay-parkway-station)
           :add-list '(on-f-train)
           :del-list '(on-b6))
  (make-op :action 'arrive-at-church-ave
           :preconds '(on-f-train)
           :add-list '(at-church-ave-station)
           :del-list '(on-f-train))
  (make-op :action 'walk-home-from-subway-station
           :preconds '(at-church-ave-station)
           :add-list '(at-home)
           :del-list '(at-church-ave-station))
  ;;B103
  (make-op :action 'walk-to-b103
           :preconds '(class-over)
           :add-list '(wait-for-b103)
           :del-list '(in-class))
  (make-op :action 'take-b103
           :preconds '(busses-running have-money wait-for-b103)  
           :add-list '(on-b103)
           :del-list '(wait-for-b103))
  (make-op :action 'arrive-at-mcdonald-ave-bus-stop
           :preconds '(on-b103)
           :add-list '(at-mcdonald-ave-bus-stop)
           :del-list '(on-b103))
  (make-op :action 'walk-home-from-bus-stop
           :preconds '(at-mcdonald-ave-bus-stop)
           :add-list '(at-home)
           :del-list '(at-mcdonald-ave-bus-stop))
  ;;Bike
  (make-op :action 'walk-to-bike
           :preconds '(class-over brought-bike)
           :add-list '(at-bike)
           :del-list '(in-class))
  (make-op :action 'unlock-bike
           :preconds '(at-bike have-key)
           :add-list '(biking)
           :del-list '(at-bike))
  (make-op :action 'arrive-at-building
           :preconds '(biking)
           :add-list '(at-building-bike-storage)
           :del-list '(biking))
  (make-op :action 'lock-bike
           :preconds '(have-key at-building-bike-storage)
           :add-list '(locked-bike)
           :del-list '(at-building-bike-storage))
  (make-op :action 'take-elevator
           :preconds '(locked-bike)
           :add-list '(at-home)
           :del-list '(locked-bike))
  ;;Walk - this works as a fallback option in case none of the 3 states are met.
  (make-op :action 'walk-home-in-an-hour
           :preconds '(in-class class-over)
           :add-list '(walking)
           :del-list '(in-class))
  (make-op :action 'this-is-longer-than-ideal
           :preconds '(walking)
           :add-list '(being-miserable))
  (make-op :action 'finally-home
           :preconds '(walking being-miserable)
           :add-list '(at-home)
           :del-list '(walking being-miserable))
  )
  )
 
