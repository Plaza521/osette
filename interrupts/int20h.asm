; int 20h
; AH - operation
;   00 - Clear screen
;   01 - Print cstring
;     SI - Pointer on string
;   02 - New line
;   03 - Print digit (dec)
;     BX - num
;   04 - Print digit (hex)
;     BX - num
video_handler:
    pusha
    cmp ah, 0
    je .clear
    cmp ah, 1
    je .printc
    cmp ah, 2
    je .newline
    cmp ah, 3
    je .didec
    cmp ah, 4
    je .dihex
.popret:
    popa
    iret
.clear:
    call vh_clear_screen
    jmp .popret
.printc:
    call vh_print_cstring
    jmp .popret
.newline:
    mov si, .ln
    call vh_print_cstring
    jmp .popret
    .ln db 0Dh, 0Ah, 0
.didec:
    xchg ax, bx
    call vh_print_digit
    jmp .popret
.dihex:
    xchg ax, bx
    call vh_print_hexit
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

os_print_digit:
    pusha

    cmp ax, 9                       ; There is a break in ASCII table between 9 and A
    jle .digit_format

    add ax, 'A'-'9'-1       ; Correct for the skipped punctuation

.digit_format:
    add ax, "0"         ; 0 will display as '0', etc.   

    mov ah, 0Eh         ; May modify other registers
    int 10h

    popa
    ret

; Print unsigned int
;
; AX - Num to convert
vh_print_digit:
    pusha

    mov cx, 0
    mov bx, 10

.push:
    mov dx, 0
    div bx
    inc cx
    push dx
    test ax, ax
    jnz .push
.pop:
    pop dx
    add dl, '0'
    push ax
    mov ah, 0Eh
    mov al, dl
    int 10h
    pop ax
    loop .pop

    popa
    ret

; Print low part of AL in hex
;
; AL - Number to print
os_print_1hex:
    pusha

    and ax, 0Fh
    call os_print_digit

    popa
    ret

; Print AL in hex
;
; AL - Number to print
os_print_2hex:
    pusha

    push ax             ; Output high
    shr ax, 4
    call os_print_1hex

    pop ax              ; Output low
    call os_print_1hex

    popa
    ret


; Print AX in hex
;
; AX - Number to print
vh_print_hexit:
    pusha

    push ax             ; Output high byte
    mov al, ah
    call os_print_2hex

    pop ax              ; Output low byte
    call os_print_2hex

    popa
    ret
