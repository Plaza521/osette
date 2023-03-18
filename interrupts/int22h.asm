; int 22h - memory handler
; AH - operation
;   00 - Reset buffer
;     SI - Buffer
;     CX - Length
memory_handler:
    pusha
    cmp ah, 0
    je .reset
.popret:
    popa
    iret
.reset:
    call mh_reset_buffer
    jmp .popret

; Reset buffer
; ES:DI - buffer
; CX - Length
mh_reset_buffer:
    push si
    push cx
.loop:
    mov byte [ds:si], 0
    inc si
    loop .loop
.end:
    pop cx
    pop si
    ret
