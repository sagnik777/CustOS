.section ".text.boot"
.global vector_table
.global enable_irq

.balign 0x800
vector_table:

    // Vector Table for CurrentEl SP0
    current_el_sp0_sync:
        B error

    .balign 0x80
    current_el_sp0_irq:
        B error

    .balign 0x80
    current_el_sp0_fiq:
        B error

    .balign 0x80
    current_el_sp0_serror:
        B error

    // Vector Table for CurrentEL SPn
    .balign 0x80
    current_el_spn_sync:
        B sync_handler

    .balign 0x80
    current_el_spn_irq:
        B irq_handler

    .balign 0x80
    current_el_spn_fiq:
        B error

    .balign 0x80
    current_el_spn_serror:
        B error

    // Vector Table for LowerEL using AArch64
    .balign 0x80
    current_el_aarch64_sync:
        B error

    .balign 0x80
    current_el_aarch64_irq:
        B error

    .balign 0x80
    current_el_aarch64_fiq:
        B error

    .balign 0x80
    current_el_aarch64_serror:
        B error

    // Vector Table for LowerEL using AArch32
    .balign 0x80
    current_el_aarch32_sync:
        B error

    .balign 0x80
    current_el_aarch32_irq:
        B error

    .balign 0x80
    current_el_aarch32_fiq:
        B error

    .balign 0x80
    current_el_aarch32_serror:
        B error

    // Sync_Handler
    sync_handler:
        BL store_reg       // Load registers to stack for safety
    
        MOV X0, #1      // 1 => Represents Sync Error
        MRS X1, esr_el1
        MRS X2, elr_el1
        BL handler

        BL load_reg        // Pop out the saved values
        eret

    // IRQ handler
    irq_handler:
        BL store_reg       // Load registers to stack for safety
    
        MOV X0, #2          // 2 => Hardware Interrupt
        MRS X1, esr_el1
        MRS X2, elr_el1
        BL handler

        BL load_reg        // Pop out the saved values
        eret

    enable_irq:
        MSR daifclr, #2
        ret

    // Error
    error: 
        BL store_reg

        MOV X0, #0      // 0 => Represents unknown error
        BL handler      // Call c code handler

        BL load_reg
        eret

    // Store Registers to stack (PUSH)
    store_reg:
        SUB SP, SP, #(32 * 8)
        STP X0, X1, [SP]
        STP X2, X3, [SP, #(16 * 1)]
        STP X4, X5, [SP, #(16 * 2)]
        STP X6, X7, [SP, #(16 * 3)]
        STP X8, X9, [SP, #(16 * 4)]
        STP X10, X11, [SP, #(16 * 5)]
        STP X12, X13, [SP, #(16 * 6)]
        STP X14, X15, [SP, #(16 * 7)]
        STP X16, X17, [SP, #(16 * 8)]
        STP X18, X19, [SP, #(16 * 9)]
        STP X20, X21, [SP, #(16 * 10)]
        STP X22, X23, [SP, #(16 * 11)]
        STP X24, X25, [SP, #(16 * 12)]
        STP X26, X27, [SP, #(16 * 13)]
        STP X28, X29, [SP, #(16 * 14)]
        STR X30, [SP, #(16 * 15)]

        ret

    // Restore registers out of stack (POP)
    load_reg:
        LDP X0, X1, [SP]
        LDP X2, X3, [SP, #(16 * 1)]
        LDP X4, X5, [SP, #(16 * 2)]
        LDP X6, X7, [SP, #(16 * 3)]
        LDP X8, X9, [SP, #(16 * 4)]
        LDP X10, X11, [SP, #(16 * 5)]
        LDP X12, X13, [SP, #(16 * 6)]
        LDP X14, X15, [SP, #(16 * 7)]
        LDP X16, X17, [SP, #(16 * 8)]
        LDP X18, X19, [SP, #(16 * 9)]
        LDP X20, X21, [SP, #(16 * 10)]
        LDP X22, X23, [SP, #(16 * 11)]
        LDP X24, X25, [SP, #(16 * 12)]
        LDP X26, X27, [SP, #(16 * 13)]
        LDP X28, X29, [SP, #(16 * 14)]
        LDR X30, [SP, #(16 * 15)]
        ADD SP, SP, #(32 * 8)

        ret