BIN=~/opt/bin
BUILD=build

LD=$(BIN)/x86_64-pc-elf-ld
MKRESCUE=$(BIN)/grub-mkrescue
NASM=nasm
QEMU=qemu-system-x86_64

ISO=arOS.iso
KERNEL=kernel.bin

BOOT_A=boot.asm
BOOT_O=boot.o
MULTIBOOT_A=multiboot_header.asm
MULTIBOOT_O=multiboot_header.o

BUILD_MULTIBOOT_A=$(BUILD)/$(MULTIBOOT_A)
BUILD_MULTIBOOT_O=$(BUILD)/$(MULTIBOOT_O)
BUILD_BOOT_A=$(BUILD)/$(BOOT_A)
BUILD_BOOT_O=$(BUILD)/$(BOOT_O)
BUILD_KERNEL=$(BUILD)/$(KERNEL)

default: build 

build: $(ISO)

run: $(ISO)
	$(QEMU) -cdrom $(ISO)

$(BUILD_MULTIBOOT_O): $(MULTIBOOT_A)
	mkdir -p build/
	$(NASM) -f elf64 $< -o $@ 

$(BUILD_BOOT_O): $(BOOT_A)
	mkdir -p build/
	$(NASM) -f elf64 $< -o $@

$(BUILD_KERNEL): $(BUILD_MULTIBOOT_O) $(BUILD_BOOT_O) linker.ld
	$(LD) -n -o $@ -T linker.ld $(BUILD_MULTIBOOT_O) $(BUILD_BOOT_O)

$(ISO): $(BUILD_KERNEL) grub.cfg
	mkdir -p isofiles/boot/grub
	cp grub.cfg isofiles/boot/grub
	cp $< isofiles/boot/
	$(MKRESCUE) -o $@ isofiles

.PHONY: clean

clean:
	rm -rf $(BUILD)
	rm -rf isofiles
	rm -f $(ISO)
