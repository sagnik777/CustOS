/* Headers for assertions
*
*  Author : Sagnik
*  Created : 22/5/2022
*/

#ifndef _DEBUG_H_
#define _DEBUG_H_

#include "../../toolchain/lib/gcc/aarch64-none-elf/11.2.0/include/stdint.h"

#define ASSERT(e) do {                     \
    if(!(e))                               \
        error_check(__FILE__, __LINE__);   \
} while(0)

void error_check(char *file, uint64_t line);

#endif