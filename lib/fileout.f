0 value file#
create crlf  13 c, 10 c,

: Emit-file  drop  pad c!  pad 1 file# write-file throw ;
: Type-file  drop  file# write-file throw ;
: CR-file    drop  crlf 2 file# write-file throw ;

create file-vectors
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' Emit-file ,
  ' drop ,
  ' Type-file ,
  ' CR-file ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,
  ' drop ,

create filedev   0 , file-vectors ,

0 value old-dev

: write[  ( filename c )
    2dup fileexists? if 2dup delete-file throw then
    w/o create-file throw to file#
    op-handle @ to old-dev  filedev op-handle !
;
    
: ]write
    old-dev op-handle !
    file# close-file drop
;