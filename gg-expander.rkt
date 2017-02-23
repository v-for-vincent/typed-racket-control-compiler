#lang br/quicklang
(require (for-syntax syntax/strip-context))
(require graph)
(require "gen-graph-structs.rkt")

(define-macro (gg-module-begin (gg (nodes-section NODE-LINE ...) (edges-section EDGE-LINE ...)))
  (with-syntax ([REPLACED (replace-context caller-stx #'val)])
    (syntax/loc caller-stx
      (#%module-begin
       (nodes-section NODE-LINE ...)
       (define REPLACED (edges-section EDGE-LINE ...))
       (provide REPLACED)))))
(provide (rename-out [gg-module-begin #%module-begin]) #%top-interaction)

(define-macro (nodes-section NODE-LINE ...) #'(begin NODE-LINE ...))
(provide nodes-section)

(define-macro (node-line NUMBER CONJUNCT GEN-RANGE)
  (with-pattern ([NODE-NUM (prefix-id "node-" #'NUMBER)])
    #'(define NODE-NUM
        (identified-abstract-conjunct-with-gen-range
         (identified-abstract-conjunct CONJUNCT NUMBER)
         GEN-RANGE))))
(provide node-line)

(define-macro-cases generation-range
  [(_ 0 #f) #'(gen-range 0 0 #f)]
  [(_ RDEPTH NUM) #'(gen-range RDEPTH RDEPTH NUM)]
  [(_ RDEPTH1 RDEPTH2 NUM) #'(gen-range RDEPTH1 RDEPTH2 NUM)])
(provide generation-range)

(define-macro (symbol-sum SYM NUM) #'(symsum SYM NUM))
(provide symbol-sum)

(define-macro (edges-section EDGE-LINE ...)
  #'(unweighted-graph/directed (append EDGE-LINE ...)))
(provide edges-section)

(define-macro-cases edge-line
  [(_ START DEST) (with-pattern ([START-ID (prefix-id "node-" #'START)]
                                 [DEST-ID (prefix-id "node-" #'DEST)])
                    #'(list (list START-ID DEST-ID)))]
  [(_ START DEST0 DEST ...)
   (with-pattern ([START-ID (prefix-id "node-" #'START)]
                  [DEST0-ID (prefix-id "node-" #'DEST0)])
     #'(cons (list START-ID DEST0-ID)
             (edge-line START DEST ...)))])
(provide edge-line)

(require (only-in "at-expander.rkt" abstract-atom abstract-function abstract-g-variable abstract-a-variable))
(provide abstract-atom abstract-function abstract-g-variable abstract-a-variable)
(require (only-in "at-expander.rkt" multi-abstraction parameterized-abstract-conjunction
                  parameterized-abstract-atom parameterized-abstract-function
                  parameterized-abstract-a-variable parameterized-abstract-g-variable
                  parameterized-abstract-list init init-pair consecutive consecutive-pair
                  final final-pair))
(provide multi-abstraction parameterized-abstract-conjunction
         parameterized-abstract-atom parameterized-abstract-function
         parameterized-abstract-a-variable parameterized-abstract-g-variable
         parameterized-abstract-list init init-pair consecutive consecutive-pair
         final final-pair)