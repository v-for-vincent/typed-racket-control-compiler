#lang racket
(require rackunit)
(require "../src/interaction.rkt")
(require (prefix-in abp: "abstract-domain-boilerplate.rkt"))
(require "../src/data-utils.rkt")
(require racket-tree-utils/src/tree)

(test-case
 "candidate and predecessors for various scenarios"
 (let ([tree (node (tree-label (list (abp:parse-abstract-atom "foo(γ1)")) (none) '() #f #f) '())])
   (check-equal? (candidate-and-predecessors tree '())
                 (cons (some tree) '())))
 (let* ([leaf1
         (node (tree-label (list (abp:parse-abstract-atom "bar(γ1)")) (none) '() #f #f) '())]
        [leaf2
         (node (tree-label (list (abp:parse-abstract-atom "baz(α1)")) (none) '() #f #f) '())]
        [tree
         (node
          (tree-label (list (abp:parse-abstract-atom "foo(γ1)")) (some 0) '() #f 1)
          (list leaf1 leaf2))])
   (begin
     (check-equal?
      (node-label (some-v (car (candidate-and-predecessors tree '()))))
      (node-label leaf1))
     (check-equal?
      (cdr (candidate-and-predecessors tree '()))
      (list (cons (list (abp:parse-abstract-atom "foo(γ1)")) 1)))))
 (let* ([leaf1 (node 'fail '())]
        [middle
         (node
          (tree-label (list (abp:parse-abstract-atom "bar(γ1)")) (some 0) '() #f 2)
          (list leaf1))]
        [leaf2
         (node (tree-label (list (abp:parse-abstract-atom "baz(α1)")) (none) '() #f #f) '())]
        [tree
         (node
          (tree-label (list (abp:parse-abstract-atom "foo(γ1)")) (some 0) '() #f 1)
          (list middle leaf2))])
   (begin
     (check-equal?
      (car (candidate-and-predecessors tree '()))
      (some leaf1))
     (check-equal?
      (cdr (candidate-and-predecessors tree '()))
      (list
       (cons (list (abp:parse-abstract-atom "bar(γ1)")) 2)
       (cons (list (abp:parse-abstract-atom "foo(γ1)")) 1)))))
 (let* ([bottom-left (node (cycle 1) '())]
        [above-bottom-left (node (tree-label (list (abp:parse-abstract-atom "a")) (none) (list) #f 3) (list bottom-left))]
        [left-of-root (node (tree-label (list (abp:parse-abstract-atom "b")) (some 0) (list) #f 2) (list above-bottom-left))]
        [bottom-right (node (tree-label (list (abp:parse-abstract-atom "c")) (none) (list) #f #f) '())]
        [tree (node (tree-label (list (abp:parse-abstract-atom "a")) (some 0) (list) #f 1) (list left-of-root bottom-right))])
   (check-equal?
    (car (candidate-and-predecessors tree '()))
    (some bottom-right))))

(test-case
 "finding the most recently applied operation"
 (let ([root-only-tree
        (node
         (tree-label
          (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
          (none)
          (list)
          #f
          #f) '())])
   (check-equal? (candidate-for-undo root-only-tree) #f))
 (let* ([unwound-leaf
         (node
          (tree-label
           (abp:parse-abstract-conjunction "collect(γ1,α1),collect(γ2,α2),eq(α1,α2)")
           (none)
           (list)
           #f ; doesn't matter for purpose of this test
           #f) '())]
        [unwound-tree
         (node
          (tree-label
           (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
           (some 0)
           (list)
           #f
           1) (list unwound-leaf))]
        [rewound-tree
         (node
          (tree-label
           (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
           (none)
           (list)
           #f
           #f) '())])
   (check-equal? (candidate-for-undo unwound-tree) unwound-tree)))

(test-case
 "rewinding the most recently applied operation"
 (let ([root-only-tree
        (node
         (tree-label
          (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
          (none)
          (list)
          #f
          #f) '())])
   (check-equal? (rewind root-only-tree) #f))
 (let* ([unwound-leaf
         (node
          (tree-label
           (abp:parse-abstract-conjunction "collect(γ1,α1),collect(γ2,α2),eq(α1,α2)")
           (none)
           (list)
           #f ; doesn't matter for purpose of this test
           #f) '())]
        [unwound-tree
         (node
          (tree-label
           (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
           (some 0)
           (list)
           #f
           1) (list unwound-leaf))]
        [rewound-tree
         (node
          (tree-label
           (abp:parse-abstract-conjunction "sameleaves(γ1,γ2)")
           (none)
           (list)
           #f
           #f) '())])
   (check-equal? (rewind unwound-tree) (cons rewound-tree rewound-tree)))
 (let* ([leaf1 (node (tree-label (list) (none) (list) #f #f) (list))]
        [leaf2 leaf1]
        [grandchild1 (node (tree-label (abp:parse-abstract-conjunction "quux") 0 (list) #f 3) (list leaf1))]
        [grandchild2 (node (tree-label (abp:parse-abstract-conjunction "zoom") 0 (list) #f 4) (list leaf2))]
        [child (node (tree-label (abp:parse-abstract-conjunction "bar") 0 (list) #f 2) (list grandchild1 grandchild2))]
        [unwound-tree (node (tree-label (abp:parse-abstract-conjunction "foo") 0 (list) #f 1) (list child))]
        [rewound-node (node (tree-label (abp:parse-abstract-conjunction "zoom") (none) (list) #f #f) (list))]
        [rewound-child (node (tree-label (abp:parse-abstract-conjunction "bar") 0 (list) #f 2) (list grandchild1 rewound-node))]
        [rewound-tree (node (tree-label (abp:parse-abstract-conjunction "foo") 0 (list) #f 1) (list rewound-child))])
   (check-equal? (rewind unwound-tree) (cons rewound-node rewound-tree)))
 (let* ([leaf1 (node (tree-label (list) (none) (list) #f #f) (list))]
        [leaf2 (node (cycle 3) (list))]
        [grandchild1 (node (tree-label (abp:parse-abstract-conjunction "quux") 0 (list) #f 3) (list leaf1))]
        [grandchild2 (node (tree-label (abp:parse-abstract-conjunction "zoom") 0 (list) #f 4) (list leaf2))]
        [grandchild3 (node (tree-label (abp:parse-abstract-conjunction "baz") (none) (list) #f 4) (list))]
        [child (node (tree-label (abp:parse-abstract-conjunction "bar") 0 (list) #f 2) (list grandchild1 grandchild2 grandchild3))]
        [unwound-tree (node (tree-label (abp:parse-abstract-conjunction "foo") 0 (list) #f 1) (list child))]
        [rewound-node (node (tree-label (abp:parse-abstract-conjunction "zoom") (none) (list) #f #f) (list))]
        [rewound-child (node (tree-label (abp:parse-abstract-conjunction "bar") 0 (list) #f 2) (list grandchild1 rewound-node grandchild3))]
        [rewound-tree (node (tree-label (abp:parse-abstract-conjunction "foo") 0 (list) #f 1) (list rewound-child))])
   (check-equal? (rewind unwound-tree) (cons rewound-node rewound-tree))))