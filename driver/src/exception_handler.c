/* Exception handler code supporting the ASM code
*
*  Author : Sagnik
*  Created : 4/6/2022
*/

#include "../../toolchain/lib/gcc/aarch64-none-elf/11.2.0/include/stdint.h"
#include "../../kernel/libs/print.h"
#include "../libs/mmio_lib.h"
#include "../libs/exception_handler.h"
#include "../libs/uart.h"

static uint64_t ticks = 0;

void init_intr_controller() {
    mmio_write(DIST, 0);
    mmio_write(CPU_INTERFACE, 0);

    mmio_write(ICC_PR, 0xFF);

    // IRQ number for timer intr = 64 and Register 16th
    mmio_write(ICD_PR + 64, 0);
    mmio_write(ICD_PR + 38*4, 0);

    mmio_write(ICD_PTR + 64, 1);
    mmio_write(ICD_PTR + 38*4, 0x100);

    mmio_write(ICD_ICFGR + 16, 2);  // Set timer intr sensitivity
    mmio_write(ICD_ICFGR + 36, 0x80000);

    mmio_write(ICD_ISENABLE + 8, 1);
    mmio_write(ICD_ISENABLE + 16, (1 << 25));

    mmio_write(DIST, 1);
    mmio_write(CPU_INTERFACE, 1);
}

void init_timer() {

    mmio_write(TIMER_PREDIV, 0x7D);
    mmio_write(TIMER_LOAD, 19841);
    mmio_write(TIMER_CTL, 0b10100010);
}

static void timer_interrupt_handler() {
    uint32_t mask = mmio_read(TIMER_MSKIRQ);

    if (mask & 1) {
        if(ticks % 100 == 0) {
            printk("\r\nTimer : %u\n", ticks);
        }
        ticks++;
        mmio_write(TIMER_ACK, 1);
    }
}

static uint32_t get_irq_number() {
    return mmio_read(ICC_ACK);
}

void handler(uint64_t exception_id, uint64_t esr, uint64_t elr) {
    uint32_t irq_number;
    
    switch (exception_id) {
        case 1:     // Synchronous handller
            printk("\r\nException caused due to sync exception handler\n");
            printk("\r\nESR : %u   ELR: %u\n\n", esr, elr);
            while (1) ;
            break;

        case 2:     // Hardware Interrupt
            irq_number = get_irq_number();
            printk("\r\nSagnik irq : %u",irq_number);
            if (irq_number == 64) {
                timer_interrupt_handler();
            } 
            else if (irq_number == 153) {
                uart_handler();
            } 
            else {
                printk("\r\nUnknown IRQ\n");
                while (1) ;
            }

            mmio_write(ICC_EOI, irq_number);
            break;

        default:    // Unknown handler
            printk("\r\nUnknown Exception\n");
            while (1) ;
            break;
    }
}