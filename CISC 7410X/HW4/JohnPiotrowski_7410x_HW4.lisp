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

;;;8.3
