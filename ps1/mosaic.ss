#lang racket

;;;
;;; mosaic.ss
;;;    Version 1.0.9
;;; 
;;; UVA CS1120
;;; Problem Set 1
;;; 

(require file)                 ;;; We use this for filename-extension
(require (lib "trace.rkt"))                ;;; Useful for debugging
(require (lib "graphics.rkt" "graphics"))  ;;; For displaying colors

(open-graphics)
  
;;; 
;;; Pathname Constnts
;;;

;;; URL Prefix for where the tile images are:
(define tile-prefix "http://www.cs.virginia.edu/cs1120/ps/ps1/images/tiles/")

;;; URL Prefix for where the link (big) images are:
(define link-prefix "http://www.cs.virginia.edu/cs1120/ps/ps1/images/big/")

;;; This gives a rough bound on the number of samples taken for each tile image.
;;; A higher number improves the quality of the sampling, but increases the 
;;; evaluation time.
;;;
;;; Around 20 seems to be plenty.  For slow machines, try lowering this.

(define num-samples 20)

;;;
;;; Loading tile images
;;;

(define (get-one-image filename)  
  (list filename (make-object bitmap% filename)))

;;; is-image? filename - evaluates to true if filename is the name of an image type file

(define (is-image? filename) 
  (let ((ext (filename-extension filename)))
    (or (equal? ext #"jpg") (equal? ext #"JPG")
	(equal? ext #"gif") (equal? ext #"GIF")
	(equal? ext #"bmp") (equal? ext #"BMP"))))
	
;;; get-image-names directory - evaluates to a list of (filename bitmap) lists for each 
;;;                        filename in directory that is an image.

(define (get-image-names directory)
  (begin
    (current-directory directory) ;;; enter the images directory
    ;; filter applies a function to every element of a list and evaluates
    ;;    to a list containing only thoses elements of the original list
    ;;    for which the function applied to the element evaluates to true (#t).
    ;; So, this produces a list of all files in the directory for which 
    ;; is-image? is true.
    (filter is-image? (directory-list))))

(define (load-images image-names) 
  (printf "Loading ~a images..." (length image-names))
  (map get-one-image image-names))

;;;
;;; Creates an open file for displaying tiles
;;;

(define (produce-tiles-page output-filename image-list tile-width tile-height)
  (call-with-output-file output-filename
    (lambda (output-file)
      (printf "Creating photomosaic in ~a...~n" output-filename)
      (display-tiles-page output-file image-list tile-width tile-height))))
    
;;;
;;; display-tiles takes:
;;;    output-file         - output file
;;;    tiles               - the tiles for the mosaic (a list of image filenames for each row)
;;;    tile-width          - display width of each tile
;;;    tile-height         - display height of each tile
;;;

(define (display-tiles-page output-file tiles tile-width tile-height)
  (print-page-header output-file)              
  (display-tiles output-file tiles tile-width tile-height)
  (print-page-footer output-file))

(define (display-tiles output-file tiles tile-width tile-height)
  (map (lambda (row) (display-one-row output-file row tile-width tile-height)) tiles))

(define (print-page-header fout)
  (fprintf fout "<html><title>CS1120 Photomosaic</title><body bgcolor=\"black\">~n")
  (fprintf fout "<table cellspacing=1 cellpadding=0 align=center>"))

(define (print-page-footer fout)
  (fprintf fout "</table>~n</body></html>~n"))

(define (display-one-row output-file row tile-width tile-height)
  (fprintf output-file "<tr valign=center>~n")
  (map (lambda (tile) (display-one-tile output-file tile tile-width tile-height)) row)
  (fprintf output-file "~n</tr>"))

(define (display-one-tile output-file tile-name tile-width tile-height)
  (fprintf output-file "<td valign=center align=center>~n")
  (fprintf output-file "<a href=\"~a~a\"><img src=\"~a~a\" width=~a height=~a border=0></a></td>~n" 
	   link-prefix tile-name tile-prefix tile-name tile-width tile-height))

(define (calculate-average-colors image-list)
  (map-safe average-color image-list))

;;;
;;; Generate pixel points to sample an area
;;;

(define (generate-sample-points startx starty width height num-points)
  ;;; Generate list (((x0 y0) (x1 y0) ... (xn y0)) 
  ;;;                ((x0 y1) ...               ))
  ;;;                ...
  ;;;                (((x_0 y_m)) ...     (x_n y_m)))
  ;;; of points to sample in a region from (startx, starty) to
  ;;; (startx + width, starty + height). 

  ;;; num-points is a rough guide to the number of points to sample, but
  ;;; generate-sample-points may return more or fewer.
  
  (let* ((spacing (max 1 (/ width (sqrt num-points)))) ;;; can't be less than 1
	 (height-spacing (max 1 (/ (* spacing height) width))))
    (generate-sample-points-worker startx starty startx starty 
                                   width height spacing spacing '())))

(define (generate-sample-points-worker 
         startx starty                   ;;; Where we started
         curx cury                       ;;; Where we are now
         width height                    ;;; Area to sample
         xspacing yspacing               ;;; Space between samples
         points)                         ;;; List of sample points so far
  (if (>= (round cury) (+ height starty)) points ;;; done
      (if (>= (round curx) (+ width startx))
	  ;;; move down to the next row
	  (cons points (generate-sample-points-worker startx starty startx (+ cury yspacing)
                                                      width height xspacing yspacing '()))
	  ;;; else, add the current point to the list, and move right
	  (generate-sample-points-worker startx starty (+ curx xspacing) 
                                         cury width height xspacing yspacing
                                         (append points (list (make-point (round curx) (round cury))))))))

(define (sum-colors color-list)
  (if (null? color-list) 
      (make-color 0 0 0)
      (add-color (first color-list) 
		 (sum-colors (rest color-list)))))

(define (add-color color1 color2)
  (make-color (+ (get-red color1) (get-red color2))
	      (+ (get-green color1) (get-green color2))
	      (+ (get-blue color1) (get-blue color2))))

(define (average-colors point-colors)
  (let ((num-colors (length point-colors))
	(sum-color (sum-colors point-colors)))
    (make-color (/ (get-red sum-color) num-colors)
		(/ (get-green sum-color) num-colors)
		(/ (get-blue sum-color) num-colors))))
  
(define (average-color bmimage)
  (let ((width (send bmimage get-width))
        (height (send bmimage get-height))
        (bmp (make-object bitmap-dc%)))    ;;; don't have get-pixel for bitmap%, need a dc
    (send bmp set-bitmap bmimage)
    (let ((result 
           (average-color-region bmp (make-point 0 0) (make-point (- width 1) (- height 1)) 
                                 num-samples)))
      (send bmp clear) ;;; Release the bitmap	
      result)))

(define (average-color-region bmdc startcorner size num-samples)
  (let ((color (make-object color% 0 0 0))) ;;; need a color object to get the pixel color
    (average-colors
     (flatten (map2d (lambda (point)
                       (send bmdc get-pixel (get-x point) (get-y point) color)
                       (assert (> (get-image-width bmdc) (get-x point)))
                       (assert (> (get-image-height bmdc) (get-y point)))
                       (make-color (send color red) (send color green) (send color blue)))
                     (generate-sample-points (get-x startcorner) (get-y startcorner)
                                             (get-x size) (get-y size)
                                             num-samples))))))
       
(define (generate-regions master-width master-height sample-width sample-height)
  (generate-sample-points-worker 0 0 0 0
   (- master-width sample-width) (- master-height sample-height)
   sample-width sample-height '()))

(define (choose-tiles master-bitmap tiles sample-width sample-height color-comparator)
  ;;;
  ;;; We need to last the master image as a bitmap in a device context
  ;;; to be able to sample points from it.
  ;;; 
  (let ((master-dc (make-object bitmap-dc%)))
    (send master-dc set-bitmap master-bitmap)
    (let* ((master-width (get-image-width master-dc))
	   (master-height (get-image-height master-dc))
	   (sample-size (make-point sample-width sample-height))
	   (samples (map2d (lambda (point)       ;;; for each region, we need the average color
			     (average-color-region master-dc point sample-size num-samples))
			   (generate-regions master-width master-height 
                                             sample-width sample-height))))
      (select-mosaic-tiles samples tiles color-comparator))))

;;; Creates a photomosaic for image master-image using the images in tiles-directory as tiles.
;;; The color-comparator function is a function taking three colors, master, tile1 and tile2,
;;; and returning #t if tile1 is a better color match for master and #f otherwise.

(define (select-mosaic-tiles samples tiles color-comparator)
  (map2d (lambda (sample) (tile-name (find-best-match sample tiles color-comparator))) samples))

(define (find-best-match sample tiles color-comparator)
  (if (null? tiles)                             ;;; If there are no tiles,          
      (error "No tiles to match!")              ;;;    we must lose.
      (if (= (length tiles) 1)                  ;;; If there is just one tile,
	  (first tiles)                         ;;;    that tile is the best match.
	  (pick-better-match                    ;;; Otherwise, the best match is
	   sample                               ;;; either the first tile in tiles,
	   (first tiles)                        ;;; or the best match we would find
	   (find-best-match                     ;;; from looking at the rest of the
  	      sample                            ;;; tiles.  Use pick-better-match
	      (rest tiles)                      ;;; to determine which one is better.
	      color-comparator)                    
	   color-comparator))))

(define (pick-better-match sample tile1 tile2 color-comparator)
  (if (color-comparator sample (tile-color tile1) (tile-color tile2))
      tile1
      tile2))

(define (make-photomosaic 
         master-image               ;;; Filename for the "big" picture
         tiles-directory            ;;; Directory containing the tile images
         tile-width tile-height     ;;; Display width and height of the tiles 
                                    ;;;    (doesn't have to match actual size)
         sample-width sample-height ;;; Sample width and height (each tile covers this size
                                    ;;;    area in master)
         output-filename            ;;; Name of file to generate (.html)
         color-comparator)          ;;; Function for comparing colors
  (produce-tiles-page 
   output-filename 
   (choose-tiles (image-bitmap (get-one-image master-image))
		 (map (lambda (image) (list (image-name image)
                                            (average-color (image-bitmap image))))
                      (load-images (get-image-names tiles-directory)))
		 sample-width sample-height 
		 color-comparator)
   tile-width tile-height))

(define (make-rotundasaic output-filename color-comparator)
  (make-photomosaic 
   (string-append path-name "rotunda.gif")
   (string-append path-name "tiles/")
   36 28 ;;; tile sizes
   36 28 ;;; sample square size
   output-filename
   color-comparator))
 
;;;
;;; Data Abstraction methods
;;;

;;; Colors

(define (make-color r g b) (list r g b))

(define (get-red col) (first col))
(define (get-green col) (second col))
(define (get-blue col) (third col))

(define (valid-color? color)
  (and (list? color)
       (= (length color) 3)
       (>= (get-red color) 0) (<= (get-red color) 255)
       (>= (get-green color) 0) (<= (get-green color) 255)
       (>= (get-blue color) 0) (<= (get-blue color) 255)))

(define (show-color color)
  (let ((port (open-viewport (format "color: ~a" color) 200 200)))
    ((draw-solid-rectangle port) (make-posn 0 0) 200 200 (make-rgb 0.0 0.0 0.0))
    ((draw-solid-rectangle port) (make-posn 10 10) 180 180 
     (make-rgb (/ (get-red color) 256) (/ (get-green color) 256) (/ (get-blue color) 256)))))

;;; Points

(define (make-point x y) (list x y))
(define (get-x point) (first point))
(define (get-y point) (second point))

;;; Tiles are a list of (filename color)

(define (tile-name tile) (first tile))
(define (tile-color tile) (second tile))

;;; Images are (filename bitmap)

(define (image-name image) (first image))
(define (image-bitmap image) (second image))

;;; Utility routines

(define (square x)
  (* x x))

(define (flatten ll)
  (if (null? ll) '()
      (flat-append (car ll) (flatten (cdr ll)))))

(define (flat-append lst ll)
  (if (null? lst) ll
      (cons (car lst) (flat-append (cdr lst) ll))))

(define (map-safe f l)
  (map f (check (lambda (l) (not (null? l))) l)))

(define (map2d f ll)
  (map-safe (lambda (inner-list) (map f inner-list)) ll))

(define (get-image-height bmdc)
  (let-values (((width height) (send bmdc get-size))) height))

(define (get-image-width bmdc)
  (let-values (((width height) (send bmdc get-size))) width))

(define (check pred pass) (if (pred pass) pass (error ~a "Check failed: ")))

(define (assert pred)
  (if (not pred)
      (error 
       "Assertion failed.~nOops - this means there is probably a bug in the CS 1120 course code! Sorry!~nContact the course staff for help.")
      0
      ))

;;; Some standard color definitions:

(define white (make-color 255 255 255))
(define black (make-color 0 0 0))
(define red (make-color 255 0 0))
(define green (make-color 0 255 0))
(define blue (make-color 0 0 255))
(define yellow (make-color 255 255 0))
(define magenta (make-color 255 0 255))
(define cyan (make-color 0 255 255))

