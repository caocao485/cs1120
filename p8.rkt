#lang racket

(require net/url)

(define (pick-better cf p1 p2)
  (if(cf p1 p2)
     p1
     p2))

(define (list-find-best cf p)
  (if(null? (cdr p)) (car p)
     (pick-better cf (car p)
                  (list-find-best cf (cdr p)))))

(define (list-accumulate f base p)
  (if (null? p) 
      base
      (f (car p) (list-accumulate f base (cdr p)))))

(define (list-find-best-acc cf p)
  (list-accumulate (lambda(p1 p2)
                     (pick-better cf p1 p2))
                   (car p)
                   (cdr p)))

(define (list-delete p el)
  (if(null? p)null
     (if(equal? (car p) el) (cdr p)
        (cons(car p)(list-delete (cdr p) el)))))

(define (list-sort-best-first cf p)
  (if(null? p) null
     (cons (list-find-best cf p)
           (list-sort-best-first cf (list-delete p (list-find-best cf p))))))


(define (list-sort-best-first-let cf p)
  (if(null? p) null
     (let ((best (list-find-best cf p)))
       (cons best (list-sort-best-first-let cf (list-delete p best))))))

(define (pick-worst cf p1 p2)
  (if(cf p1 p2)
     p2
     p1))

(define (list-find-worst cf p)
  (if(null? (cdr p)) (car p)
     (pick-worst cf (car p)
                  (list-find-worst cf (cdr p)))))

(define (list-append p q)
  (if (null? p) 
      q
      (cons (car p) (list-append (cdr p) q))))

(define (list-sort-worst-last cf p)
  (if(null? p) null
     (list-append 
           (list-sort-worst-last cf (list-delete p (list-find-worst cf p)))
           (list-find-worst cf p))))


(define (list-insert-one cf el p)
  (if(null? p)(list el)
     (if(cf el(car p)) (cons el p)
        (cons (car p) (list-insert-one cf el (cdr p))))))

(define (list-sort-insert cf p)
  (if(null? p)null
     (list-insert-one cf (car p)
                      (list-sort-insert cf (cdr p)))))


(define (list-extract p start end)
  (if(= start 0)
     (if(= end 0) null
        (cons (car p)(list-extract (cdr p) start (- end 1))))
     (list-extract (cdr p) (- start 1)(- end 1))))

(define (list-first-half p)
  (list-extract p 0 (floor (/ (list-length p)2))))
(define (list-second-half p)
  (list-extract p (floor(/ (list-length p)2)) (list-length p)))

(define (list-length p)
   (if (null? p) 
       0 
       (+ 1 (list-length (cdr p)))))

(define (list-insert-one-split cf el p)
  (if(null p)(list el)
     (if(null? (cdr p))
        (if(cf el (car p))(cons el p) (list(car p) el))
        (let ((front (list-first-half p))
              (back (list-second-half p)))
          (if(cf el (car back))
             (list-append (list-insert-one-split cf el front) back)
             (list-append front (list-insert-one-split cf el back)))))))


(define  (list-sort-insert-split cf p)
  (if(null? p) null
     (list-insert-one-split
      cf (car p)
      (list-sort-insert-split cf (cdr p)))))



(define (make-tree left element right)
  (cons element (cons left right)))

(define (tree-element tree)(car tree))
(define (tree-left tree)(car (cdr tree)))
(define (tree-right tree)(cdr (cdr tree)))

(define (tree-insert-one cf el tree)
  (if(null? tree)(make-tree null el null)
     (if(cf el (tree-element tree))
        (make-tree (tree-insert-one cf el (tree-left tree))
                   (tree-element tree)
                   (tree-right tree))
        (make-tree (tree-left tree)
                   (tree-element tree)
                   (tree-insert-one cf el (tree-right tree))))))

(define (list-to-sorted-tree cf p)
  (if(null? p)null
     (tree-insert-one cf (car p)(list-to-sorted-tree cf (cdr p)))))

(define (tree-extract-elements tree)
  (if(null? tree)null
     (list-append (tree-extract-elements (tree-left tree))
                  (cons (tree-element tree)
                        (tree-extract-elements
                         (tree-right tree))))))

(define (list-sort-tree cf p)
  (tree-extract-elements (list-to-sorted-tree cf p)))


(list-sort-tree > (list 1 2 3 4 5 65))


;;quicksort
(define (list-filter test p)
  (if (null? p) 
      null
      (if (test (car p))
          (cons (car p) (list-filter test (cdr p)))
          (list-filter test (cdr p)))))

(define (list-quicksort cf p)
  (if(null? p)null
     (list-append
      (list-quicksort
       cf
       (list-filter
        (lambda(el)(cf el (car p)))
        (cdr p)))
      (cons (car p)
            (list-quicksort
             cf
             (list-filter
              (lambda(el)(not(cf el (car p))))
              (cdr p)))))))
                          


;;search
(define (intsto n)
  (if (= n 0) 
      null 
      (list-append (intsto (- n 1)) (list n))))
(define (list-search ef p)
  (if(null? p) false ;;No found
     (if (ef(car p))
         (car p)
         (list-search ef (cdr p)))))

(list-search (lambda(el)(= 12 el))
             (intsto 10))
(list-search (lambda(el)(= 12 el))
             (intsto 15))
(list-search (lambda(el)(> el 12))
             (intsto 15))

(define (binary-tree-search ef cf tree)
  (if(null? tree) false
     (if(ef(tree-element tree))(tree-element tree)
        (if (cf (tree-element tree))
            (binary-tree-search ef cf (tree-left tree))
            (binary-tree-search ef cf (tree-right tree))))))

(define (binary-tree-number-search tree target)
  (binary-tree-search (lambda(el)(= target el))
                      (lambda(el)(< target el))
                      tree))

(define (text-to-word-positions s)
  (define (text-to-word-positions-iter p w pos)
    (if(null? p)
       (if(null? w)null(list (cons (list->string w) pos)))
       (if(not(char-alphabetic? (car p)))
          (if(null? w)
             (text-to-word-positions-iter (cdr p) null (+ pos 1))
             (cons (cons (list->string w) pos)
                   (text-to-word-positions-iter (cdr p) null
                                                 (+ pos (list-length w)
                                                    1))))
          (text-to-word-positions-iter
           (cdr p)
           (list-append w (list (char-downcase (car p))))
           pos))))
  (text-to-word-positions-iter (string->list s) null 0))
  
(define (insert-into-index index wp)
  ;;(display index)
  (if(null? index)
     (make-tree null (cons (car wp)(list(cdr wp)))null)
     (if(string=? (car wp)(car (tree-element index)))
        (make-tree (tree-left index)
                   (cons (car (tree-element index))
                         (list-append (cdr (tree-element index))
                                      (list (cdr wp))))
                   (tree-right index))
        (if (string<? (car wp)(car (tree-element index)))
            (make-tree (insert-into-index (tree-left index)wp)
                       (tree-element index)
                       (tree-right index))
            (make-tree (tree-left index)
                       (tree-element index)
                       (insert-into-index (tree-right index) wp))))))


(define (insert-all-wps index wps)
  (if(null? wps) index
     (insert-all-wps (insert-into-index index (car wps))(cdr wps))))

(define (list-map f p)
  (if (null? p) 
      null
      (cons (f (car p)) 
            (list-map f (cdr p)))))


(define (index-document url text)
  (insert-all-wps
   null
   (list-map (lambda(wp)(cons (car wp)(cons url (cdr wp))))
             (text-to-word-positions text))))

(define (merge-indexes d1 d2)
  (define (merge-elements p1 p2)
    (if(null? p1)p2
       (if(null? p2)p1
          (if(string=? (car(car p1)) (car (car p2)))
             (cons (cons (car (car p1))
                         (list-append (cdr (car p1))
                                      (cdr (car p2))))
                   (merge-elements (cdr p1)(cdr p2)))
             (if(string<? (car (car p1))(car(car p2)))
                (cons (car p1)(merge-elements (cdr p1)p2))
                (cons (car p2)(merge-elements p1 (cdr p2))))))))
  (list-to-sorted-tree
   (lambda(el e2)(string<? (car el)(car e2)))
   (merge-elements (tree-extract-elements d1)
                   (tree-extract-elements d2))))


;;URL ::=> http://Domain OptPath
;;Domain ::=> Name SubDomains
;;SubDomains ::=> .Domain
;;SubDomains ::=> e
;;OptPath ::=>Path
;;OptPath ::=>e
;;Path ::=>/ Name OptPath


(define (read-all-chars port)
  (let((c (read-char port)))
       (if(eof-object? c) null
          (cons c (read-all-chars port)))))

(define (web-get url)
  (list->string (read-all-chars (get-pure-port(string->url url)))))

(define (index-pages p)
  (if(null? p)null
     (merge-indexes (index-document (car p) (web-get (car p)))
                    (index-pages (cdr p)))))

(define shakespeare-index
(index-pages
(list-map
(lambda (play)
(string-append "http://shakespeare.mit.edu/" play "/full.html" ))
;; List of plays following the site’s naming conventions.
(list "allswell" "asyoulikeit" "comedy errors" "cymbeline" "lll"
"measure" "merry wives" "merchant" "midsummer" "much ado"
"pericles" "taming shrew" "tempest" "troilus cressida" "twelfth night"
"two gentlemen" "winters tale" "1henryiv" "2henryiv" "henryv"
"1henryvi" "2henryvi" "3henryvi" "henryviii" "john" "richardii"
"richardiii" "cleopatra" "coriolanus" "hamlet" "julius caesar" "lear"
"macbeth" "othello" "romeo juliet" "timon" "titus" ))))


(define (search-in-index index word)
  (binary-tree-search
   (lambda(el)(string=? word (car el)))
   (lambda(el)(string<? word (car el)))
   index))

(define (index-histogram index)
  (list-quicksort
   (lambda(e1 e2)(>(cdr e1)(cdr e2)))
   (list-map (lambda(el)(cons (car el)(length (cdr el))))
             (tree-extract-elements index))))

(list-filter (lambda (entry) ( > (string-length (car entry)) 5 ))
(index-histogram shakespeare-index))
  