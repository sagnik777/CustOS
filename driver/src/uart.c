/* UART functionalities and setting up the UART.
*
*  Author : Sagnik
*  Created : 22/4/2022
*/

#include "../libs/uart.h"
#include "../libs/mmio_lib.h"

/* --- Defines --- */
#define F_UART_CLK 48000000

/* ---------- Static Functions ---------- */
static int calculate_baudrate_divisor();

/* ---------- Code Starts ---------- */
static int calculate_baudrate_divisor(int baudrate) {
    return ( F_UART_CLK/(16*baudrate) );
}

void uart_init() {
    int baudrate_divisor = calculate_baudrate_divisor(115200);

    mmio_write(UART_0_CR, 0);
    mmio_write(UART_0_IBRD, baudrate_divisor);
    mmio_write(UART_0_FBRD, 0);
    mmio_write(UART_0_LCRH, (1 << 5) | (1 << 6));
    mmio_write(UART_0_IMSC, (1 << 4));
    mmio_write(UART_0_CR, (1 << 0) | (1 << 8) | (1 << 9));
}

unsigned char read_char() {
    // while (mmio_read(UART_0_FR) & (1 << 4)); // Not required while using Uart intr
    return (mmio_read(UART_0_DR));
}

void uart_write_char(unsigned char ch) {
    while ( mmio_read(UART_0_FR) & (1 << 3) );
    mmio_write(UART_0_DR, ch);
}

void uart_write(const char *ch) {
    for (int i = 0; ch[i] != '\0'; i++) {
        uart_write_char(ch[i]);
    }
}

void uart_handler() {
    uint32_t status = mmio_read(UART_0_MIS);    //receive interrup status bit 4

    if (status & (1 << 4)) {
        char ch = read_char();
        
        if (ch == '\r') {
            uart_write("\r\n");
        } else {
            uart_write_char(ch);
        }

        mmio_write(UART_0_ICR, (1 << 4));
    }
}