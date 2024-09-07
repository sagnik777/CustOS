# Compiler and flags
XCOMP = $(BASE_DIR)/crossComp
CC = $(XCOMP)/bin/aarch64-none-elf-gcc
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles -mgeneral-regs-only
TOOLCHAIN_LIBS = $(XCOMP)/lib/gcc/aarch64-none-elf/13.2.0/include

# Specify SRC and OBJ folders
SRC_DIR = $(shell pwd)/src
OBJ_DIR = $(BASE_DIR)/builds

# List of source files
CSRC = $(wildcard $(SRC_DIR)/*.c)
ASMSRC = $(wildcard $(SRC_DIR)/*.S)
COBJ = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(CSRC))
ASMOBJ = $(patsubst $(SRC_DIR)/%.S,$(OBJ_DIR)/%.o,$(ASMSRC))
HEADERS = $(wildcard libs/*.h $(TOOLCHAIN_LIBS)/*.h)

# Add all Includes
INCLUDE_DIR := -I $(TOOLCHAIN_LIBS)	\
			   -I libs/				\
			   -I ../kernel/libs/

# Rule to compile C source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	${CC} ${CFLAGS} $(INCLUDE_DIR) -c $< -o $@

# Rule to compile assembly files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	${CC} ${CFLAGS} -c $< -o $@

# Default target
all: $(COBJ) $(ASMOBJ)

# Clean target
clean:
	rm -f ../builds/*.o

.PHONY: all clean
