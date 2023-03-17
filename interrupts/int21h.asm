; int 21h - keyboard handler
; AH - operation
;   00 - Wait keyt
;     --
;     AX - Key
;   01 - Input string
;     SI - Pointer on buffer
;     CX - Size of buffer
;     --
;     AX - Last key
keyboard_handler:
    iret