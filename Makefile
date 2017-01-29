ASM=src/asm
LIBCORE=libcore
TARGET=target

LD=ld
MKRESCUE=grub-mkrescue
NASM=nasm
QEMU=qemu-system-x86_64

LIBCORE_URL=http://github.com/intermezzos/libcore

ISO=arOS.iso
KERNEL=kernel.bin

AROS_CFIG=x86_64-unknown-aros-gnu
AROS_JSON=$(AROS_CFIG).json
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

BUILD_BOOT=$(TARGET)/$(BOOT_O)
BUILD_ISO=$(TARGET)/$(ISO)
BUILD_KERNEL=$(TARGET)/$(KERNEL)
BUILD_LIBAROS=$(TARGET)/$(AROS_CFIG)/release/libaros.a
BUILD_LIBCORE=$(TARGET)/$(LIBCORE)
BUILD_LIBCORE_STATIC=$(TARGET)/$(LIBCORE)/$(TARGET)/$(AROS_CFIG)/libcore.rlib
BUILD_MULTIBOOT=$(TARGET)/$(MULTIBOOT_O)

default: build 

build: $(BUILD_ISO)

run: $(BUILD_ISO)
	$(QEMU) -cdrom $(BUILD_ISO)

$(BUILD_MULTIBOOT): $(SRC_MULTIBOOT)
	mkdir -p $(TARGET)/
	$(NASM) -f elf64 $< -o $@ 

$(BUILD_BOOT): $(SRC_BOOT)
	mkdir -p $(TARGET)/
	$(NASM) -f elf64 $< -o $@

$(BUILD_KERNEL): $(BUILD_MULTIBOOT) $(BUILD_BOOT) $(SRC_LINKER) xargo
	$(LD) -n -o $@ -T $(SRC_LINKER) $(BUILD_MULTIBOOT) $(BUILD_BOOT) $(BUILD_LIBAROS)

$(BUILD_ISO): $(BUILD_KERNEL) $(SRC_GRUB)
	mkdir -p $(TARGET)/isofiles/boot/grub
	cp $(SRC_GRUB) $(TARGET)/isofiles/boot/grub
	cp $< $(TARGET)/isofiles/boot/
	$(MKRESCUE) -o $@ $(TARGET)/isofiles

xargo: 
	xargo build --release --target $(AROS_CFIG)

.PHONY: clean

clean:
	xargo clean
