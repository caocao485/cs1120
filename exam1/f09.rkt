#lang racket

;;question 1
;; Name ::= No-digit Characters
;; No-digit ::= letter | special-character
;; Characters ::=  Character Characters | e
;; Character ::= letter| special-character | digit


;;question 2
;;a) 2
;;b) <procedure primitive:car>
;;c) '()
;;d) <procedure >
;;e) 3


;;question 3
(define (list-increment lst)
  (map add1 lst))


;;question 4
(define (list-combiner lst1 lst2)
  (if(not(= (length lst1)
            (length lst2)))
     (error "two input list have  different lengths")
     (if(null? lst1)
        '()
        (cons (cons
               (car lst1)
               (car lst2))
              (list-combiner
               (cdr lst1)
               (cdr lst2))))))

;;question 5
;;n times

;;question 6
;;n^2 times

;;question 7


;;question 8
(define (count-repeats lst)
  (define (iter count prev restlist)
    (cond((null? restlist)count)
         ((not(eq? prev (car restlist)))
          (if(= count 0)
             (count-repeats (cdr lst))
             count))
         (else(iter (+ count 1)
                    prev (cdr restlist)))))
  (if(null? lst) 0
     (iter 0 (car lst) (cdr lst))))

;;question 9
;; n times


;; question 10
(define (list-filter test p)
  (if (null? p) 
      null
      (if (test (car p))
          (cons (car p) (list-filter test (cdr p)))
          (list-filter test (cdr p)))))
(define (count-unique lst)
  (if(null? lst)0
     (+ 1
        (count-unique
         (list-filter
          (lambda(v)
            (not(eq? v (car lst))))
          (cdr lst))))))

;;question 11
;; n^2 times
