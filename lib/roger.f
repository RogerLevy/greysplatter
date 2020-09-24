variable bud

: sfrand randseed @  3141592621 *  1+  DUP randseed ! ;
  also system  assign sfrand to-do RANDOM  previous

synonym rnd choose

: ]#  ] postpone literal ;
synonym & addr immediate
synonym | locals| immediate
synonym /allot allot&erase
: allotment  here >r /allot r> ;
synonym gild freeze
synonym & addr immediate

: frnd  65535e f* f>s choose s>f 65535e f/ ;

: .cell  
  base @ hex  swap
  ." $" 0 <# # # # # # # # # #> type
  base !
;

: .s            
  cr  depth ?dup if
    dup 0< #-4 ?throw
    0 swap 1 - ?do
      i pick  .cell space
    -1 +loop
  else
    ." empty stack"
  then
;

: 2-  rot swap - >r - r> ;

: call  >r ;

: lastword  last @ ctrl>nfa count ;