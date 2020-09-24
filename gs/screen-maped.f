
: select-tiles ( col row cols rows )
    tsel-plane# bgplane  tsel /tilemap move
    layer# to tsel-plane#  tsel resize-tilemap
    tsel-plane# bgplane  [[ ( row ) tm.stride * swap ( col ) cells + tm.base + ]]
        tsel [[ tm.base! ]]
;

: pick-tiles ( tile# )
    the-bmp# bitmap @ 0= if 3drop exit then
    the-bmp# bitmap @ bmpw the-plane 's tm.tw /
        | tcols #rows #cols t# |
    #cols #rows tbrush resize-tilemap 
    #rows 0 do #cols 0 do  i j tcols * + t# + i j tbrush tile !
    loop loop 
;

: tile#   ( - n ) tbrush 's tm.base @ ;
: tile#!  ( n ) 1 1 tbrush resize-tilemap tbrush 's tm.base !
    1 1 tile-selection 8 + 2! ;
0 tile#!

: copy-tiles
    tsel [[ tm.cols tm.rows ]] tbrush resize-tilemap
    tsel tbrush 0 0 tmove
;


: paste-tiles
    tbrush the-plane there tmove ;
: erase-tiles
    the-tile
        tsel [[ tm.cols cells tm.rows ]] the-plane 's tm.stride 2erase ;
: cut-tiles   copy-tiles erase-tiles ;

: fill-tiles 
    the-tile
        tsel [[ tm.cols cells tm.rows ]] the-plane 's tm.stride tile# 2tfill ;


: selw*  tile-selection 2 cells + @ * ;
: selh*  tile-selection 3 cells + @ * ;
        

: draw-cursor  
    the-plane [[ 
        tile-selection 2@ swap tilexy scroll- over s>f dup s>f
        swap tm.tw selw* + s>f  tm.th selh* + s>f
        0e 0e 0e 0.5e al_draw_filled_rectangle ]]
    
    shift? not if
        tbrush [[
            the-plane 's tm.bmp# tm.bmp#!
            the-plane 's tm.tw tm.tw!
            the-plane 's tm.th tm.th!
            the-plane [[ maus colrow tilexy scroll- 1 1 2- ]] 2p xy!
            tilemap-draw ]]    
    then
;

: tw  the-plane 's tm.tw ;
: th  the-plane 's tm.th ;

: ?refresh
    the-bmp# >albmp 0= if exit then
    the-bmp# zbmp-file mtime@ the-bmp# bmp-mtime @ > if 50 ms load-data then
;


: pan
    walt scrolly swap 2 / - 0 max the-scene 's s.h viewh - min scrolly!
         scrollx swap 2 / - 0 max the-scene 's s.w vieww - min scrollx!
;

: draw-plane  ( plane - ) 
    [[ scrollx tm.scrollx! scrolly tm.scrolly! tilemap-draw ]] ;

: draw-plane-parallax ( n - )
    dup the-scene 's s.layer >r
    bgplane  [[ scrollx r@ 's l.parax p* tm.scrollx!
           scrolly r> 's l.paray p* tm.scrolly! tilemap-draw ]]
;


:while maped update
    2x grey cls
    the-plane draw-plane 
    draw-cursor
    info if
        2x
        0 viewh 8 - at
        zstr[ ." Layer #" layer# 1 + . scrollx . scrolly . ]zstr print 
    then
;

: (tselect)
    tile-selection 2@ swap tile-selection 8 + 2@ swap select-tiles ;

-1 value startx -1 value starty
: shift-select
    shift? if
        lb-pressed if mouse to starty to startx then
        ms0 1 al_mouse_button_down if
            there tile-selection 2@ swap 2- 1 1 2+ swap tile-selection 8 + 2!
        else
            there swap tile-selection 2!
        then
    else 
        there swap tile-selection 2!
    then
    startx 0 >= if
        lb-letgo if
            display startx starty al_set_mouse_xy
            ms0 al_get_mouse_state
            there swap tile-selection 2!  -1 to startx
        then
    then
;

:while maped step
    shift-select  shift? lb-letgo and if tbrush clear-tilemap then
    ms0 1 al_mouse_button_down 0<> shift? not and if
        <SPACE> held  if
            pan
        else
            paste-tiles
        then 
    then
    ms0 2 al_mouse_button_down if
        maus th / the-stride * swap tw / cells + the-base + @ tile#!
    then
    ctrl? not shift? not and if 
        <e> pressed if -1 tile#! then
        <h> pressed if tile# $01000000 xor tile#! then
        <v> pressed if tile# $02000000 xor tile#! then
        <1> pressed if 0 to layer# then
        <2> pressed if 1 to layer# then
        <3> pressed if 2 to layer# then
        <4> pressed if 3 to layer# then
    then
    ctrl? if
        <c> pressed if (tselect) copy-tiles then
        <e> pressed if cta  (tselect) erase-tiles then
\        <f> pressed if (tselect) fill-tiles then
        <x> pressed if cta  (tselect) cut-tiles then
        <z> pressed if undo then
    then
;

: startpaint?
    etype ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = shift? not and
    <SPACE> held not and ;

:while maped pump
    startpaint? if
        ctt
    then

;