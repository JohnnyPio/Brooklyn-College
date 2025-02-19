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


