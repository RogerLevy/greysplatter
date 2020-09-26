: 1x      m al_identity_transform      m al_use_transform ;

:while objsel update
    1x 0e 0e fcolor 1e falpha cls
\    m scrollx negate s>f scrolly negate s>f al_translate_transform
    prefab# prefab [[ en if
        counter 16 and if
            x p>f 1e f-  y p>f 1e f-
                iw s>f x p>f f+ 1e f+ ih s>f y p>f f+ 1e f+
                1e 0e 0e 1e al_draw_filled_rectangle
        then
    then ]]
    max-objects 0 do
        i prefab [[ en if draw then ]]
    loop
;

:while objsel step
;