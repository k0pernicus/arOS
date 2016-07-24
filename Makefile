BIN=~/opt/bin
BUILD=build
ASM=src/asm

LD=$(BIN)/x86_64-pc-elf-ld
MKRESCUE=$(BIN)/grub-mkrescue
NASM=nasm
QEMU=qemu-system-x86_64

ISO=arOS.iso
KERNEL=kernel.bin

BOOT_A=boot.asm
BOOT_O=boot.o
GRUB=grub.cfg
LINKER=linker.ld
MULTIBOOT_A=multiboot_header.asm
MULTIBOOT_O=multiboot_header.o

SRC_BOOT=$(ASM)/$(BOOT_A)
SRC_GRUB=$(ASM)/$(GRUB)
SRC_LINKER=$(ASM)/$(LINKER)
SRC_MULTIBOOT=$(ASM)/$(MULTIBOOT_A)

BUILD_MULTIBOOT=$(BUILD)/$(MULTIBOOT_O)
BUILD_BOOT=$(BUILD)/$(BOOT_O)
BUILD_ISO=$(BUILD)/$(ISO)
BUILD_KERNEL=$(BUILD)/$(KERNEL)

default: build 

build: $(BUILD_ISO)

run: $(BUILD_ISO)
	$(QEMU) -cdrom $(BUILD_ISO)

$(BUILD_MULTIBOOT): $(SRC_MULTIBOOT)
	mkdir -p build/
	$(NASM) -f elf64 $< -o $@ 

$(BUILD_BOOT): $(SRC_BOOT)
	mkdir -p build/
	$(NASM) -f elf64 $< -o $@

$(BUILD_KERNEL): $(BUILD_MULTIBOOT) $(BUILD_BOOT) $(SRC_LINKER) 
	$(LD) -n -o $@ -T $(SRC_LINKER) $(BUILD_MULTIBOOT) $(BUILD_BOOT)

$(BUILD_ISO): $(BUILD_KERNEL) $(SRC_GRUB)
	mkdir -p isofiles/boot/grub
	cp $(SRC_GRUB) isofiles/boot/grub
	cp $< isofiles/boot/
	$(MKRESCUE) -o $@ isofiles

.PHONY: clean

clean:
	rm -rf $(BUILD)
	rm -rf isofiles
	rm -f $(ISO)
