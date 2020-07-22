#lang racket

;;; ps4.ss
;;; UVa cs1120 Fall 2011
;;; Problem Set 4
;;;

(define author (list "my-uva-id")) ;; who are you? (include all partners)

(require "lorenz.rkt")
(require "ch5-code.rkt")

;;; Remember to turn in Questions 1 and 3 on paper.  If you pass all the automatic test cases,
;;; it is not necessary to turn in your code on paper.  If you are not able to pass all the 
;;; test cases, you should turn in your code on paper.
;;question1
;;(xor a b) = (and (not (and (not a) (not b)))(not (and a b)))
								

;;; Question 2: xor-bits
(define (xor-bits x y)
  (cond((= x y)0)
       (else 1)))

;;; Question 4: string-to-baudot, baudot-to-string
(define (string-to-baudot string)
  (map char-to-baudot (string->list string)))
(define (baudot-to-string baudotcodes)
  (list->string(map baudot-to-char baudotcodes)))



;;; Question 5: rotate-wheel
(define (rotate-wheel lst)
  (list-append (cdr lst) (list (car lst))))

;;; Question 6: rotate-wheel-by
(define (rotate-wheel-by lst times)
  (if(= times 0)
     lst
    (rotate-wheel-by (rotate-wheel lst) (- times 1))))
;;; Question 7: rotate-wheel-list
(define (rotate-wheel-list wheel-list)
  (if(null? wheel-list)
     '()
     (cons (rotate-wheel (car wheel-list))
           (rotate-wheel-list (cdr wheel-list)))))

;;; Question 8: rotate-wheel-list-by
(define (rotate-wheel-list-by wheel-list times)
  (if(null? wheel-list)
     '()
     (cons (rotate-wheel-by (car wheel-list) times)
           (rotate-wheel-list-by (cdr wheel-list) times))))


;;; Question 9: wheel-encrypt
(define (wheel-encrypt letter wheels)
  (if(= (list-length letter)0)
     '()
     (cons (xor-bits (car letter)
                     (car (car wheels)))
           (wheel-encrypt (cdr letter) (cdr wheels)))))

;;; Question 10: do-lorenz
(define (do-lorenz baudotcodes kwheels swheels mwheel)
  (if(null?  baudotcodes)
     '()
     (cons (wheel-encrypt
            (wheel-encrypt (car baudotcodes) kwheels)
            swheels)
           (do-lorenz
            (cdr baudotcodes)
            (rotate-wheel-list kwheels)
            (if(= (car mwheel) 1)
               (rotate-wheel-list swheels)
               swheels)
            (rotate-wheel mwheel)))))

;;; Question 11: lorenz-encrypt
(define (lorenz-encrypt string k-p s-p m-p)
  (baudot-to-string
   (do-lorenz
    (string-to-baudot string)
    (rotate-wheel-list-by K-wheels k-p)
    (rotate-wheel-list-by S-wheels s-p)
    (rotate-wheel-by M-wheel m-p))))
    

;;; Question 12: brute-force-lorenz
(define position-list
  (list 0 1 2 3 4))
(define (generate-1-list lst)
  (map list lst)) 

(define (generate-positions lst repeat-times)
  (cond((null? lst)'(()))
       ((= repeat-times 1)(generate-1-list lst))
       (else(list-flatten
             (list-map (lambda(rlist)
                         (list-map (lambda(value)
                                     (cons value rlist))
                                   lst))
                       (generate-positions lst (- repeat-times 1)))))))
  
(define (brute-force-lorenz  f ciphertext)
  (map (lambda(start-positions)
         (f(lorenz-encrypt ciphertext
                         (car start-positions)
                         (cadr start-positions)
                         (caddr start-positions))))
       (generate-positions position-list 3)))
  

(define (for index end proc)
  (if(>= index end)
     (void) ;;this evaluates to no value
     (begin
       (proc index)
       (for(+ index 1) end proc))))

(define (while index test update proc)
  (if(test index)
     (begin
       (proc index)
       (while (update index) test update proc))
     index))

(define (loop index result test update proc)
  (if (test index)
      (loop (update index)
            (proc index result)
            test update proc)
      result))

(define (gauss-sum n)
 (loop 1 0
       (lambda (i) (<= i n))
       (lambda (i) (+ i 1))
       (lambda (index result)
         (+ index result))))

(define (factorial n)
 (loop 1 1
       (lambda (i) (<= i n))
       (lambda (i) (+ i 1))
       (lambda (index result)
         (* index result))))

(define (not-null? p) (not (null? p))) 

(define (list-length p)
 (loop p  0
         (lambda(i)(not-null? i))
         (lambda(i)(cdr i))
         (lambda(index result)
           (+ result 1))))

(define (list-accumulate f base p)
 (loop p base
       (lambda(i)(not-null? i))
       (lambda(i)(cdr i))
       (lambda(index result)
         (f (car index) result))))

(define (fib n)
  (cond((= n 0)0)
       ((= n 1) 1)
       (else
        (loop 2 1
              (lambda (i) (<= i n))
              (lambda (i) (+ i 1))
              (lambda (index result)
                (+ (fib (- index 2)) result))))))

