format binary as 'bin'
USE16
org 8400h

include 'inc/constants.inc'

kernel:
    mov ax, 3
    int 10h
    
    mov ax, 1301h
    mov cx, 13
    mov bp, hw
    xor dx, dx
    mov bx, 7
    int 10h
    jmp $

hw db "Hello, world!"
