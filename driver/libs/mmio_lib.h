#ifndef MMIO_LIBS_H_
#define MMIO_LIBS_H_

#include "../../toolchain/lib/gcc/aarch64-none-elf/11.2.0/include/stdint.h"

// MMIO Functionalities 
void delay(uint64_t value);
void mmio_write(uint64_t address, uint32_t value);
uint32_t mmio_read(uint64_t address);
unsigned char get_exceptionLevel();

// Memory Related functions
void memset(void *dest, int value, unsigned int size);
int memcmp(void *src1, void *src2, unsigned int size);
void memcpy(void *dest, void *src, unsigned int size);

#endif