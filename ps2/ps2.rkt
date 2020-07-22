#lang racket
;;;
;;; cs1120 Fall 2011 | ps2.rkt
;;;

(define author (list "my-uva-id" "partner-uva-id?")) ;; who are you? 
 
(require "genomes.rkt")
(require "ch5-code.rkt")

;;; Question 1 and 2: type your answers as comments here, or submit them on a separate (but attached!) sheet of paper.

;;; Question 3:

(define (nucleotide-complement b)
  (cond((eq? b 'A)'T)
       ((eq? b 'G)'C)
       ((eq? b 'T)'A)
       ((eq? b 'C)'G))
  )

;;; Question 4: sequence-complement
(define (sequence-complement lst)
  (map nucleotide-complement lst))

;;; Question 5: count-matches
(define (count-matches lst value)
  (list-length
   (list-filter
    (lambda(a)(eq? a value))
    lst)))

;;; Question 6: hamming-distance
(define (hamming-distance lst1 lst2)
  (define(iter restlst1 restlst2 countvalue)
    (if(null? restlst1)
       countvalue
       (let ((new-count(if(eq? (car restlst1)
                                (car restlst2))
                           countvalue
                           (+ countvalue 1))))
          (iter (cdr restlst1) (cdr restlst2) new-count))))
  (iter lst1 lst2 0))

;;; Question 7: (nothing to turn in)
;;“ACAT”, “ACA”  1
;;“AACCT”, “CCCCT”  2 
;;“GATTACA”, “GACACA” 2
;;“ACAT”, “” 4 
;;“AAAAAAAAAAAAAAAAAA”, “AAAAAAAAAAAAAAAAAA”
;;; Question 8: edit-distance
(define (edit-distance lst1 lst2)
  (cond((null? lst1)(list-length lst2))
       ((null? lst2)(list-length lst1))
       (else
        (if (eq? (car lst1)(car lst2))
            (edit-distance (cdr lst1) (cdr lst2))
            (+ 1
                (min (edit-distance (cdr lst1) lst2)
                     (edit-distance lst1 (cdr lst2))
                     (edit-distance (cdr lst1) (cdr lst2))))))))

(edit-distance (make-nucleotide-sequence "ACAT") (make-nucleotide-sequence "ACA"))
(edit-distance (make-nucleotide-sequence "AACCT") (make-nucleotide-sequence "CCCCT"))
(edit-distance (make-nucleotide-sequence "GATTACA") (make-nucleotide-sequence "GACACA"))
(edit-distance (make-nucleotide-sequence "ACAT") (make-nucleotide-sequence ""))
(edit-distance (make-nucleotide-sequence "AAAAAAAAAAAAAAAAAA") (make-nucleotide-sequence "AAAAAAAAAAAAAAAAAA"))
(edit-distance (make-nucleotide-sequence "ACGT") (make-nucleotide-sequence "ACATT"))
;;; Question 9: memoized-edit-distance

(define memoized-edit-distance
  (memoize (lambda(lst1 lst2)
             (cond((null? lst1)(list-length lst2))
                  ((null? lst2)(list-length lst1))
                  (else
                   (if (eq? (car lst1)(car lst2))
                       (memoized-edit-distance (cdr lst1) (cdr lst2))
                       (+ 1
                          (min (memoized-edit-distance (cdr lst1) lst2)
                               (memoized-edit-distance lst1 (cdr lst2))
                               (memoized-edit-distance (cdr lst1) (cdr lst2))))))))))
  