1 value nextid

: become  ( n ) >r
    x y
    r> prefab me /objslot move
    y! x! ;
    
: find-free  ( - object )
    max-objects 0 do
        i object [[ en not if me ]] unloop exit then ]]
    loop  -1 abort" Out of free objects."
;

: sprite  ( - object )
    find-free [[
        me /objslot erase  true en!
        nextid id!  1 +to nextid
        at@ xy!
    me ]] 
;

: instance  ( prefab# - object )
    find-free [[
        become  nextid id!  1 +to nextid
        at@ xy!
    me ]]
;

: dismiss  ( object - )
    [[ 0 en! 0 id! ]]
;

: shout>  ( i n - <code> )
    r> -rot bounds do
        i object [[ en if dup >r call r> then ]]
    loop drop
;