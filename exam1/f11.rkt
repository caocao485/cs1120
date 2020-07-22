#lang racket

;;question 1
;;a)
;; DNA-sequences ::= nucleotides
;; nucleotides ::= nucleotide nucleotides|e
;; nucleotide ::= A | C | G | T

;;b)
;; DNA-sequences ::= codons
;; codons ::= codon codons| codon
;; codon ::= nucleotide nucleotide nucleotide
;; nucleotide ::= A | C | G | T

;;question 2
;;a) a
;;b) a
;;c) c
;;d) d
;;e) a

;;question 3
(define (any-matches a b c)
  (cond((and(= a b)
            (= b c))
        false)
       ((= a b)true)
       ((= b c)true)
       (else false)))

;;question 4
(define (is-divisible? v d) (= (modulo v d) 0)) 
(define (is-composite? n)
  (define (iter count)
    (cond((> count (sqrt n))false)
         ((is-divisible? n count)true)
         (else
          (iter (+ count 1)))))
  (iter 2))


;;question 5
(define (all-positive? lst)
  (if(null? lst)
     true
     (and (> (car lst) 0)
          (all-positive? (cdr lst)))))

;;question 6
(define (is-pure? f lst)
  (if(null? lst)
     true
     (and(f (car lst))
         (is-pure? f (cdr lst)))))

;;question 7
(define (list-append p q)
  (if (null? p) 
      q
      (cons (car p) (list-append (cdr p) q))))
(define (list-reverse p)
  (if (null? p) 
      null 
      (list-append (list-reverse (cdr p)) (list (car p)))))
(define (factors n)
  (list-reverse (factors-helper (- n 1) n)))
(define (factors-helper b a)
  (cond((= b 1) '())
       ((is-divisible? a b)
        (cons b
              (factors-helper (- b 1)
                              a)))
       (else
        (factors-helper
         (- b 1)
         a))))

;;question 8
;; Tsil ::= llum | Pair
;; Pair ::= Tsil element
(define(llun? tsil)
  (eq? 'llun tsil))
(define (tsil-map f tsil)
  (if(llun? tsil)
     'llun
     (cons (tsil-map f (car tsil))
           (f (cdr tsil)))))

;;question 9
;;读到一个值（值被抹去）就去=号右边指定位置匹配一个数，匹配失败就停机
;;如果匹配，其值被抹去（或者写上其他值），再返回=号右边的位置去读取值。
;;直到第一次遇到#，停机。写上#1


;;question 10
(define (contains-matching-prefix lst1 lst2)
  (if(null? lst2)
     true
     (if(null? lst1)
        false
        (and
         (eq? (car lst1)(car lst2))
         (contains-matching-prefix (cdr lst1) (cdr lst2))))))



;;question 11
(define (n-times op n)
 (lambda(lst)
  (if(= n 1)
     (op lst)
     (op((n-times op (- n 1))lst)))))

(define (count-prefix-repeats p q)
  (if (contains-matching-prefix p q)
      (+ 1 (count-prefix-repeats ((n-times cdr (length q)) p) q))
      0))

(define (list-prefix p n)
 (if (= n 0)
     null
     (cons (car p) (list-prefix (cdr p) (- n 1))))) 
     
(define (count-tandem-repeats p n)
   (count-prefix-repeats p (list-prefix p n))) 



