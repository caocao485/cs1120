#lang racket

;;; 
;;; book-code.rkt
;;;
;;; This file contains some procedures that are useful for Problem Set 5.
;;; All of the procedures are defined in the course book.

(require racket/mpair)
(provide (all-defined-out))

;;; This code is from Chapter 5.

(define (list-length p)
  (if (null? p) 
      0 
      (+ 1 (list-length (cdr p)))))

(define (list-sum p)
  (if (null? p) 
      0 
      (+ (car p) (list-sum (cdr p)))))

(define (list-product p)
  (if (null? p) 
      1 
      (* (car p) (list-product (cdr p)))))

(define (list-get-element p n) 
  (if (null? p)
      (error "Index out of range")
      (if (= n 1)	
          (car p)	
          (list-get-element (cdr p) (- n 1)))))

(define (list-map f p)
  (if (null? p) 
      null
      (cons (f (car p)) 
            (list-map f (cdr p)))))

(define (list-filter test p)
  (if (null? p) 
      null
      (if (test (car p))
          (cons (car p) (list-filter test (cdr p)))
          (list-filter test (cdr p)))))

(define (list-append p q)
  (if (null? p)   
      q
      (cons (car p) (list-append (cdr p) q))))

(define (list-reverse p)
  (if (null? p) 
      null 
      (list-append (list-reverse (cdr p)) (list (car p)))))

(define (intsto n)
  (if (= n 0) 
      null 
      (list-append (intsto (- n 1)) (list n))))

(define (list-flatten p)
  (if (null? p) null
      (list-append (car p) (list-flatten (cdr p)))))

(define (deep-list-flatten p)
  (if (null? p) null
      (list-append (if (list? (car p))
                       (deep-list-flatten (car p))
                       (list (car p)))
                   (deep-list-flatten (cdr p)))))

;;; Tagged Lists (from Section 5.6)

(define (make-tlist tag p) (cons tag p))
(define (tlist-get-tag p) (car p))

(define (tlist-get-data tag p) 
  (if (not (eq? (tlist-get-tag p) tag))
      (error (format "Bad tag: ~a (expected ~a)" (tlist-get-tag p) tag))
      (cdr p)))

(define (tlist-get-element tag p n)
  (if (eq? (tlist-get-tag p) tag)
      (list-get-element (cdr p) n)
      (error (format "Bad tag: ~a (expected ~a)" (tlist-get-tag p) tag))))

(define (list-find-element p el) ; evaluates to the index of element el
  (define (list-find-element-helper p el n)
    (if (null? p)
        0 ; element not found
        (if (eq? (car p) el)
            n
            (list-find-element-helper (cdr p) el (+ n 1)))))
  (list-find-element-helper p el 1))

;;; We use assert to check properties that must be true.  If an assertion fails,
;;; it probably means there is a bug in your code.  This is a form of defensive
;;; programming.

(define (assert pred)
  (if (not pred) (error "Assertion failed!") 0))

;;; These mutable list procedures are from Chapter 9.

(define (mlist-length m)
  (if (null? m) 0 (+ 1 (mlist-length (mcdr m)))))

(define (mlist-append! p q)
  (if (null? p) (error "Cannot append! to an empty list.")
      (if (null? (mcdr p)) (set-mcdr! p q)
          (mlist-append! (mcdr p) q))))

;;; Note that this is different from mlist-filter! in the book! 
;;; Instead of mutating a list, it takes a mutable list as input
;;; and produces a new mutable list.

(define (mlist-filter test p)
  (if (null? p) null
      (if (test (mcar p))
          (mcons (mcar p) (mlist-filter test (mcdr p)))
          (mlist-filter test (mcdr p)))))

;;; Similar to list-get-element
(define (mlist-get-element p n) 
  (if (null? p)
      (error "Index out of range")
      (if (= n 1)	
          (mcar p)	
          (mlist-get-element (mcdr p) (- n 1)))))

;;; Similar to list-find-best but for mlists:

(define (pick-better cf p1 p2)
  (if (cf p1 p2) p1 p2))

(define (mlist-find-best cf p)
  (if (null? (mcdr p)) (mcar p)
      (pick-better cf (mcar p) (mlist-find-best cf (mcdr p)))))

;;; Same as list-sum, but for mlist
(define (mlist-sum p)
  (if (null? p)
      0
      (+ (mcar p) (mlist-sum (mcdr p)))))
