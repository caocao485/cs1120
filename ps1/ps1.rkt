#lang racket
;;;
;;; ps1.ss
;;; Name: 
;;;

(define author (list "my-uva-id" "partner-uva-id?")) ;; Replace with your UVa Email ID(s)

;;; This loads the mosaic code.  Everytime you click "Execute" it is reloaded.
(require "mosaic.rkt")

;;; If you extract the images to a different place, you will need to change this:


;;; Question 3: Add your color definitions:
(define orange (make-color 255 165 0))
;;(show-color orange)

;;; Question 4: 

(define (brighter? color1 color2)
  ;;; Replace this with code that determines if color1 is brighter than color 2.
     ;;; A good definition will need a few lines of code.
  (>  (+ (get-red color1)
         (get-green color1)
         (get-blue color1))
      (+ (get-red color2)
         (get-green color2)
         (get-blue color2)))
  )

;;; Question 5:
(define (square x)(* x x))

(define (closer-color?  ;;; The name of your function.
        sample          ;;; The average color of the rectangle you want to match.
        color1          ;;; The average color of the first tile.
        color2)         ;;; The average color of the second tile.
    ;;; Replace this with a Scheme expression that evaluates to #t if color1 is 
      ;;; a better match for sample, and #f otherwise.
  (let ((diff1(/  (- 255  (* (abs (- (get-red color1) (get-red sample))) 0.297)
                      (* (abs (- (get-green color1)(get-green sample))) 0.593)
                      (* (abs  (- (get-blue color1) (get-blue sample))) 0.11))
                  255))
        (diff2(/  (- 255  (* (abs (- (get-red color2) (get-red sample))) 0.297)
                      (* (abs (- (get-green color2)(get-green sample))) 0.593)
                      (* (abs  (- (get-blue color2) (get-blue sample))) 0.11))
                  255)))
    (> diff1 diff2))
  )
