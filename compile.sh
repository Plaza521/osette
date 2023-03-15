#!/bin/bash

mkdir bin
mkdir img

echo
echo
fasm bootloader.asm bin/bootloader.bin
echo
echo

dd if=/dev/zero of=img/boot.img bs=1024 count=1440
dd if=bin/bootloader.bin of=img/boot.img conv=notrunc
