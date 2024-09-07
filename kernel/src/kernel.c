/* Main kernel Entry code.
*
*  Author : Sagnik
*  Created : 22/4/2022
*/

#include "uart.h"
#include "mmio_lib.h"
#include "print.h"
#include "debug.h"
#include "exception_handler.h"

void main() {

	// uint64_t value = 0x1234567890ABCDEF;
	// char *p = (char*)0xFFFF00000000000;

	// Init UART1 -> Mini UART
	// mini_uart_init();
	// mini_uart_write("Hi ... \nWelcome to PalOS !!!\n");

	// Init UART0
	uart_init();
	printk("\r\nHi ... \nWelcome to PalOS !!!\n\r");
	printk("\r\nABOVE LINES WRITTEN BY UART \r\n");

	printk("\r\n ---- Exception Level : %u\n\r", (uint64_t)get_exceptionLevel());

	init_intr_controller();
	enable_irq();

	// init_timer();
	// Test exception
	// *p = 1;
	// printk("\r\n Exception did not occur !!! \n\n");

	// ASSERT(0);

	while(1) ;
		// mini_uart_update();
}