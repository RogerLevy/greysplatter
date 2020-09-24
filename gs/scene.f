
: [tileattrs]  ( n bmp# - a ) 1024 * + cells tiledata + ;

\ keep the data struct abstracted away so we can add stuff (using other arrays)
: tileflags  ( n bmp# - n ) [tileattrs] @ ;
: tileflags! ( n n bmp# ) [tileattrs] ! ;


: layer-init
    16 l.tw! 16 l.th!  1 p l.parax! 1 p l.paray!
    0 l.scrollx! 0 l.scrolly!
;

: ?exist
    dup zcount file-exists not if cr zcount type ."  not found" 0 else 1 then
;

: load-stm ( zstr tilemap -- )
    [[ ?dup if ?exist if r/o[ 
        0 sp@ 4 read drop
        0 sp@ 2 read ( w ) dup tm.cols! cells tm.stride!
        0 sp@ 2 read ( h ) tm.rows!
        tm.base  bytes-left read
    ]file then then ]] 
;

: create-stm ( cols rows zstr -- )
    newfile[
        s" STMP" write
        over sp@ 2 write drop
        dup sp@ 2 write drop
        * cells dup allocate throw dup rot write
        free throw
    ]file
;

: scene:  ( - <name> ) ( - n )
    >in @ >r
    0 scene [[
    r> >in ! bl parse s>z s.zname!
    [ bgp1 's tm.cols 16 * ]#  dup s.w! s.h!
    4 0 do i s.layer [[ layer-init ]] loop
;

: ;scene  ]] ;

: obj-path  ( me=scene - zstr )
    s.zpath z$  s.zobj c@ if
        s.zobj +z 
    else
        +z" /"   s.zname +z   +z" .obj.f"
    then ;

: stm-path  ( s.zpath me=layer - zstr | 0 )
    l.zstm 0= if drop 0 exit then
    z$ +z" /" l.zstm +z ;

: [layer-load]  {: i zscenepath -- :}  ( me=layer )
    l.zstm c@ 0<> if
        zscenepath stm-path zcount FileExist? if
            zscenepath stm-path i bgplane load-stm
            exit
        then
    then
    i bgplane [[
        .s
        256 tm.cols! 256 tm.rows!
        256 cells tm.stride!
        me clear-tilemap
    ]]
;

\ : tad-path  ( layer - zstr )
\     's l.bmp# zbmp-file zcount 4 - s>z +z" .tad" ;
\ : [load-attributes]
\     l.bmp# bitmap @ if
\         my tad-path ?exist if
\             r/o[ 0 l.bmp# [tileattrs] /tileattrs read ]file
\         then
\     then
\ ;

: [load-objects]
    obj-path ?exist if zcount included
        else 0 max-objects clear-objects then
;

0 value [scenepath]
: load  ( n ) 
    scene [[  s.zpath to [scenepath]
        4 0 do i s.layer [[
            l.tw l.th i bgplane [[ tm.th! tm.tw! ]]
            i [scenepath] [layer-load]
            \ [load-attributes]
        ]] loop
        [load-objects]
    ]]
;

: load-scene  ( scene# )
    to scene#
    
    \ create any specified tilemap files that don't exist (this is temporary)
    the-scene [[
        4 0 do i s.layer [[
            l.zstm c@ if l.zstm zcount FileExist? not if
                cr ." Auto-creating " l.zstm zcount type
                the-scene 's s.w l.tw / 
                the-scene 's s.h l.th / l.zstm create-stm
            then then
        ]] loop
    ]]
    
    \ load tilemaps, tile attributes, layer settings, and objects from given scene
    scene# load
    
    \ copy the layer properties from the scene layers to the engine layers
    the-scene [[
        4 0 do i s.layer [[
            l.tw l.th l.bmp# 
            i bgplane [[ tm.bmp#! tm.th! tm.tw! ]]
        ]] loop
    ]]  
    
    clear-history
;


: open-scene
    projectpath$ count s>z +z" /data/scenes"
        z" Open Scene" z" *.scn.f"  0 filedialog ?dup if
        0 scene /scene erase
        scenefile$ place
        scenefile$ count pad place  pad stripfilename  pad count 0 scene 's s.zpath zplace
        scenefile$ count included
        0 load-scene
    then
;

: findfreebitmap ( s n -- i )
    bounds do i >albmp 0= if i unloop exit then loop
    -1 abort" Out of bitmap slots." ; 

: ?bitmap
    >in @ >r
    bl word find 0= if  drop 
        0 [ lenof bitmap ]# findfreebitmap dup
            r@ >in !  dup constant
            r> >in !  zstr[ projectpath$ count type ." /data/bitmaps/" bl parse type ]zstr
            ( n zstr ) load-bitmap
        else r> drop  execute then ;
        
: ?tileset
    >in @ >r
    bl word find 0= if  drop
        64 [ lenof bitmap 64 - ]# findfreebitmap dup
            r@ >in !  dup constant
            r> >in !  zstr[ projectpath$ count type ." /data/bitmaps/" bl parse type ]zstr 
            ( n zstr ) load-bitmap
        else r> drop  execute then ;

: instance:  ?token if instance as then ;
: at:  number number 2p xy! ;
: id:  number id! ;
: bitmap:  ?bitmap bmp#! ;
: sprite:  bitmap: number number ih! iw! number bmp# frame ixy! ;
: tilemap:  zstr[ s.zpath bl parse type ]zstr l.zstm! ;
: tileset:  ?tileset l.bmp#! number number l.th! l.tw! ;