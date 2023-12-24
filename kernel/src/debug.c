/* Code for assertions
*
*  Author : Sagnik
*  Created : 22/5/2022
*/

#include "../libs/debug.h"
#include "../libs/print.h"

void error_check(char *file, uint64_t line)
{
    printk("\r\n -------------------- \r\n");
    printk("  Error Check  ");
    printk("\r\n -------------------- \r\n");
    printk("\rAssertion failed [%s: %u]\r\n", file, line);

    while(1) {}
}