: black  0e 0e 0e fcolor 1e falpha ;
: grey   0.5e 0.5e 0.5e fcolor 1e falpha ;
: keycode alevt KEYBOARD_EVENT.keycode @ ;

: bmpw  al_get_bitmap_width ;
: bmph  al_get_bitmap_height ;

: tm.dims  tm.cols tm.rows ;
: tm.scroll!  tm.scrolly! tm.scrollx! ;

create zbuf  256 allot
: z$   zcount zbuf zplace  zbuf ;
: +z   swap >r zcount r@ zappend r> ;
: s>z  zbuf zplace  zbuf ;

also system
: +z"  
  [char] " parse >SyspadZ +z
;
ndcs: ( -- )
    postpone (z")  [char] " parse z$,  postpone +z 
    discard-sinline  ;
previous

synonym file-exists fileExist? 

: 2s>f  swap s>f s>f ;

synonym my me

: 2+  rot + >r + r> ;
: 2-  rot swap - >r - r> ;

create pen 0 , 0 ,
: at  pen 2! ;
: +at  pen 2@ 2+ pen 2! ;
: at@  pen 2@ ;


: print  >r bif 0e 0e 0e 1e at@ 1 1 2+ 2s>f 0 r@ al_draw_text
            bif 1e 1e 1e 1e at@ 2s>f 0 r> al_draw_text ;

: type  ?dup if type else drop then ;


: +xy  y + y! x + x! ;

: ixy!  iy! ix! ;

: frame  ( n bmp# - ix iy )
    bitmap @ bmpw iw / /mod ih * swap iw * swap ;

: near?  ( obj n - f )
    over if >r 's xy xy pdist r> p <= else drop then ;


: bmpwh dup al_get_bitmap_width swap al_get_bitmap_height ;
: lb-pressed ms1 1 al_mouse_button_down 0= ms0 1 al_mouse_button_down 0<> and ;
: lb-letgo  ms1 1 al_mouse_button_down 0<> ms0 1 al_mouse_button_down 0= and ; 

: clear-tilemap  ( tilemap -- )
    [[ tm.base  tm.rows tm.stride * bounds do
        -1 i !
    cell +loop ]] ;

: clear-objects  ( i n -- )
    swap object swap /objslot * erase ;
