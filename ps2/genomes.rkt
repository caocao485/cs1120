#lang racket
;;;
;;; genome.rkt
;;; cs1120 Fall 2011 | Problem Set 2
;;; You should not need to edit this file, but should be able to
;;; understand everything in it (except for the definition of memoize).
;;;

(require racket/base) ; needed for hash table
(require racket/trace)
(require "ch5-code.rkt")
(provide (all-defined-out))

(define (base-from-char c)
  (if (or (eq? c #\A) (eq? c #\a))
      'A
      (if (or (eq? c #\T) (eq? c #\t))
          'T
          (if (or (eq? c #\G) (eq? c #\g))
              'G
              (if (or (eq? c #\C) (eq? c #\c))
                  'C
                  (error "Bad char: " c))))))
  
(define (make-nucleotide-sequence s)
  (list-map base-from-char (string->list s)))

;;; It is not necessary or expected that you understand this definition.
;; This only works on two-input functions
(define (memoize f)
  (let ((ht (make-hash)))
    (lambda (s1 s2)
      (let ((key (format "~a#~a" s1 s2)))
        (hash-ref ht key 
                  (lambda ()
                    (let ((res (f s1 s2)))
                      (hash-set! ht key res)
                      res)))))))

;;; Some interesting data to try (once you have memoized-edit-distance working)

;; >gi|163644328|ref|NM_009696.3| Mus musculus apolipoprotein E (Apoe), mRNA 
;; I have removed part of the full protein sequence to make it shorter.
(define apoe-normal
  (make-nucleotide-sequence
   "GCAGGCGGAGATCTTCCAGGCCCGCCTCAAGGGCTGGTTCGAGCCAATAGTGGAAGACATGCATCGCCAGTGGGCAAACCTGATGGAGAAGATACAGGCCTCTGTGGCTACCAACCCCATCATCACCCCAGTGGCCCAGGAGAATCAATGAGTATCCTTCTCCTGTCCTGCAACAACATCCATATCCAGCCAGGTGGCCCTGTCTCAAGCACCTCTCTGGCCCTCTGGTGGCCCTTGCTTAATAAAGATTCTCCGAGCACATTCTGAGTCTCTGTGAGTGATTCCAAAAAAAAAAAAAAAAA"))

;;; Note: I have not been able to find the actual bad sequence or figure out correctly which positions to modify...but
;;; the edit distance between this sequence and the good sequence is the same as that between the actual bad sequence.
(define apoe-bad
  (make-nucleotide-sequence
   "GCAGGCGGAGATCTTCCAGGCCCGCCTCAAGGGCTGGTTCGAGCCAATAGTGGAAGACATGCATCGCCAGTGGGCAAACCTGATGGAGAAGATACAGGCCTCTGTGCCTACCAACCCCATCATCACCCCAGTGGCCCAGGAGAATCAATGAGTATCCTTCTCCTGTCCTGCAACATCATCCATATCCAGCCAGGTGGCCCTGTCTCAAGCACCTCTCTGGCCCTCTGGTGGCCCTTGCTTAATAAAGATTCTCCGAGCACATTCTGAGTCTCTGTGAGTGATTCCAAAAAAAAAAAAAAAAA"))
   

