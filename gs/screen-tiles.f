
: tcols  the-plane [[ tm.bmp# bitmap @ bmpw tm.tw / ]] ; 
: mouse-tile  the-plane [[ mouse 2 / tm.th / tcols *   swap 2 / tm.tw /   + ]] ;

:while tiles update
    2x black cls
    0e 0e the-bmp# bitmap @ bmpwh swap s>f s>f
        1e 0e 1e 1e al_draw_filled_rectangle
    the-bmp# bitmap @ 0e 0e 0 al_draw_bitmap
    draw-cursor
    info if
        0 viewh 8 - at   zstr[ mouse-tile . ]zstr print
    then
;

:while tiles step
    shift-select
    \ there swap tile-selection 2!
    the-bmp# bitmap @ if
        shift? lb-letgo and if
            mouse-tile tile-selection 8 + 2@ swap pick-tiles
        then
        lb-pressed  shift? not and if
            mouse-tile tile-selection 8 + 2@ swap pick-tiles
        then
        ms0 2 al_mouse_button_down if
            mouse-tile tile#!
        then
    then
;

:while tiles pump

;