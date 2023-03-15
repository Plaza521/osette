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

    mov ah, 0Eh
    mov al, 'a'
    int 10h

    jmp $

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
