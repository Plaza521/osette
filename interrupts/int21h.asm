; int 21h - keyboard handler
; AH - operation
;   00 - Wait key
;     --
;     AX - Key
;   01 - Input string
;     SI - Pointer on buffer
;     CX - Size of buffer
;     --
;     AX - Last key
keyboard_handler:
    pusha
    cmp ah, 0
    je .wk
    cmp ah, 1
    je .is
.popret:
    popa
    ret
.retax:
    mov word [.ax], ax
    popa
    mov ax, word [.ax]
    iret
    .ax dw 0
.wk:
    call kh_wait_key
    jmp .retax
.is:
    call kh_input_string
    jmp .retax

kh_wait_key:
    mov ah, 11h
    int 16h
    jnz .key_pressed
    jmp kh_wait_key
.key_pressed:
    mov ah, 10h
    int 16h
    ret

; Input string
;
; DS:SI - Pointer on buffer
; CX - Buffer length
; ---
; AX - Last pressed key
kh_input_string:
    push bx
    mov bx, 0

    .reset_buffer:
        push si
        push cx
    .reset_buffer.lp:
        mov byte [ds:si], 0
        inc si

        dec cx
        cmp cx, 0
        jne .reset_buffer.lp
    .reset_buffer.nd:
        pop cx
        pop si

.processing:
    xor ah, ah
    int 16h

    cmp al, 0Dh
    je .ent

    cmp al, 08h
    je .backspace

    cmp al, 03h
    je .ctrlc

    push ax
    mov ah, 0Eh
    int 10h
    pop ax

    mov [ds:si+bx], al
    inc bx

    cmp bx, cx
    je .ent

    jmp .processing
.backspace:
    cmp bx, 0
    je .processing

    mov ah, 0Eh
    int 10h

    mov al, ' '
    int 10h

    mov al, 08h
    int 10h

    dec bx
    mov byte [ds:si+bx], 0

    jmp .processing
.ent:
    pop bx
    mov ah, 1
    mov si, .ln
    int 20h
    xor ah, ah
    ret
.ctrlc:
    jmp .ent
.ln db 0Dh, 0Ah, 0
