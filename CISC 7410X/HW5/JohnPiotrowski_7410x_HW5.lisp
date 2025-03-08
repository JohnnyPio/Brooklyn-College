;John Piotrowski - 7410x - HW5
;GPS

; I want to get home from class. There are three ways I can get home: walk to the campus ave. bus stop and either take the b6 or the b11 to the F train or walk to flatbush avenue and take the b103. There will be waiting for the buses and F trains. Once I finish either 3 of the routes I can quick-walk-home. 

(defvar *state* nil "The current state: a list of conditions.")

(defvar *ops* nil "A list of available operators.")

(defstruct op "An operation"
           (action nil) (preconds nil) (add-list nil) (del-list nil))

(defun gps-get-home-from-class *state* goals *ops*)

(defun achieve (goal)
  "A goal i s achieved if it already holds, or if there is an appropriate op for it that is applicable."
  (or (member goal *state*)
      (some #'apply-op
            (find-all goal *ops * :test #'appropriate-p))))

(defun appropriate-p (goal op)
  "An op is appropriate to a goal if it is in its add list."
  (member goal (op-add-list op)))

(defun apply-op (op)
  "Print a message and update *state* if op is applicable."
  (when (every #*achieve (op-preconds op))
    (print (list 'executing (op-action op)))
    (setf *state* (set-difference *state* (op-del-list op)))
    (setf *state* (union *state* (op-add-list op)))
    t))

