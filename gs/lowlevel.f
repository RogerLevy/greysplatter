

: the-scene  scene# scene ;
: the-layer  the-scene [[ layer# s.layer ]] ;

: the-plane  layer# bgplane  ;
: the-base   the-plane 's tm.base ;
: the-stride the-plane 's tm.stride ;
: the-bmp#   the-plane 's tm.bmp# ;

: maus  mouse zoom p/ swap zoom p/ swap scrollx scrolly 2+ ;
: colrow  the-plane [[ swap tm.tw / swap tm.th / ]] ;
: there  maus colrow ;
: tilexy  the-plane [[ swap tm.tw * swap tm.th * ]] ;
: scroll-  swap scrollx - swap scrolly - ;
: the-tile   there the-plane tile ; 

: cta  \ Cover Tristan's Ass: add undo history for the area under the selection
    tbrush [[ tm.dims * 1 = if
        the-tile cell snapshot
    else
        the-tile  the-plane 's tm.stride tm.rows *  tm.cols cells +  snapshot
    then ]]
;

: ctt  \ Cover Tristan's Tuchus: add undo history for the entire layer
    the-plane [[ tm.base  tm.stride tm.rows * ]] snapshot 
;

: ctr  \ Cover Tristan's Rear: add undo history of the object list
    0 object [ lenof object /objslot * ]# snapshot
;

: ctd  \ Cover Tristan's Derier: add undo history for the selected object
    selected ?dup if /objslot snapshot then
;

: resize-tilemap ( cols rows tilemap )
    [[ 2dup tm.rows! tm.cols!
    the-plane [[ tm.tw tm.th ]] tm.th! tm.tw! 
    tm.th * tm.h!  tm.tw * tm.w! ]]
;

: draw-plane  ( plane - ) 
    [[ scrollx tm.scrollx! scrolly tm.scrolly! tilemap-draw ]] ;

: draw-parallax ( i - )
    dup  ( i ) the-scene 's s.layer >r
    bgplane [[  scrollx r@ 's l.parax p* tm.scrollx!
        scrolly r> 's l.paray p* tm.scrolly!
        tilemap-draw ]]
;