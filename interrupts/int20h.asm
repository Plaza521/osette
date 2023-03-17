; int 20h
; AH - operation
;   00 - Clear screen
;   01 - Print cstring
;     SI - Pointer on string
video_handler:
    pusha
    cmp ah, 0
    je .clear
    cmp ah, 1
    je .printc
.popret:
    popa
    iret
.clear:
    call vh_clear_screen
    jmp .popret
.printc:
    call vh_print_cstring
    jmp .popret

vh_clear_screen:
    mov ax, 3
    int 10h
    ret

; Print Сstring
;
; DS:SI - Pointer on string
vh_print_cstring:
    pusha
    mov cx, 1
    mov bh, 0Fh
.print:
    lodsb

    cmp al, 0
    je .finish

    call vh_print_symbol
    jmp .print
.finish:
    popa
    ret

; Print symbol
;
; AL - symbol
vh_print_symbol:
    pusha

    xor bx, bx
    mov cx, 1
    mov ah, 0Eh
    int 10h

    popa
    ret
