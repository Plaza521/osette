format binary as 'bin'
USE16

; kernel file
    db 00000010b          ; Attributes
    dw 0004h              ; Address
    db 4                  ; Size
    db "kernel.bin", 0, 0 ; Name

times 1024 - ($ - $$) db 0
