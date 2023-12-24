/* Headers for UART related defines and registers
*
*  Author : Sagnik
*  Created : 22/4/2022
*/

#ifndef UART_H_
#define UART_H_

#define IO_PERIPHERAL_BASE  0xFE200000

/* ---------- UART registers Map ---------- */
// UART1 (GPIO 14, 15 -> Alt5)
enum {
    AUX_BASE        = IO_PERIPHERAL_BASE + 0x15000,
    AUX_IRQ         = AUX_BASE,
    AUX_ENABLES     = AUX_BASE + 0x04,
    AUX_MU_IO_REG   = AUX_BASE + 0x40,
    AUX_MU_IER_REG  = AUX_BASE + 0x44,
    AUX_MU_IIR_REG  = AUX_BASE + 0x48,
    AUX_MU_LCR_REG  = AUX_BASE + 0x4C,
    AUX_MU_MCR_REG  = AUX_BASE + 0x50,
    AUX_MU_LSR_REG  = AUX_BASE + 0x54,
    AUX_MU_CNTL_REG = AUX_BASE + 0x60,
    AUX_MU_BAUD_REG = AUX_BASE + 0x68,
    UART_MAX_QUEUE  = 16 * 1024,
    AUX_UART_CLOCK  = 500000000     //Core frequency (GPU)
};

// UART0 (GPIO 14,15 -> Alt0 Default function)
enum {
    UART_0_BASE     = IO_PERIPHERAL_BASE + 0x1000,
    UART_0_DR       = UART_0_BASE + 0x00,
    UART_0_FR       = UART_0_BASE + 0x18,
    UART_0_IBRD     = UART_0_BASE + 0x24,
    UART_0_FBRD     = UART_0_BASE + 0x28,
    UART_0_LCRH     = UART_0_BASE + 0x2C,
    UART_0_CR       = UART_0_BASE + 0x30,
    UART_0_IMSC     = UART_0_BASE + 0x38,
    UART_0_MIS      = UART_0_BASE + 0x40,
    UART_0_ICR      = UART_0_BASE + 0x44
};

// #define MU_BAUDRATE(baud) AUX_UART_CLOCK/((baud + 1)* 8)

// Mini Uart Public functions
// void mini_uart_init();
// void mini_uart_update();
// void mini_uart_write(char *data);

// Uart Public Functions
unsigned char read_char();
void uart_write_char(unsigned char ch);
void uart_write(const char *ch);
void uart_init();
void uart_handler();

#endif