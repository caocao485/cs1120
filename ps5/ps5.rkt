#lang racket

;;;
;;; ps5.rkt
;;; UVa cs1120 Fall 2011
;;; Problem Set 5
;;;
;;; Your name(s): __________________________________________ [include your full names]

(require "auction.rkt")
(require "database.rkt")


;;; Question 1: measuring cost (on paper)
;;; Question 2: environments (on paper)

;;; Question 3: post-item! (a) code, (b) running time analysis


;;; Question 4: insert-bid! (a) code, (b) running time analysis

;;; Question 5: table-select

(define (table-select table field predicate)
  (let ((fieldno (table-field-number table field)))
    (if (= fieldno 0)
        (error "No matching field: ~a" field)
        (void))))     ;; complete the definition with your code

;;; 5b. table-select running time analysis

;;; Question 6: get-highest-bid (a) code, (b) running time analysis

(define (get-highest-bid item)
  (let ((fieldno (table-field-number bids 'amount))
        (entries (table-entries (table-select bids 'item-name (make-string-selector item)))))
    (cond((null? entries) null)
         (else(max-entries fieldno entries)))));; Replace with your code. The "let" expression is merely a suggestion.
       
(define(max-entries fieldno entries)
  (if(= (length entries) 1)
     (mcar entries)
     (let((car-entry(mcar entries))
          (rest-max (max-entries fieldno (mcdr entries))))
       (if(> (list-ref car-entry (- fieldno 1)) (list-ref rest-max (- fieldno 1)))
          car-entry
          rest-max))))

;;; Question 7: place-bid! 

;;; Question 8: end-auction! (a) code, (b) running time analysis

