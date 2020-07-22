#lang racket
;;;
;;; UVa CS1120 Problem Set 3
;;; Fall 2011
;;;

;; #lang racket
(require (lib "graphics.ss" "graphics")) ;;; Load the graphics library
(require (lib "trace.ss"))
(provide (all-defined-out))
;; (provide (all-defined-out))

;;;
;;; Constants
;;;

(define window-width 600)  ;;; Display window width
(define window-height 600) ;;; Display window height

;;; Angles

(define my_pi/4 (atan 1 1))
(define my_pi (* 4 my_pi/4))
(define my_-pi (- my_pi))
(define my_2pi (* 2 my_pi))

;;;
;;; Points
;;;

(define (make-point x y) (list x y))

(define (make-color r g b)
  (make-rgb (exact->inexact (/ r 256))
	    (exact->inexact (/ g 256))
	    (exact->inexact (/ b 256))))

(define (make-colored-point x y c) (list x y c))

(define (x-of-point point) (car point))
(define (y-of-point point) (cadr point))

(define (is-colored-point? point) (= (length point) 3))

;;; Regular points are black.  Colored points have a color.
(define (color-of-point point)
  (if (is-colored-point? point)
      (caddr point) 
      (make-color 0 0 0)))

(define (show-point point)
  (if (is-colored-point? point)
      (list (x-of-point point) (y-of-point point) (color-of-point point))
      (list (x-of-point point) (y-of-point point))))
      
;;;
;;; Drawing a curve
;;;

(define (draw-curve-points curve n)
  (define (worker t step)
    (if (<= t 1.0)
	(begin (window-draw-point (curve t))
	       (worker (+ t step) step))
        0))
  (worker 0.0 (/ 1 n)))

(define (draw-curve-connected curve n)
  (define (worker t step)
    (if (<= t 1.0)
	(begin (window-draw-line (curve t) (curve (+ t step)))
	       (worker (+ t step) step))
        0))
  (worker 0.0 (/ 1 n)))

;;;
;;; Some simple curves
;;;;

(define (mid-line t) (make-point t 0.5))
(define (unit-circle t) (make-point (sin (* my_2pi t)) (cos (* my_2pi t))))
(define (unit-line t) (make-point t 0.0))
(define (vertical-line t) (make-point 0.0 t))
(define (horiz-line t) (make-point t 0))

;;;
;;; Functions for transforming curves into new curves.
;;;

(define (translate curve x y)
  (lambda (t)
    (let ((ct (curve t)))
      (make-colored-point
       (+ x (x-of-point ct))
       (+ y (y-of-point ct))
       (color-of-point ct)))))

(define (rotate-ccw curve)
  (lambda (t)
    (let ((ct (curve t)))
      (make-colored-point
       (y-of-point ct)
       (x-of-point ct)
       (color-of-point ct)))))

(define (flip-vertically curve)
  (lambda (t)
    (let ((ct (curve t)))
      (make-colored-point
       (* -1 (x-of-point ct))
       (y-of-point ct)
       (color-of-point ct)))))

(define (shrink curve scale)
  (lambda (t)
    (let ((ct (curve t)))
      (make-colored-point
       (* scale (x-of-point ct))
       (* scale (y-of-point ct))
       (color-of-point ct)))))

(define (first-half curve)
  (lambda (t) (curve (/ t 2))))

(define (fcompose f g)
  (lambda (x) (f (g x))))

(define (n-times proc n)
  (if (= n 1) proc
        (fcompose proc (n-times proc (- n 1)))))

(define rotate-cw (fcompose rotate-ccw flip-vertically))

(define (degrees-to-radians degrees)
  (/ (* degrees my_pi) 180))

;;;
;;; rotate-around-origin counterclockwise by theta degrees
;;; (No need to worry about the geometry math for this.)
;;;

(define (rotate-around-origin curve theta)
  (let ((cth (cos (degrees-to-radians theta)))
        (sth (sin (degrees-to-radians theta))))
    (lambda (t)
      (let ((ct (curve t)))
	(let ((x (x-of-point ct))
	      (y (y-of-point ct)))
	  (make-colored-point
	   (- (* cth x) (* sth y))
	   (+ (* sth x) (* cth y))
	   (color-of-point ct)))))))

;;;
;;; Scale a curve
;;;

(define (scale-x-y curve x-scale y-scale)
  (lambda (t)
    (let ((ct (curve t)))
      (make-colored-point 
       (* x-scale (x-of-point ct))
       (* y-scale (y-of-point ct))
       (color-of-point ct)))))

(define (scale curve s) (scale-x-y curve s s))

;;; squeeze-rectangular-portion translates and scales a curve
;;; so the portion of the curve in the rectangle
;;; with corners xlo xhi ylo yhi will appear in a display window
;;; which has x, y coordinates from 0 to 1.

(define (squeeze-rectangular-portion curve xlo xhi ylo yhi)
  (scale-x-y (translate curve (- xlo) (- ylo))
	     (/ 1 (- xhi xlo))
	     (/ 1 (- yhi ylo))))

;;;
;;; put-in-standard-position transforms a curve so that it starts at
;;; (0,0) ends at (1,0).
;;;
;;; A curve is put-in-standard-position by rigidly translating it so its
;;; start point is at the origin, then rotating it about the origin to put
;;; its endpoint on the x axis, then scaling it to put the endpoint at (1,0).

(define (put-in-standard-position curve)
  (let* ((start-point (curve 0 (color-of-point curve)))
         (curve-started-at-origin
          (((translate (- (x-of-point start-point))
		       (- (y-of-point start-point)))
	    curve)))
         (new-end-point (curve-started-at-origin 1))
         (theta (atan (y-of-point new-end-point) (x-of-point new-end-point)))
         (curve-ended-at-x-axis
          ((rotate-around-origin (- theta)) curve-started-at-origin))
         (end-point-on-x-axis (x-of-point (curve-ended-at-x-axis 1))))
    ((scale (/ 1 end-point-on-x-axis)) curve-ended-at-x-axis)))

;;;
;;; connect-rigidly makes a curve consisting of curve1 followed by curve2.
;;;

(define (connect-rigidly curve1 curve2)
  (lambda (t)
      (if (< t (/ 1 2))
          (curve1 (* 2 t))
          (curve2 (- (* 2 t) 1)))))

;;;
;;; connect-ends
;;;

(define (connect-ends curve1 curve2)
  (lambda (t)
    (if (< t (/ 1 2))
	(curve1 (* 2 t))
	((translate curve2 
		   (x-of-point (curve1 1)) (y-of-point (curve1 1))) (- (* 2 t) 1)))))

;;; (get-nth lst n) evaluates to the nth element in lst
(define (get-nth lst n)
  (if (= n 0) (car lst) (get-nth (cdr lst) (- n 1))))

;;; 
;;; (connect-curves-evenly curvelist)
;;; evaluates to a single curve made by connecting all the curves in curvelist
;;; in a way that will distribute all the t values evenly between all the curves.
;;;

(define (connect-curves-evenly curvelist)
  (lambda (t)
    (let ((which-curve
	   (if (>= t 1.0) (- (length curvelist) 1)
	       (inexact->exact (floor (* t (length curvelist)))))))
      ((get-nth curvelist which-curve)
       (* (length curvelist)
	  (- t (* (/ 1 (length curvelist)) which-curve)))))))

;;;
;;; (cons-to-curvelist curve curvelist)
;;; evaluates to a list of curves that starts with curve and continues
;;; with the curves in curvelist, translated to begin where curve ends
;;;

(define (cons-to-curvelist curve curvelist)
  (let ((endpoint (curve 1.0))) ;; The last point in curve
    (cons curve
	  (map (lambda (thiscurve)
		 (translate thiscurve (x-of-point endpoint) (y-of-point endpoint)))
	       curvelist))))

;;;
;;; These procedures find the extents of a curve, so we can scale it to the window:
;;;

(define (find-extreme-point curve point-selector comparison n)
  (define (worker t best-so-far step)
    (if (> t 1.0)
	;; check 1.0
	(if (comparison (point-selector (curve 1.0)) best-so-far)
	    (point-selector (curve 1.0))
	    best-so-far)
	(if (or (not best-so-far) (comparison (point-selector (curve t)) best-so-far))
	    (worker (+ t step) (point-selector (curve t)) step)
	    (worker (+ t step) best-so-far step))))
  (worker 0.0 #f (/ 1 n)))

(define (find-leftmost-point curve n)
  (find-extreme-point curve x-of-point < n))

(define (find-rightmost-point curve n)
  (find-extreme-point curve x-of-point > n))

(define (find-lowest-point curve n)
  (find-extreme-point curve y-of-point < n))

(define (find-highest-point curve n)
  (find-extreme-point curve y-of-point > n))

;;; We add and subtract the .1's to make it not go quite to the edge of the window.
;;; (Perhaps these should scale instead...)

(define (position-curve curve startx starty)
  (let ((tcurve (translate curve startx starty))
	(num-points 1000)) ;;; How many points to evaluate
    (let ((xlo (find-leftmost-point tcurve num-points))
	  (xhi (find-rightmost-point tcurve num-points))
	  (ylo (find-lowest-point tcurve num-points))
	  (yhi (find-highest-point tcurve num-points)))
      (let ((xlowscale (if (< xlo 0.01) 
			   (/ (- startx 0.01)
			      (- startx xlo))
			   1.0))
	    (xhighscale (if (> xhi 0.99) 
			    (/ (- 0.99 startx)
			       (- xhi startx))
			    1.0))
	    (ylowscale   (if (< ylo 0.01) 
			     (/ (- starty 0.01)
				(- ylo starty))
			     1.0))
	    (yhighscale   (if (> yhi 0.99) 
			      (/ (- 0.99 starty)
				 (- yhi starty))
			      1.0)))
	(let
	    ((minscale  (min xlowscale xhighscale ylowscale yhighscale)))
	  (translate (scale-x-y curve minscale minscale) startx starty))))))

;;;
;;; Window procedures
;;;

(define (make-window width height name) (open-viewport name width height))
(define (close-window window) (close-viewport window))
(define (clear-window) ((clear-viewport window)))

;;;
;;; We need to convert a position in a (0.0, 0.0) - (1.0, 1.0) coordinate
;;; system to a position in a (0, window-height) - (window-width, 0) coordinate
;;; system.  Note that the Viewport coordinates are upside down.
;;;

(define (convert-to-position point)
  (check-valid-point point)
  (make-posn (* (x-of-point point) window-width)
	     (- window-height (* window-height (y-of-point point)))))

;;; Passed values are in the unit (0.0, 0.0) - (1.0, 1.0) coordinate system.

;;; This procedure just prints a warning if a point is out of range
(define (check-valid-point point)
  (let ((x (x-of-point point))
	(y (y-of-point point)))
    (if (or (< x 0.0) (> x 1.0))
	(printf "Warning: point x coordinate is out of range (should be between 0.0 and 1.0): ~a~n" x) 0)
    (if (or (< y 0.0) (> y 1.0)) 
	(printf "Warning: point y coordinate is out of range (should be between 0.0 and 1.0): ~a~n" y) 0)))

(define (window-draw-point point)
  ((draw-pixel window) (convert-to-position point) (color-of-point point)))

;;; Draw a line on window from (x0, y0) to (x1, y1)

(define (window-draw-line point0 point1)
  ((draw-line window) ;;; evaluates to function for drawing on window
   (convert-to-position point0)
   (convert-to-position point1)))

;;;
;;; Set up a graphics window
;;;

(close-graphics)
(open-graphics)

;;; This window is hard coded into the drawing routines, so we don't need to remember
;;; to pass it.

(define window (make-window window-width window-height "Phunctional Phraktals"))

;;; Use (save-file <filename>) to save the current display window in 
;;; and image file.  The filename can be either a .png file or
;;; a .jpg file.
;;;
;;; Don't worry about understanding this code (unless you really want to).

(define (save-image fname)
  (cond ((or (equal? (filename-extension fname) #"png")
             (equal? (filename-extension fname) #"PNG"))
         (send (send (viewport->snip window) get-bitmap) save-file fname 'png))
        ((or (equal? (filename-extension fname) #"jpg")
             (equal? (filename-extension fname) #"JPG"))
         (send (send (viewport->snip window) get-bitmap) save-file fname 'jpg 90))
        (else (error "Filename must end in either .png or .jpg"))))


;;;
;;; Abstraction for representing L-System Commands using lists.

;;; CommandSequence ::= (CommandList)
(define make-lsystem-command list)

;;;
;;; We represent the different commands as lists where the first
;;; item in the list is a tag that indicates the type of command: 
;;;   'f for forward, 'r for rotate, and 'o for offshoot.  
;;; We use quoted letters --- 'f is short for
;;; (quote f) --- to make tags - they evaluate to the letter after the quote.
;;;

;;; Command ::= F
(define (make-forward-command) 
  (cons 'f #f)) ;; No value, just use false.

;;; Command ::= R <Angle>
(define (make-rotate-command angle) 
  (cons 'r angle))

;;; Command ::= O <CommandSequence>
(define (make-offshoot-command commandsequence) 
  (cons 'o commandsequence))

;;question5
(define (is-forward? lcommand)
  (eq? (car lcommand) 'f))
(define (is-rotate? lcommand)
  (eq? (car lcommand) 'r))
(define (is-offshoot? lcommand)
  (eq? (car lcommand) 'o))

(define (get-angle lcommand)
  (if(not(is-rotate? lcommand))
     (error "Yikes! Attempt to get-angle for a command that is not an angle command")
     (cdr lcommand)))
(define (get-offshoot-commands lcommand)
  (if(not(is-offshoot? lcommand))
     (error "Yikes! Attempt to get-offshoot-commands for a command that is not an offshoot command")
     (cdr lcommand)))

(define (is-lsystem-command? lcommand)
  (or (is-forward? lcommand)
      (is-rotate? lcommand)
      (is-offshoot? lcommand)))

;;;
;;; Three example lsystems for you to play with. 

(define f
  (make-lsystem-command 
    (make-forward-command) 
  ))

(define f-r30-f 
  (make-lsystem-command 
    (make-forward-command) 
    (make-rotate-command 30)
    (make-forward-command) 
  ))

(define f-f-r30
  (make-lsystem-command 
    (make-forward-command) 
    (make-forward-command) 
    (make-rotate-command 30)
  ))

;;question 6
(define (rewrite-lcommands lcommands replacement)
  (flatten-commands
   (map 
    (lambda(command) ; Fill this in with procedure to apply to each command
      (cond((is-forward? command)replacement)
           ((is-rotate? command)command)
           ((is-offshoot? command)(make-offshoot-command(rewrite-lcommands ;;bug need make-offshoot-command
                                   (get-offshoot-commands command)
                                   replacement)))
           (else(error "error command"))))
                                   
   lcommands)))

;;;
;;; Flattening Command Lists

(define (flatten-commands ll)
  (if (null? ll) 
      ll
      (if (is-lsystem-command? (car ll))
	  (cons (car ll) (flatten-commands (cdr ll)))
	  (flat-append (car ll) (flatten-commands (cdr ll))))))

(define (flat-append lst ll)
  (if (null? lst) ll
      (cons (car lst) (flat-append (cdr lst) ll))))



;;; 
;;; L-System commands for the tree fractal
;;; F1 ::= (F1 O(R30 F1) F1 O(R-60 F1) F1) 

(define tree-commands
  (make-lsystem-command 
   (make-forward-command)
   (make-offshoot-command
    (make-lsystem-command
     (make-rotate-command 30) 
     (make-forward-command)))
   (make-forward-command)
   (make-offshoot-command
    (make-lsystem-command
     (make-rotate-command -60) 
     (make-forward-command)))
   (make-forward-command)))

(define (make-tree-fractal level)
  (make-lsystem-fractal 
   tree-commands 
   (make-lsystem-command (make-forward-command)) level))

(define (make-lsystem-fractal replace-commands commands level)
  ((n-times
   (lambda(lcommands)
     (rewrite-lcommands lcommands replace-commands))
   level)commands))

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
           (convert-lcommands-to-curvelist (get-offshoot-commands(car lcommands)))
           (convert-lcommands-to-curvelist (cdr lcommands))
           ))
        (#t (error "Bad lcommand!"))))

(define (draw-lsystem-fractal lcommands)
  (draw-curve-points 
   (position-curve
    (connect-curves-evenly
     (convert-lcommands-to-curvelist lcommands)) 
    0.5 0.1)
   50000))