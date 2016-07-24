BIN=~/opt/bin
LD=$(BIN)/x86_64-pc-elf-ld
MKRESCUE=$(BIN)/grub-mkrescue
NASM=nasm
QEMU=qemu-system-x86_64

ISO=arOS.iso
KERNEL=kernel.bin

default: build 

build: $(ISO)

run: $(ISO)
	$(QEMU) -cdrom $(ISO)

multiboot_header.o: multiboot_header.asm
	$(NASM) -f elf64 multiboot_header.asm

boot.o:	boot.asm
	$(NASM) -f elf64 boot.asm

$(KERNEL): multiboot_header.o boot.o linker.ld
	$(LD) -n -o $@ -T linker.ld multiboot_header.o boot.o

$(ISO): $(KERNEL) grub.cfg
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp $< isofiles/boot/
	$(MKRESCUE) -o $@ isofiles

.PHONY: clean

clean:
	rm -f multiboot_header.o
	rm -f boot.o
	rm -f $(KERNEL)
	rm -rf isofiles
	rm -f $(ISO)
