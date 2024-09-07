/* Headers for generic printk, for kernel prints and logs
*
*  Author : Sagnik
*  Created : 27/4/2022
*/

#ifndef PRINT_H_
#define PRINT_H_

#include "stdint.h"
#include "stdint.h"
#include "stdarg.h"

#define MAX_CAPTURES 1024

int printk(const char *format, ...);

#endif