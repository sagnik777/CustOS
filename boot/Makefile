# Compiler and flags
XCOMP = $(BASE_DIR)/crossComp
CC = $(XCOMP)/bin/aarch64-none-elf-gcc
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles -mgeneral-regs-only

# Specify SRC and OBJ folders
SRC_DIR = $(shell pwd)
OBJ_DIR = $(BASE_DIR)/builds/obj

# List of source files
ASMSRC = $(wildcard $(SRC_DIR)/*.S)
OBJ = $(patsubst $(SRC_DIR)/%.S,$(OBJ_DIR)/%.o,$(ASMSRC))

# Rule to compile the assembly file
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	${CC} ${CFLAGS} -c $< -o $@

# Default target to build the object files
all: $(OBJ)

# Clean target
clean:
	rm -f $(BASE_DIR)/builds/obj/*.o

.PHONY: all clean
