format binary as 'bin'
USE16
org 7E00h

include 'inc/constants.inc'

start:
    mov ah, 02h
    mov al, byte [0x7C03]
    mov dl, byte [0x7C02]
    mov ch, 0
    mov dh, 0
    mov cl, byte [0x7C04]
    mov bx, filetable
    int 13h

check_kernel:
    mov cl, byte [0x7C03]
    xor ch, ch
    shl cx, 5
    mov si, filetable
.loop:
    mov al, [si]
    and al, 00000011b
    cmp al, 2
    jne .continue
.test_name:
    push si
    push cx
    add si, 4
    mov bx, filename_buf
    mov cx, 12
    call copy_memory
    mov si, kernel_name
    call compare_strings
    jnc boot
    pop cx
    pop si
.continue:
    add si, 16
    loop .loop
.end:
    mov si, kernel_not_found
    call print_string
    jmp $
kernel_not_found db "Kernel not found!", 0
kernel_name db "kernel.bin", 0
filename_buf:
    times 12 db 0
db 0

boot:
    pop cx
    pop si
    mov ax, word [si+1]
    call lbatochs
    mov ah, 02h
    mov dl, [0x7C02]
    mov al, byte [si+3]
    mov bx, 0x8400
    int 13h
    jc 0x7C73
    jmp 0x8400


; Compare strings
;
; DS:SI - Pointer on first string
; DS:BX - Pointer on second string
; ---
; Carry flag - 1 if strings are not equal
compare_strings:
    pusha
compare_strings.comp:
    lodsb

    cmp [bx], al
    jne compare_strings.not_equal
    cmp al, 0
    je compare_strings.equal

    inc bx

    jmp compare_strings.comp
compare_strings.equal:
    clc
    jmp compare_strings.return
compare_strings.not_equal:
    stc
    jmp compare_strings.return
compare_strings.return:
    popa
    ret

; Copy memory from A to B
; SI - A
; BX - B
; CX - Number of bytes to copy
copy_memory:
    pusha
.loop:
    lodsb
    mov [bx], al
    inc bx
    loop .loop
.end:
    popa
    ret

; Print terminated string
;
; DS:SI - Pointer on string
print_string:
    pusha
    mov cx, 1
    mov bh, 0Fh
print_string.print:
    lodsb

    cmp al, 0
    je print_string.finish

    call print_symbol
    jmp print_string.print
print_string.finish:
    popa
    ret

; Print symbol
;
; AL - symbol
print_symbol:
    pusha

    xor bx, bx
    mov cx, 1
    mov ah, 0Eh
    int 10h

    popa
    ret

; Convert LBA to CHS
;
; AX - LBA address
; ---
; CH - Cylinder
; DH - Head
; CL - Sector
lbatochs:
    pusha
    push ax

    ; Cylinder and head
    xor dx, dx
    mov cx, word SECTORS
    div cx

    xor dx, dx
    mov cx, word HEADS
    div cx

    mov byte [.track], al
    mov byte [.head], dl

    ; Sectors
    pop ax
    mov cx, word SECTORS
    div cx
    inc dl ; Sectors start from 1
    mov byte [.sector], dl

    popa
    mov ch, [.track]
    mov dh, [.head]
    mov cl, [.sector]
    ret
    .track db 0
    .head db 0
    .sector db 0


times 512-($-$$) db 0
filetable:
