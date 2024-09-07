# Custom Compiler
BASE_DIR = $(shell pwd)
export BASE_DIR
XCOMP = $(BASE_DIR)/crossComp/bin

# Subdirectories
SD_BOOT := $(BASE_DIR)/boot
SD_KERNEL = $(BASE_DIR)/kernel
SD_DRIVER = $(BASE_DIR)/driver

# Default target: builds everything
all: kernel8.img

# Link all object files to create the final kernel8.img
kernel8.img:
	@mkdir -p builds
	@echo "========== Compiling Subdirectories"
	$(MAKE) -C $(SD_BOOT) all
	$(MAKE) -C $(SD_KERNEL) all
	$(MAKE) -C $(SD_DRIVER) all
	@echo "========== Linking object files"
	$(XCOMP)/aarch64-none-elf-ld -nostdlib -T linkScript.ld -o builds/kernel8.elf builds/*.o
	$(XCOMP)/aarch64-none-elf-objcopy -O binary builds/kernel8.elf builds/kernel8.img

# Release target (e.g., to copy kernel8.img to SD card or similar)
release: all
	@echo "Releasing kernel8.img..."

# Clean up all object files and builds directory
clean:
	rm -rf builds/*
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f boot/*.o kernel/src/*.o driver/src/*.o

.PHONY: all release clean $(SUBDIRS)
