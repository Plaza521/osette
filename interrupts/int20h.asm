; int 20h
; AH - operation
;   00 - Clear screen
video_handler:
    pusha
    cmp ah, 0
    je .clear
.popret:
    popa
    iret

.clear:
    call vh_clear_screen
    jmp .popret

vh_clear_screen:
    mov ax, 3
    int 10h
    ret
