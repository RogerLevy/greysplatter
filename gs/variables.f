\ Common

0 value scene#         \ doesn't change (for now)
true value info
0 value counter
0 value layer#
create projectpath$ 256 /allot       
create scenefile$   256 /allot

\ Tilemap-related

create tile-selection 0 , 0 , 1 , 1 ,  \ col , row , #cols , #rows ,
256 256 plane: tbrush ;plane    \ clipboard tilemap
create tsel /tilemap /allot     \ describes selection source
0 value tsel-plane#             \ index of the background plane where the selection is

\ Object-related

0 value dragging  \ bool
0 value prefab#
0 value selected  \ object
0 value hovered   \ object
true value snapping

defer objed-ext   \ adds additional events to the OBJED mode
    ' noop is objed-ext

\ Prefab-related

[undefined] max-prefabs [if] 256 constant max-prefabs [then]

/objslot 128 - constant /userfields  \ For object-specific stuff

max-prefabs /objslot array prefab
max-prefabs 1024 array sdata  \ static data such as actions

\ Screens

/screen
    screen-getset scrollx scrollx!
    screen-getset scrolly scrolly!
to /screen

screen maped
screen tiles
screen attributes
screen objed 
screen objsel


256 256 plane: bgp1 1 tm.bmp#! ;plane
256 256 plane: bgp2 1 tm.bmp#! ;plane
256 256 plane: bgp3 1 tm.bmp#! ;plane
256 256 plane: bgp4 1 tm.bmp#! ;plane

create bgplanes bgp1 , bgp2 , bgp3 , bgp4 ,
: bgplane  cells bgplanes + @ ;

4 constant #bgplanes
1024 cells constant /tileattrs 
create tiledata /tileattrs lenof bitmap * /allot

\ internal layer struct
0
    64 zgetset l.zstm l.zstm!      \ tilemap path
    64 zgetset l.zbmp l.zbmp!      \ tile bitmap path
    pgetset l.parax l.parax!
    pgetset l.paray l.paray!
    getset l.tw l.tw!              \ tile size
    getset l.th l.th!
    getset l.scrollx l.scrollx!    \ initial scroll coords in pixels
    getset l.scrolly l.scrolly!
    getset l.bmp# l.bmp#!
constant /LAYER

\ internal scene struct
0
    32 zgetset s.zname s.zname!
    128 zgetset s.zpath s.zpath!  \ directory
    128 zgetset s.zobj s.zobj!    \ obj.f path relative to zpath
    getset s.w s.w!               \ bounds
    getset s.h s.h!
    4 /layer field[] s.layer
constant /SCENE

256 /scene array scene
64 1024 cells array tiledata  \ attribute data (64 tilesets supported)
