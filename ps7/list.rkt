#lang racket

(define list-get-element  (lambda(p n) (if(= n 1)(car p) (list-get-element (cdr p)(- n 1)))))


(define cons (lambda(x y)(lambda(m)(m x y))))
(define car (lambda(z)(z(lambda(p q)p))))
(define cdr (lambda(z)(z(lambda(p q)q))))

(define true (lambda(p q)p))
(define false (lambda(p q)q))
(define ifp (lambda(p a b)(p a b)))
(define null false)
(define null? (lambda (x) ( = x false)))

(define ints-from (lambda (n) (cons n (ints-from ( + n 1 )))))

(car (ints-from 1 ))

(car (cdr (cdr (cdr (ints-from 1 )))))

(define list-length(lambda (lst) (if (null? lst) 0 ( + 1 (list-length (cdr lst))))))

(define fibo-gen (lambda (a b) (cons a (fibo-gen b ( + a b)))))
(define fibos (fibo-gen 0 1 ))

(define fibo(lambda (n)(list-get-element fibos n)))

(define merge-lists (lambda (lst1 lst2 proc)(if (null? lst1) null (if (null? lst2) null(cons (proc (car lst1) (car lst2))(merge-lists (cdr lst1) (cdr lst2) proc))))))
;;parse("(define merge-lists (lambda (lst1 lst2 proc)(if (null? lst1) null (if (null? lst2) null(cons (proc (car lst1) (car lst2))(merge-lists (cdr lst1) (cdr lst2) proc))))))")

;;练习1
(define fact-gen (lambda (a  acc) (cons (* acc a) (fact-gen (+ a 1) (* a acc)))))
(define facts (fact-gen 1 1 ))
(define fact(lambda (n)(list-get-element facts n)))


;;练习2
(define p (cons 1 (merge-lists p p + ))) ;;1 2 4 8
(define t (cons 1 (merge-lists t (merge-lists t t + ) + ))) ;;1 3 9 27 
(define twos (cons 2 twos)) 
;;2 2 2 
(define doubles (merge-lists (ints-from 1 ) twos *)) ;;2 4 6 8 10 
(car (merge-lists (ints-from 1) twos *))
(car(cdr(cdr (merge-lists (ints-from 1) twos *)))) 
(list-get-element (cons 2 (merge-lists (ints-from 2) twos *)) 4)

;;练习3
(define list-filter (lambda(test p)(if (null? p) null(if (test (car p))(cons (car p) (list-filter test (cdr p)))(list-filter test (cdr p))))))
(define same (lambda(n)(cons n (same n))))
(define not (lambda(value)(if value false true)))
(define divisible? (lambda(x y)(= (remainder x y)0)))
(define remainder (lambda(x y)(if(= x 0)0 (if(< x y)x (remainder (- x y) y)))))
(define sieve (lambda(stream)(cons (car stream) (sieve (list-filter (lambda(x)(not (divisible? x (car stream))))(cdr stream))))))

(define primes (sieve (ints-from 2)))
(car (cdr (cdr primes)))
;;(list-get-element primes 50)

(define fact (lambda(n)(if(= n 1)1(* n (fact (- n 1))))))
