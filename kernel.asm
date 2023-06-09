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
    mov word [es:IVT_KEYBOARD], keyboard_handler
    mov word [es:IVT_KEYBOARD+2], cs
    popa

    xor ah, ah
    mov si, hw + 2
    mov cx, 5
    int 22h

    mov ah, 1
    mov si, hw
    int 20h

    jmp $

hw db "Hello, world!", 0

include 'inc/interrupts.inc'
