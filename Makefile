# Wildcards for all files
CFILES = $(wildcard kernel/src/*.c driver/src/*.c)
SFILES = $(wildcard driver/src/*.S)
HEADERS = $(wildcard kernel/libs/*.h driver/libs/*.h)

OBJ = ${CFILES:.c=.o} 
S_OBJ = ${SFILES:.S=.o}

# GCC and C flags
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles -mgeneral-regs-only
BINPATH = /root/Desktop/PalOS/toolchain/bin
CC = /root/Desktop/PalOS/toolchain/bin/aarch64-none-elf-gcc

#Output directories

boot.o: boot/boot.S
	${CC} ${CFLAGS} -c boot/boot.S -o builds/boot.o

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.S
	${CC} ${CFLAGS} -c $< -o $@

kernel8.img: boot.o ${S_OBJ} ${OBJ}
	${BINPATH}/aarch64-none-elf-ld -nostdlib -T linkScript.ld -o builds/kernel8.elf builds/boot.o ${S_OBJ} ${OBJ}
	${BINPATH}/aarch64-none-elf-objcopy -O binary builds/kernel8.elf builds/kernel8.img

release: kernel8.img

clean:
	rm -rfv builds/*
	rm -rfv kernel/src/*.o boot/*.o driver/src/*.o
