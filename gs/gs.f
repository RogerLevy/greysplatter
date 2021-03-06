empty

require lib/fixed.f
require lib/pv2d.f
require lib/roger.f
require lib/stackarray.f
require lib/strout.f
require lib/fileout.f
require lib/filelib.f
require lib/a.f

include lib/game.f   ( window assets objects )
include gs/undo.f
include gs/keys.f
include gs/input.f
include gs/variables.f
include gs/gametools.f
include gs/lowlevel.f
include gs/datatools.f
include gs/objmgmt.f
include gs/scene.f
include gs/project.f
include gs/tileutils.f
include gs/screen-maped.f
include gs/screen-tiles.f
include gs/screen-objed.f
include gs/screen-objsel.f

include gs/system.f


: init-game
    maped    
    open-project
    open-scene
;

include lib/go.f

export? [if]
    savegui gs
[else]
    init go
[then]  \ turnkey (save) breaks reloading
