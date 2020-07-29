#lang racket

(require compatibility/mlist)

(define mlist-negate!
  (lambda(lst)
    (if(null? (mcdr lst))
       (set-mcar! lst (-(mcar lst)))
       (begin
         (set-mcar! lst (-(mcar lst)))
         (mlist-negate! (mcdr lst))))))

(define p (mlist 1 -2 3 0 -17))
(mlist-negate! p)
p

(define (mlist-map! f p)
       (if (null? p)
           (void)
           (begin
             (set-mcar! p (f (mcar p)))
             (mlist-map! f (mcdr p)))))

(define make-cumulative!
  (lambda(lst)
    (mlist-map! (lambda(x)
                  (* x 2))
                lst)))
(make-cumulative! p)
p

