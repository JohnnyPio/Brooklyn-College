;John Piotrowski - 7410x - HW5
;GPS

; I want to get home from class. There are three ways I can get home: walk to the b6 and take that to the F train - cost $6, walk to flatbush avenue and take the b103 - cost $3, or bike-free. Either 3 of the routes I can quick-walk-home. The 3 starting states can be (busses-running trains-running have-money), (busses-running have-money), (brought-bike have-no-money).

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
  (make-op :action 'walk-to-b6
           :preconds '(class-over)
           :add-list '(wait-for-b6)
           :del-list '(in-class))
  (make-op :action 'take-b6
           :preconds '(busses-running have-money)  
           :add-list '(on-b6)
           :del-list '(wait-for-b6))
  (make-op :action 'take-f-train
           :preconds '(trains-running have-money)
           :add-list '(on-f-train)
           :del-list '(on-b6))
  (make-op :action 'walk-home-from-church-ave
           :preconds '(busses-running trains-running have-money)
           :add-list '(quick-walk-home)
           :del-list '(on-f-train))
  (make-op :action 'walk-home
           :add-list '(at-home)
           :del-list '(quick-walk-home))
  ))





 
