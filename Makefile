default: build 

build: arOS.iso

run: arOS.iso
	qemu-system-x86_64 -cdrom arOS.iso

multiboot_header.o: multiboot_header.asm
	nasm -f elf64 multiboot_header.asm

boot.o:	boot.asm
	nasm -f elf64 boot.asm

kernel.bin: multiboot_header.o boot.o linker.ld
	~/opt/bin/x86_64-pc-elf-ld -n -o kernel.bin -T linker.ld multiboot_header.o boot.o

arOS.iso: kernel.bin grub.cfg
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp kernel.bin isofiles/boot/
	~/opt/bin/grub-mkrescue -o arOS.iso isofiles

.PHONY: clean

clean:
	rm -f multiboot_header.o
	rm -f boot.o
	rm -f kernel.bin
	rm -rf isofiles
	rm -f arOS.iso
