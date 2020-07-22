#lang racket

;;;
;;; auction.rkt
;;;

(require racket/mpair)
(require "database.rkt")
(require "book-code.rkt")
(provide (all-defined-out))

;;; Table of people who can bid on items
(define bidders (make-new-table (list 'name 'email)))

;;; Table of the items currently up for auction
(define items (make-new-table (list 'item-name 'description)))

;;; Table of all bids
(define bids (make-new-table (list 'bidder-name 'item-name 'amount)))

;;; Adding a bidder
(define (add-bidder! name email)
  (table-insert! bidders (list name email)))

;;Post item
(define (post-item! item-name description)
  (table-insert! items (list item-name description)))


;;Insert bid
(define (insert-bid! bidder-name item-name amount)
  (table-insert! bids (list bidder-name item-name amount)))

;;; creates empty tables for bidders, items for sale, and bids
(define (clear-tables)
  (set! bidders (make-new-table (list 'name 'email)))
  (set! items (make-new-table (list 'item-name 'description)))
  (set! bids (make-new-table (list 'bidder-name 'item-name 'amount))))
  
;;; setup-tables puts some entries in the tables for testing
;;; (Note: all bidders are purely fictional.  Any resemblance to
;;;  actual rich people is purely coincidental.)

(define (setup-tables)
  (clear-tables)
  (add-bidder! "Katie Couric" "kt@cbs.com")
  (add-bidder! "Tina Fey" "tina@snl.com")
  (add-bidder! "D'Brickashaw Ferguson" "dbrickfnd@comcast.net")
  (add-bidder! "Tim Koogle" "tk@yahoo.com")
  (add-bidder! "Dave Matthews" "dave@dmb.com")
  (add-bidder! "Paul Rice" "paul.rice@mac.com")
  
  (post-item! "CLAS"  "College of (Liberal) Arts and Sciences")
  (post-item! "SEAS"  "School of Engine and Apple Science")
  (post-item! "CS1120" "Customer Service From Aardvarks to Zebras")
  (post-item! "Olsson Hall"   "Olsson's Hall of Horrors")
  (post-item! "Rice Hall"  "Rice's Hall of Bagels and Bewilderment")
  (post-item! "SIS"   "Student Irritation System")
  
  (insert-bid! "Tim Koogle"    "SEAS" 10000000)
  (insert-bid! "Dave Matthews" "CLAS"  2000000)
  (insert-bid! "D'Brickashaw Ferguson"   "CS1120" 1120000)
  (insert-bid! "Tina Fey"      "CLAS" 37000000)
  (insert-bid! "Paul Rice"     "Rice Hall" 10000000)
  (insert-bid! "Katie Couric"  "SIS"  1)
  (insert-bid! "Dave Matthews" "SIS"  2)
  )

(define (make-string-selector match)
  (lambda (fval) (string=? fval match)))

(define (get-bids item)
  (table-entries (table-select bids 'item-name (make-string-selector item))))

;;table select



(define (table-select table field predicate)
  (let ((fieldno (table-field-number table field)))
    (if (= fieldno 0)
        (error "No matching field: ~a" field)
          (make-table
           (table-fields table)
           (mlist-filter
           (lambda(bid)
             (predicate(list-ref bid (- fieldno 1))))
           (table-entries table))))))


(define (get-highest-bid item)
  (let ((fieldno (table-field-number bids 'amount))
        (entries (table-entries (table-select bids 'item-name (make-string-selector item)))))
    (cond((= fieldno 0)(error "cannot find item amount"))
         ((null? entries) null)
         (else(max-entry fieldno entries)))));; Replace with your code. The "let" expression is merely a suggestion.
       
(define(max-entry fieldno entries)
  (if(= (mlist-length entries) 1)
     (mcar entries)
     (let((car-entry(mcar entries))
          (rest-max (max-entry fieldno (mcdr entries))))
       (if(> (list-ref car-entry (- fieldno 1)) (list-ref rest-max (- fieldno 1)))
          car-entry
          rest-max))))

;;Question 7
(define (place-bid! bidder-name item-name amount)
  (cond((null? (table-entries (table-select bidders 'name (make-string-selector bidder-name))))
        (error (string-append bidder-name " is not a legitimate bidder!") ))
       ((null? (table-entries (table-select items 'item-name (make-string-selector item-name))))
        (error (string-append item-name " is not for sale!") ))
       ((or(null? (get-highest-bid item-name))
           (< (list-ref (get-highest-bid item-name)
                        (- (table-field-number bids 'amount) 1))
              amount))
        (let*((entries(table-entries bids))
              (v-index(mindex-where entries
                                  (lambda(bid)
                                    (and
                                     (equal? bidder-name
                                            (list-ref
                                             bid
                                             (- (table-field-number bids 'bidder-name) 1)))
                                     (equal? item-name
                                             (list-ref
                                              bid
                                              (- (table-field-number bids 'item-name) 1))))))))
          (if(not v-index)
             (insert-bid! bidder-name item-name amount)
             (mlist-replace-nth!  entries (+ v-index 1) (list bidder-name item-name amount)))
          #t))
       (else(error (string-append "Bid amount does not exceed previous highest bid: " "{\""
                           bidder-name
                           "\" \""
                           item-name
                           "\" " (number->string amount) "}")))))

(define (mindex-where lst f)
  (define (iter acc)
    (if(= acc (mlist-length lst))
       #f
       (if(f (mcar lst))
          acc
          (iter (+ acc 1)))))
  (iter 0))

;;question 8
(define (end-auction!)
  (mmap
   (lambda(item)
     (let*((item-name (car item))
           (highest-bid (get-highest-bid item-name)))
       (if(null? highest-bid)
          (printf  "No bids on ~a\n" item-name)
          (printf "Congratulations ~a! You have won the ~a for $~a\n" (car highest-bid)(cadr highest-bid)(caddr highest-bid))))
     )
   (table-entries items))
  (void)) ;;加void表示不输出

;;printf string-append

        