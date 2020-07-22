#lang racket
(require racket/mpair)
(require racket/trace)

(define (update-counter!)
  (set! counter (+ counter 1))
  counter)

(define counter 0)

(define pair (mcons 1 2))
(set-mcar! pair 3)
(set-mcdr! pair 4)
pair

(define m1 (mlist 1 2 3))
(set-mcar! (mcdr m1) 5)
(set-mcar! (mcdr (mcdr m1))0)
m1

(define (mlist-length m)
  (if(null? m)0 (+ 1(mlist-length (mcdr m)))))


;;Exercise 9.5
(define (mpair-circular? pair)
  (let((slower-pair pair)
       (faster-pair pair))
    (define (iter slower faster)
      (cond
        ((or(null? slower)
            (null? faster)
            (null? (mcdr faster)))
            false)
        ((or(equal? slower faster)
            (equal? slower (mcdr faster)))
         true)
        (iter (mcdr slower) (mcdr (mcdr faster)))))
    (iter slower-pair faster-pair)))

(set-mcdr! pair pair)
(mpair-circular?  pair)
pair


(define (mlist-map! f p)
  (if(null? p)(void)
     (begin(set-mcar! p (f (mcar p)))
           (mlist-map! f (mcdr p)))))

(define (mlist-filter! test p)
  (if(null? p)null
     (begin (set-mcdr! p (mlist-filter! test (mcdr p)))
            (if(test(mcar p)) p(mcdr p)))))
(define a (mlist 1 2 3 1 4))
(mlist-filter! (lambda(x)(> x 1)) a)
a
(set! a (mlist-filter!
         (lambda(x)(> x 1))
         a))

(define (mlist-append! p q)
  (if(null? p)(error "Cannot append to an empty list")
     (if(null? (mcdr p)) (set-mcdr! p q)
        (mlist-append!(mcdr p)q))))

;;alaising
(define m3 (mlist 1 2 3))
(define m2 (mlist 4 5 6))
(mlist-append! m1 m2)
(set! m3 (mlist-filter! (lambda(el)
                         (= (modulo el 2)0))
                       m3))
m3

;;Exercise 9.6 
(define (mlist-inc! p)
  (mlist-map! add1 p))

;;Exercise 9.7
(define (mlist-truncate! p1 )
  (if(null?(mcdr(mcdr p1)))
     (set-mcdr! p1 '())
     (mlist-truncate! (mcdr p1))))

;;Exercise 9.8
(define (mlist-make-circular! p)
  (let((initial-value p))
    (define (iter p1)
      (if(null? (mcdr p1))
         (set-mcdr! p1 initial-value)
         (iter (mcdr p1))))
    (iter p)))

;;m2
;;(mlist-make-circular! m2)
;;m2

;;Exercise 9.9
(define (mlist-reverse-interval! p)
  (if(null? (mcdr p))
     p
     (let((rest(mlist-reverse-interval! (mcdr p))))
       (set-mcdr! p null)
       (mlist-append! rest p)
          rest)))
(define (mlist-reverse! p)
  (if(null? (mcdr p))
     p
  (let((car-value(mcar p))
       (p1 (mlist-reverse-interval! (mcdr p))))
    (mlist-append! p1 (mlist car-value))
    (set-mcar!  p (mcar p1))
  (set-mcdr! p (mcdr p1)))))

m1
;;(trace mlist-reverse!)
(mlist-reverse! m1)
m1
;;(1 2 3)
;;(2 3)



;;Exercise 9.10
(define (mlist-aliases? p1 p2)
  (if(or(null? p1)(null? p2))
     false
     (if(eq? (mcar p1)(mcar p2))
        true
        (mlist-aliases? (mcdr p1)(mcdr p2)))))


;;(set-mcar! m2 2)
;;(set-mcar! m3 2)

;;(mlist-aliases? m2 m3)

(define (while test body)
       (if(test)
          (begin(body)(while test body))
          (void))) ;;no result value

(define (fibo-while n)
  (let ((a 1)(b 1))
    (while (lambda()(> n 2))
           (lambda()
             (let ((oldb b))
             (set! b (+ a b))
             (set! a oldb)
             (set! n (- n 1)))))
    b))


;;Exercise 9.11
(define (mlist-map-while! f lst)
  (while (lambda()(not(null? lst)))
         (lambda()
           (set-mcar! lst (f (mcar lst)))
           (set! lst (mcdr lst)))))
m2
(mlist-map-while! (lambda(x)(+ x 2)) m2)
m2

;;Exercise 9.12
(define (factorial n)
  (let ((fact 1))
    (repeat-until
     (lambda()(set! fact (* fact n))(set! n (- n 1)))
     (lambda()(< n 1)))
    fact))
(define (repeat-until body test)
  (body)
  (if(not (test))
     (repeat-until  body test)
     (void)))

;;Exercise 9.13
(define (count-tandem-repeats p n)
  (count-prefix-repeats p (list-prefix p n)))
(define (list-prefix p n)
  (if(= n 0)null
     (cons (car p)(list-prefix (cdr p) (- n 1)))))

(define (count-prefix-repeats p q)
  (if(cotains-matching-prefix p q)
     (+ 1 (count-prefix-repeats ((n-times cdr (length q))p)q))
     0))

(define (cotains-matching-prefix p q)
  (or(null? q)
     (and(eq?(car p)(car q))
         (cotains-matching-prefix (cdr p)(cdr q)))))

(define (n-times f n)
  (if(= n 1)
     f
     (compose f
              (n-times f (- n 1)))))


(define (list-append p q)
  (if (null? p) q
      (cons 
       (car p)
       (list-append (cdr p) q))))

(define p1 (make-list 100000 1))
(define p2 (make-list 100000 1))
(time(begin (list-append p1 p2)(void)))

