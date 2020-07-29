#lang racket
(require compatibility/mlist)
;;1
;; 


;;2
;; ByteExpression ::=> 1 ByteExpression | 0 EndExpression
;; EndExpression ::=> ByteExpression 0 | e


(define collatz
  (lambda(n)
    (if(= n 1)
       (list 1)
       (if(even?  n)
          (cons n (collatz (/ n 2)))
          (cons n (collatz (+ (* n 3) 1)))))))

(define mlist-negate-every-other!
    (lambda(lst)
  (define mlist-negate!
  (lambda(lst)
    (if(null? (mcdr lst))
       (set-mcar! lst (-(mcar lst)))
       (begin
         (set-mcar! lst (-(mcar lst)))
         (mlist-negate! (mcdr lst))))))

    (set-mcar! lst (- (mcar lst)))
    (mlist-negate! (mcdr (mcdr lst)))))

(define make-maxilative!
  (lambda(lst)
    (let ((max-value 0))
      (define (cf n)
        (if(>= max-value n)
           max-value
           (begin
             (set! max-value n)
             n)))
      (mlist-map! cf lst))))
      
(define (mlist-map! f p)
       (if (null? p)
           (void)
           (begin
             (set-mcar! p (f (mcar p)))
             (mlist-map! f (mcdr p)))))