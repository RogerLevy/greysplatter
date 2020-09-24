       
: clear-project
    destroy-bitmaps  0 bitmap [ lenof bitmap ]# cells erase
    0 prefab [ lenof prefab ]# /objslot * erase
    #bgplanes 0 do i bgplane clear-tilemap loop
;

: [open-project]
    2dup projectpath$ place
        projectpath$ stripFilename 
        clear-project
        s" anew project" evaluate  included
    projectpath$ count s>z +z" /prefabs.f" zcount included
;

: open-project
    z" example" z" Open Project" z" *.gsp.f" 0 filedialog ?dup if
        ['] [open-project] catch
        throw
    then
;

: findfreeprefab ( s n -- i )
    bounds do i prefab 's en 0= if i unloop exit then loop
    -1 abort" Out of free prefabs." ;
    
: prefab:
    0 max-prefabs findfreeprefab dup constant
    prefab as  true en! ;