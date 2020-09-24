scene: testscene
    64 16 * s.w!
    64 16 * s.h! 
    0 s.layer [[
        1 4 p/ l.parax!  1 4 p/ l.paray!
        tileset: test.tiles.png 16 16 
        z" testscene-layer0.stm" l.zstm!
    ]]
    1 s.layer [[
        tileset: test.tiles.png 16 16 
        z" testscene-layer1.stm" l.zstm!
    ]]
;scene