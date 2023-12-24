// Linker should have this section at start of kernel image
.section ".text.boot"

// Entry point for boot code
.global _start

_start:
	/* Check processor ID is 0 => Master core to execute the boot code
	*  MPIDR_EL1 gives the status of the processor 
	*  Bit 0,1 => Gives the cores status
	*  Keep the execution in wait, till the BIT 0,1 = 00 (Master Core)
	*
	*/
	MRS X1, MPIDR_EL1
	AND X1, X1, #3		// Check for 00 = master core
	CBZ X1, L2

L1:	// If the main core not present keep waiting for event
	WFE
	B L1

L2:	// Setup Stack below our current code => Stack grows downwards

	// Check current exceptionLevel, read currentEL
	MRS X0, currentel	// Check reg currentEL and check Bit 2 for EL
	LSR X0, X0, #2
	CMP X0, #2			// Check if EL2 (Kernel state)
	BNE End				// If EL is not EL2, then error

	MSR sctlr_el1, XZR	// Set system control register to zero
	MOV X0, #(1 << 31)
	MSR hcr_el2, X0		// Set the bit 31 of HCR_EL2 to 1 (EL1)

	//Set to EL1
	MOV X0, #0b1111000101	// Set DAIF flags and Mode to EL1 -> 0101
	MSR spsr_el2, X0

	ADR X0, el1_entry
	MSR elr_el2, X0

	eret

el1_entry:
	LDR X1, =_start		// Get the memory location of _start
	MOV SP, X1			// Give stack pointer the memory location of _start

	// Define and inititalize the BSS section
	LDR X1, =__bss_start	// Start addresss
	LDR W2, =__bss_size	// Size of section

L3:	// Clean the BSS segment => Set to 0
	CBZ W2, L4
	STR XZR, [X1], #8
	SUB W2, W2, #1
	CBNZ W2, L3

L4: 	// If all above are proper, Jump to kernel code

	// Load the vector table to VBAR
	LDR X0, =vector_table
	MSR vbar_el1, X0
	
	BL main		// Branch and load the kernel code, DO NOT return here
	
End:	// If return from the kernel, halt master and loop it.
	B End