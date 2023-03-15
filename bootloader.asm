format binary as 'bin'
USE16

org 7C00h

jmp code
fs_data:
BOOT_DRV db 0
TBL_SIZE db 2
TBL_STRT db 3
code:
    mov dl, [BOOT_DRV]
    mov ax, word [0410h]
    mov word [DETECTED_HARDWARE], ax
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    cli
    mov ss, ax
    mov sp, 1000h
    sti

    mov ax, 3
    int 10h

    mov ax, 1301h
    mov cx, 10
    mov bp, .message
    xor dx, dx
    mov bx, 7
    int 10h

    mov ax, 204h
    mov cx, 2
    mov dl, [BOOT_DRV]
    xor dh, dh
    mov bx, secstage
    int 13h
    jc booterror

    jmp secstage
.message db "Loading..."

; Print unsigned int
;
; AX - Num to convert
its:
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

booterror:
    mov [errcode], ah
    mov ax, 3
    int 10h
    mov ax, 1301h
    mov bx, 7
    xor dx, dx
    mov cx, 13
    mov bp, .message
    int 10h
    xor ax, ax
    mov al, [errcode]
    call its
    cli
    hlt
.message db "Error! Code: "
errcode db 0

times 444-($-$$) db 0
DETECTED_HARDWARE dw 0
MBR:
MBR_1:
    ; partition 1 (contains the kernel code)
    boot_indicator: db 0x80 ; mark as bootable
    starting_head: db 0x0
    starting_sector: db 0x1 ; bits 5-0 for sector and bits 7-6 are upper bits of cylinder
    starting_cylinder: db 0x0
    system_id: db 0x7f ; just some ID that has not been used for anything else by standard
    ; the last sector of the partition should be 2880
    ending_head: db 1 ; here I assume the maximum number of heads as 255
    ending_sector: db 4
    ending_cylinder: db 0x0
    first_sector_lba: dd 0x1 ; first sector after the bootsector
    total_sectors_in_partition: dd 21 ; 2880-1 because first sector is bootsector

; partitions 2-4 are unused and therefore set to 0
MBR_2:
    times 16 db 0
MBR_3:
    times 16 db 0
MBR_4:
    times 16 db 0

dw 0xAA55
secstage:
