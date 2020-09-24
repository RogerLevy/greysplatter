
: hue  1e frnd 1e frnd 1e frnd ;
: .prefab  zstr[ ." Prefab: #" prefab# . prefab# sdata count type ]zstr print ;
0 value mcounter
0 value click

:while objed update
    2x black cls
    0 draw-parallax
    1 draw-parallax
    
    m scrollx negate zoom p* s>f  scrolly negate zoom p* s>f al_translate_transform
    m al_use_transform
    max-objects 0 do
        i object [[ en if
            id RandSeed !
            
            x p>f y p>f  x iw p + p>f  y ih p + p>f  
                hue
                selected me = if counter 16 and if 1e else 0.5e then else 0.5e then
                al_draw_filled_rectangle
            info selected me <> and if
                x p>s y p>s 8 8 2- at zstr[ me object>i . ]zstr print then
        then ]]
    loop
    0 max-objects paint
    info if
        2x
        0 viewh 8 - at   zstr[ scrollx . scrolly . ]zstr print 
        128 viewh 8 - at  .prefab
    then
;

: ?snap ( obj )
    [[ snapping if
        x the-plane 's tm.tw 2 / / pround the-plane 's tm.tw 2 / * x!
        y the-plane 's tm.th 2 / / pround the-plane 's tm.th 2 / * y!
    then ]]
;


: ?drag
    maus | my mx |
    dragging if
        ms0 1 al_mouse_button_down selected 0<> and
            selected hovered = and if
            selected [[ walt 2 / p  y + y!  2 / p x + x! ]]
        then
        ms0 1 al_mouse_button_down 0= if
            false to dragging
            selected ?snap
        then
    else
        0 to hovered
        max-objects 0 do
            i object [[ en if
                mx x p>s >= my y p>s >= and
                mx x p>s iw + <= and my y p>s ih + <= and if
                    me to hovered
                    ms0 1 al_mouse_button_down if
                        me to selected
                        true to dragging
                        ctr
                    then
                    ms0 2 al_mouse_button_down if
                        objtype to prefab#
                    then
                then
            then ]]
        loop
    
    then
;

:while objed step
    alt? to snapping
    
    \ ms0 1 al_mouse_button_down if
    \     1 +to mcounter
    \ then
    \ 
    \ mcounter 10 < if
    \     lb-letgo if
    \         0 to mcounter
    \         -1 to click
    \         ." Click! "
    \     then
    \ else
        <SPACE> held ms0 1 al_mouse_button_down and if
            pan exit
        then
            
        ?drag
    \ then
    
    <a> pressed ctrl? and if
        ctr
        maus at prefab# instance to selected
        selected ?snap
    then
    
    <del> pressed if
        selected if 
            selected 's en if ctr selected dismiss then
            0 to selected
        then
    then
    
    <z> pressed ctrl? and if undo then
;
:while objed pump
    objed-ext
    etype ALLEGRO_EVENT_KEY_CHAR = if
        <q> keycode = if prefab# 1 - 255 and to prefab# then
        <w> keycode = if prefab# 1 + 255 and to prefab# then
    then
;