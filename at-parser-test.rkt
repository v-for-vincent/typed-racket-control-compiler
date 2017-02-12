#lang br
(require brag/support
         rackunit
         "at-parser.rkt"
         "at-tokenizer.rkt")

(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(!CY 1)"))
 '(at (cyclenode 1)))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(□)"))
 '(at (treelabel (selectionless-abstract-conjunction))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom)"))
 '(at (treelabel (selectionless-abstract-conjunction (abstract-atom "myatom")))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom1,myatom2)"))
 '(at (treelabel (selectionless-abstract-conjunction (abstract-atom "myatom1") (abstract-atom "myatom2")))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom(a))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-function "a"))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom(a(b(c))))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom"
                                                       (abstract-function "a"
                                                                          (abstract-function "b"
                                                                                             (abstract-function "c"))))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom(a,b))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-function "a") (abstract-function "b"))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom(a1))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-a-variable 1))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom(g1))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-g-variable 1))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom([]))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-list))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom([g1]))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-list (abstract-g-variable 1)))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom([g1,g2]))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-list (abstract-g-variable 1) "," (abstract-g-variable 2)))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom([g1,g2,g3]))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-list (abstract-g-variable 1) "," (abstract-g-variable 2) "," (abstract-g-variable 3)))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom([g1|g2]))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (abstract-atom "myatom" (abstract-list (abstract-g-variable 1) "|" (abstract-g-variable 2)))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(1.myatom,*myotheratom*,mythirdatom [myotheratom < myatom, myotheratom < mythirdatom])"))
 '(at
   (treelabel
    1
    (abstract-conjunction-selection (selectionless-abstract-conjunction (abstract-atom "myatom")) (selected-abstract-conjunct (abstract-atom "myotheratom")) (selectionless-abstract-conjunction (abstract-atom "mythirdatom")))
    (precedence-list (precedence (abstract-atom "myotheratom") (abstract-atom "myatom")) (precedence (abstract-atom "myotheratom") (abstract-atom "mythirdatom"))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(multi((abc),#t,{},{},{}))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction (multi-abstraction (parameterized-abstract-conjunction (parameterized-abstract-atom "abc")) #t (init) (consecutive) (final))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom {} myfact.)"))
 '(at (treelabel (selectionless-abstract-conjunction (abstract-atom "myatom")) (substitution) (fact (atom "myfact")))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(myatom {a1/g1, g2/nil} myhead(a1,a2) -> {a1/g1, a2/nil})"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction
     (abstract-atom "myatom"))
    (substitution
     (substitution-pair (abstract-a-variable 1) (abstract-g-variable 1))
     (substitution-pair (abstract-g-variable 2) (abstract-function "nil")))
    (fullai-rule
     (abstract-atom "myhead" (abstract-a-variable 1) (abstract-a-variable 2))
     (substitution
      (substitution-pair (abstract-a-variable 1) (abstract-g-variable 1))
      (substitution-pair (abstract-a-variable 2) (abstract-function "nil")))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(b,c {} a :- b,c)"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction
     (abstract-atom "b")
     (abstract-atom "c"))
    (substitution)
    (clause (atom "a") (conjunction (atom "b") (atom "c"))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(b,c {} a(X,foo,[X,Y]) :- b,c)"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction
     (abstract-atom "b")
     (abstract-atom "c"))
    (substitution)
    (clause (atom "a" (variable "X") (function "foo") (list (variable "X") "," (variable "Y")))
            (conjunction (atom "b") (atom "c"))))))
(check-equal?
 (parse-to-datum (apply-tokenizer make-tokenizer "(multi((abc(a<1,i,1>,a<1,i,2>)),#t,{},{},{}))"))
 '(at
   (treelabel
    (selectionless-abstract-conjunction
     (multi-abstraction
      (parameterized-abstract-conjunction
       (parameterized-abstract-atom "abc"
                                    (parameterized-abstract-a-variable 1  1)
                                    (parameterized-abstract-a-variable 1  2)))
      #t
      (init)
      (consecutive)
      (final))))))