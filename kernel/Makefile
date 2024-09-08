# Compiler and flags
XCOMP = $(BASE_DIR)/crossComp
CC = $(XCOMP)/bin/aarch64-none-elf-gcc
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles -mgeneral-regs-only
TOOLCHAIN_LIBS = $(XCOMP)/lib/gcc/aarch64-none-elf/13.2.0/include

# Specify SRC and OBJ folders
SRC_DIR = $(shell pwd)/src
OBJ_DIR = $(BASE_DIR)/builds/obj

# List of source files
CSRC = $(wildcard $(SRC_DIR)/*.c)
COBJ = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(CSRC))
HEADERS = $(wildcard libs/*.h $(TOOLCHAIN_LIBS)/*.h)

# Add all Includes
INCLUDE_DIR := -I $(TOOLCHAIN_LIBS)	\
			   -I libs/				\
			   -I ../driver/libs/

# Rule to compile C source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(HEADERS)
	${CC} ${CFLAGS} $(INCLUDE_DIR) -c $< -o $@

# Default target
all: $(COBJ)

# Clean target
clean:
	rm -f $(BASE_DIR)/builds/obj/*.o

.PHONY: all clean
