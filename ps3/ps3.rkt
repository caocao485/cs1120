#lang racket
;;;
;;; UVA CS1120 Problem Set 3
;;; Fall 2011
;;;

(require "lsystem.rkt")
(define author (list "")) ;; who are you? (use your UVa email id)

;;; Don't forget to turn in your answers to Questions 1-4.  You can write them as comments 
;;; here, or one a separate sheet of paper that you attach (with a staple or similarly effective
;;; paper-binding technology) to the printout you turn in.

;;; Question 5: define is-forward?, is-rotate?, is-offshoot?, get-angle, and get-offshoot-commands

;;; Question 6: rewrite-lcommands

(define (rewrite-lcommands lcommands replacement)
  (flatten-commands
   (map 
    (lambda(command) ; Fill this in with procedure to apply to each command
      (cond((is-forward? command)replacement)
           ((is-rotate? command)command)
           ((is-offshoot? command)(rewrite-lcommands
                                   (get-offshoot-commands command)
                                   replacement))
           (else(error "error command"))))
                                   
   lcommands)))

;;; Question 7:

; a. Define vertical-mid-line
(define (vertical-mid-line t)
  (make-point 0.5 t))

; b. Define make-vertical-line

(define (make-vertical-line horizontal-value)
  (lambda(t)
    (make-point horizontal-value t)))

;;; Question 8: half-line
(define half-line (shrink (translate horiz-line 1 1) 0.5))
;;(draw-curve-points half-line 1000) 
;;; Question 9: num-points

(define (num-points p n) 
  ; p is the number of t-value points left; n is the number of curves left
   ;; replace with your definition
  (/ p (expt 2 (- n 1)))
  )


;;; Questions 10 and 11:

(define (convert-lcommands-to-curvelist lcommands)
  (cond ((null? lcommands)
	  (list (lambda (t) 
                   ;;; A leaf is just a point. 
		   (make-colored-point 0.0 0.0 (make-color 0 255 0)))))
        ((is-forward? (car lcommands))
	  (cons-to-curvelist
	     vertical-line
	     (convert-lcommands-to-curvelist (cdr lcommands))))
	((is-rotate? (car lcommands))
	       ;;; If this command is a rotate, every curve in the rest 
	       ;;; of the list should should be rotated by the rotate angle
	  (let
	      ;; L-system turns are clockwise, so we need to use - angle
	      ((rotate-angle (- (get-angle (car lcommands)))))
	       (map
		(lambda (curve)
		  (rotate-around-origin 
                   ;;; Question 10: fill this in
                   curve
                   rotate-angle
                   )
                  ;;; Question 10: fill this in
		)
                (convert-lcommands-to-curvelist (cdr lcommands)))))
	((is-offshoot? (car lcommands))
	  (append
           ;;; Question 11: fill this in
           (convert-lcommands-to-curvelist (car lcommands))
           (convert-lcommands-to-curvelist (cdr lcommands))
           ))
        (#t (error "Bad lcommand!"))))

;;; Question 12: make-lsystem-fractal

;;; Question 13: remember to submit your best fractal image

