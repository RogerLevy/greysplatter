: number  bl word count isNumber? 0= abort" Number expected." ;

: dropline  0 parse 2drop ;

: ?token  bl word find not if drop dropline 0 else execute -1 then ;

: filedialog  ( zpath ztitle zformats - a n ) 
    al_create_native_file_dialog >r  
    display r@ al_show_native_file_dialog drop
    r@ al_get_native_file_dialog_count if
        r@ 0 al_get_native_file_dialog_path zcount 
    else 0 then
    r> al_destroy_native_file_dialog 
;