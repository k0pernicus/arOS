BIN=~/opt/bin
LD=$(BIN)/x86_64-pc-elf-ld
GBRESCURE=$(BIN)/grub-mkrescue

ISO=arOS.iso

default: build 

build: $(ISO)

run: $(ISO)
	qemu-system-x86_64 -cdrom $(ISO)

multiboot_header.o: multiboot_header.asm
	nasm -f elf64 multiboot_header.asm

boot.o:	boot.asm
	nasm -f elf64 boot.asm

kernel.bin: multiboot_header.o boot.o linker.ld
	$(LD) -n -o kernel.bin -T linker.ld multiboot_header.o boot.o

$(ISO): kernel.bin grub.cfg
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp kernel.bin isofiles/boot/
	$(GBRESCURE) -o $@ isofiles

.PHONY: clean

clean:
	rm -f multiboot_header.o
	rm -f boot.o
	rm -f kernel.bin
	rm -rf isofiles
	rm -f $(ISO)
