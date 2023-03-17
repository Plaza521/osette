#!/bin/bash

mkdir bin -p
mkdir img -p

echo
echo
fasm bootloader.asm bin/bootloader.bin
echo
fasm secstage.asm bin/secstage.bin
echo
fasm filetable.asm bin/filetable.bin
echo
echo

dd if=/dev/zero of=img/boot.img bs=1024 count=1440
dd if=bin/bootloader.bin of=img/boot.img conv=notrunc
dd if=bin/secstage.bin of=img/boot.img conv=notrunc bs=512 seek=1
dd if=bin/filetable.bin of=img/boot.img conv=notrunc bs=512 seek=2
