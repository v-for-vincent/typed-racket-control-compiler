#lang cclp/gg
NODES
1  sameleaves(g1,g2) 0 #f

2  collect(g1,a1) 0 #f
3  collect(g2,a2) 0 #f
4  eq(a1,a2) 0 #f

5  collect(g3,a3) 1 2
6  collect(g4,a4) 1 2
7  append(a3,a4,a1) 1 2
8  collect(g2,a2) 0 #f
9  eq(a1,a2) 0 #f

10 collect(g5,a5) 2 2
11 collect(g6,a6) 2 2
12 append(a5,a6,a3) 2 2
13 collect(g4,a4) 1 2
14 append(a3,a4,a1) 1 2
15 collect(g2,a2) 0 #f
16 eq(a1,a2) 0 #f

17 collect(g7,a7) 3 2
18 collect(g8,a8) 3 2
19 append(a7,a8,a5) 3 2
20 collect(g6,a6) 2 2
21 append(a5,a6,a3) 2 2
22 collect(g4,a4) 1 2
23 append(a3,a4,a1) 1 2
24 collect(g2,a2) 0 #f
25 eq(a1,a2) 0 #f

26 collect(g9,a9) 4 2
27 collect(g10,a10) 4 2
28 append(a9,a10,a7) 4 2
29 collect(g8,a8) 3 2
30 append(a7,a8,a5) 3 2
31 collect(g6,a6) 2 2
32 append(a5,a6,a3) 2 2
33 collect(g4,a4) 1 2
34 append(a3,a4,a1) 1 2
35 collect(g2,a2) 0 #f
36 eq(a1,a2) 0 #f

EDGES
1  -> 2, 3, 4.

2  -> 5, 6, 7.
3  -> 8.
4  -> 9.

5  -> 10, 11, 12.
6  -> 13.
7  -> 14.
8  -> 15.
9  -> 16.

10 -> 17, 18, 19.
11 -> 20.
12 -> 21.
13 -> 22.
14 -> 23.
15 -> 24.
16 -> 25.

17 -> 26, 27, 28.
18 -> 29.
19 -> 30.
20 -> 31.
21 -> 32.
22 -> 33.
23 -> 34.
24 -> 35.
25 -> 36.