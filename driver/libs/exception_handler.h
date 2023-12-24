/* Exception handler code supporting the ASM code
*
*  Author : Sagnik
*  Created : 4/6/2022
*/

#ifndef EXCEPTION_HANDLER_H_
#define EXCEPTION_HANDLER_H_

#include "../libs/irq.h"

void init_timer();
void init_intr_controller();
void enable_irq();

#endif