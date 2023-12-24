/* IRQ related headers
*
*  Author : Sagnik
*  Created : 4/6/2022
*/

#ifndef IRQ_H_
#define IRQ_H_

#define GIC_BASE        0xFF840000
#define BASE_ADDR       0xFE000000

// Hardware intr as per Rpi4
enum intr_controller {
    DIST            = GIC_BASE + 0x1000,
    ICD_TYPE        = DIST + 0x4,
    ICD_ISENABLE    = DIST + 0x100,
    ICD_ICENABLE    = DIST + 0x180,
    ICD_SET_PENDING = DIST + 0x200,
    ICD_SET_ACTIVE  = DIST + 0x300,
    ICD_PR          = DIST + 0x400,
    ICD_PTR         = DIST + 0x800,
    ICD_GROUP       = DIST + 0x80,
    ICD_ICFGR       = DIST + 0xC00
};

enum cpu_interface {
    CPU_INTERFACE   = GIC_BASE + 0x2000,
    ICC_PR          = CPU_INTERFACE + 0x4,
    ICC_ACK         = CPU_INTERFACE + 0xC,
    ICC_EOI         = CPU_INTERFACE + 0x10
};

enum timer_controller {
    TIMER_LOAD      = BASE_ADDR + 0xB400,
    TIMER_CTL       = BASE_ADDR + 0xB408,
    TIMER_ACK       = BASE_ADDR + 0xB40C,
    TIMER_MSKIRQ    = BASE_ADDR + 0xB414,
    TIMER_PREDIV    = BASE_ADDR + 0xB41C
};

#endif