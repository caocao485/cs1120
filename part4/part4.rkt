#lang racket
(define fcompose
		(lambda(f g)(lambda(x)(g (f x)))))
(define (square x)(* x x))
((fcompose square  square)3)
((fcompose (lambda (x) ( * x 2 )) (lambda (x) (/ x 2 ))) 1120 )

(define f2compose
  (lambda(f g)
    (lambda(a b)
      (g(f a b)))))

(define (factorial n)
       (if ( = n 0 )1
           ( * n (factorial ( - n 1 )))))

;;exercise 4.5
(define (choose n k)
  (if (= k 1)
      (/ (factorial n) (factorial (- n k)))
      (* (/ n k) (choose (- n 1)(- k 1)))))

(define possible
  (/ (* 4 9) (choose 52 5)))

(exact->inexact possible)

;;exercise 4.6
(define (gauss-sum num)
  (if(= num 1)
     1
     (+ num (gauss-sum (- num 1)))))
(gauss-sum 100)
;;exercise 4.7
(define  (accumulate f)
  (lambda(n)
    (if(= n 1) 1
       (f n ((accumulate f) (- n 1))))))

;;exercise 4.8
(define (find-maximum f low high)(if ( = low high)(f low)
                                     (bigger (f low) (find-maximum f ( + low 1 ) high))))
(define (bigger a b)(if(> a b) a b))
(define (biggervalue a-value  b-value f )(if (> (f a-value) (f b-value)) a-value b-value))

(define (find-maximum-epsilon fun low high epsilon)
  (if (< (abs (- high low)) 0.00001)(fun low)(bigger (fun low) (find-maximum-epsilon fun ( + low epsilon ) high epsilon))))

;;exercise 4.9
(define (find-maximum-input f low high)
  (if ( = low high)low
                                     (biggervalue low  (find-maximum-input f ( + low 1 ) high) f)))
(define inc add1)

;;exercise 4.10
(define (find-area f low high epsilon)
  (if(< (abs (- high low)) 0.000001)
     (f low high)
     (bigger (f low high)(find-area f (+ low epsilon) high epsilon))))

(define (gcd-euclid a b)(if ( = (modulo a b) 0 ) b (gcd-euclid b (modulo a b))))


;;exercise 4.13
(define (factorial-tail n)
  (define (factorial-helper count acc)
    (if(> count n)
       acc
       (factorial-helper (+ count 1)
                         (* acc count))))
  (factorial-helper 1 1))

;;exercise 4.14
(define (find-maximum-tail f low high)
  (define(iter value result)
    (if(> value high)
       result
       (iter (+ value 1)
             (bigger result (f value)))))
  (iter (+ low 1) (f low)))
;;test
(find-maximum-tail (lambda (x) ( * x ( - 10 x))) 1 20 )


(define (heron-next-guess a g) (/ ( + g (/ a g)) 2 ))
(define (heron-method a n g)(if ( = n 0 )
                                g
                                (heron-method a ( - n 1 ) (heron-next-guess a g))))

(define (find-sqrt a guesses)(heron-method a guesses 1 ))


;;Exploration 4.2
(define (compute-bool n)
  (if(odd? n)
     -1
     1))

(define (compute-pi-helper  n acc)
  (if(= n 0)
     (+ acc 1)
     (compute-pi-helper (- n 1)
                        (+ (* (compute-bool n)
                              (/ 1
                                 (* (+ (* 2 n)1)
                                    (expt 3 n))))
                           acc))))
(define pi
  (* (sqrt 12)(compute-pi-helper 1000 0)))

;;c

(define (bbp-pi k)
  (bbp-pi-helper k 0))

(define (bbp-pi-helper k acc)
  (if (< k 0)
      acc
      (bbp-pi-helper
       (- k 1)
       (+ (* (/ 1 (expt 16 k))
          (+ (/ 4 (+ (* 8 k) 1))
             (- (/ 2(+ (* 8 k) 4)))
             (/ 1 (+ (* 8 k) 5))
             (-(/ 1 (+ (* 8 k) 6)))))
          acc))))

          