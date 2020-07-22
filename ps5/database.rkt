#lang racket
;;;
;;; database.rkt
;;; UVa cs1120 Fall 2011
;;; Problem Set 5
;;;

;;; We represent a table using a mutable cons cell of the list of fields and the list of entries.  
;;; Each field is a quoted symbol (e.g., 'name).  Each entry is a list of values, where
;;; the nth value in the list gives the value of the nth field for this entry.
;;;
(require scheme/mpair)
(require "book-code.rkt")
(provide (all-defined-out))

(define (make-new-table fieldlist) 
  (make-table fieldlist null))

(define (make-table fieldlist entries) 
  (make-tlist 'table (mcons fieldlist entries)))



(define (table-fields t) (mcar (tlist-get-data 'table t)))
(define (table-entries t) (mcdr (tlist-get-data 'table t)))

;;; Inserts an entry into a table
(define (table-insert! table entry)
  ;;; The entry must have the right number of values --- one for each field in the table
  (assert (= (length entry) (length (table-fields table))))
  (if (null? (table-entries table))
      (set-mcdr! (tlist-get-data 'table table) (mlist entry))
      (mlist-append! (table-entries table) (mlist entry)))
  (void)) ;;; don't evaluate to a value

;;; Outputs 0 if field is not the name of a field in table; otherise, the index of the field.
(define (table-field-number table field)
  (list-find-element (table-fields table) field))


    

;;; Replaces a certain number in the list with a new value:

(define (mlist-replace-nth! list num new-val)
  (if (= num 1)
      (set-mcar! list new-val)
      (mlist-replace-nth! (mcdr list) (- num 1) new-val)))

;;; This constant determines the maximum display width for printing tables.

(define display-width 80)

(define (make-string-length s len)
  (assert (> len 0))
  (if (>= (string-length s) len)
      (substring s 0 len)
      (string-append s (make-string (- len (string-length s)) #\space))))

(define (print-list-width lst fieldwidth)
  (if (null? lst)
      (newline)
      (begin
        (printf "~a " (make-string-length (format "~a" (car lst)) fieldwidth))
        (print-list-width (cdr lst) fieldwidth))))

(define (make-constant-function cst) (lambda (p) cst))

(define (table-display table)
  ;;; Prints out the table in columns
  (let ((fieldwidth (floor (/ display-width (length (table-fields table))))))
    (print-list-width (table-fields table) fieldwidth)
    ;;; Yes, make-constant-function (from the last year's sample Exam 1) really is useful!
    (print-list-width (map (make-constant-function "-------------------------")
                           (table-fields table)) 
                      fieldwidth)
    ;; mmap since we are mapping on a mutable list (mmap has no ! - it doesn't modify the input list)
    (mmap (lambda (entry) (print-list-width entry fieldwidth)) (table-entries table))
    (void)))
