#lang racket
(require
  (for-syntax "../src/fullai-parser.rkt")
  (for-syntax "../src/fullai-reader.rkt") ; for all-tokens
  (for-syntax syntax/strip-context) ; for replace-context
  (for-syntax "../src/fullai-expander.rkt")
  "../src/fullai-expander.rkt"
  )

(define-syntax (parse-atom stx)
  (define atom-parse (make-rule-parser abstract-atom-with-args))
  (syntax-case stx () [(_ THE-ATOM)
                       (with-syntax ([PARSE-TREE (replace-context #'() (atom-parse (all-tokens (syntax->datum #'THE-ATOM))))])
                         #'PARSE-TREE)]))
(provide parse-atom)

(define-syntax (parse-term stx)
  (define term-parse (make-rule-parser abstract-term))
  (syntax-case stx () [(_ THE-TERM)
                       (with-syntax ([PARSE-TREE (replace-context #'() (term-parse (all-tokens (syntax->datum #'THE-TERM))))])
                         #'PARSE-TREE)]))
(provide parse-term)

(define-syntax (parse-abstract-substitution stx)
  (define substitution-parse (make-rule-parser abstract-substitution))
  (syntax-case stx () [(_ THE-SUBSTITUTION)
                       (with-syntax ([PARSE-TREE (replace-context #'() (substitution-parse (all-tokens (syntax->datum #'THE-SUBSTITUTION))))])
                         #'PARSE-TREE)]))
(provide parse-abstract-substitution)

(define-syntax (parse-abstract-conjunction stx)
  (define conjunction-parse (make-rule-parser abstract-conjunction))
  (syntax-case stx () [(_ THE-CONJUNCTION)
                       (with-syntax ([PARSE-TREE (replace-context #'() (conjunction-parse (all-tokens (syntax->datum #'THE-CONJUNCTION))))])
                         #'PARSE-TREE)]))
(provide parse-abstract-conjunction)