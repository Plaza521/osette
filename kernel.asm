format binary as 'bin'
USE16
org 8400h

include 'inc/constants.inc'

kernel:
    pusha
    xor ax, ax
    mov es, ax
    mov word [es:IVT_VIDEO], video_handler
    mov word [es:IVT_VIDEO+2], cs
    popa
    
    xor ah, ah
    int 20h
    mov ah, 4
    mov bx, 255
    int 20h

    jmp $

hw db "Hello, world!", 0

include 'inc/interrupts.inc'
