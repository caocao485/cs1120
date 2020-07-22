#lang racket
;;;
;;; ps1.ss
;;; Name: 
;;;

(define author (list "my-uva-id" "partner-uva-id?")) ;; Replace with your UVa Email ID(s)

;;; This loads the mosaic code.  Everytime you click "Execute" it is reloaded.
(load "mosaic.ss")

;;; If you extract the images to a different place, you will need to change this:
(define path-name "J:/cs1120/ps1/images/") 

;;; Question 3: Add your color definitions:


;;; Question 4: 

(define (brighter? color1 color2)
  #f ;;; Replace this with code that determines if color1 is brighter than color 2.
     ;;; A good definition will need a few lines of code.
  )

;;; Question 5:

(define (closer-color?  ;;; The name of your function.
        sample          ;;; The average color of the rectangle you want to match.
        color1          ;;; The average color of the first tile.
        color2)         ;;; The average color of the second tile.
   #f ;;; Replace this with a Scheme expression that evaluates to #t if color1 is 
      ;;; a better match for sample, and #f otherwise.
   )
