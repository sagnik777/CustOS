.global memset
.global memcpy
.global memcmp

/*
* memset function : Store destination buffer with the value till size = 0
* X0 : destination buffer | X1 : Value to store | X2 : size
*/
memset:
    CMP X2, #0      // Check the Size is 0 or not
    BEQ memset_end

set:
    STRB W1, [X0], #1
    SUBS X2, X2, #1
    BNE set

memset_end:
    ret

/*
* memcmp function: Compare src1 and src2 and return 0 : Equal | 1 : Not Equal
* X0 : SRC1 | X1 : SRC2 | X2 : size
* Return value is stored in X0, SRC1
*/
memcmp:
    MOV X3, X0      // Store the X0 value to X3 for ease
    MOV X0, #0      // Keep return value as SUCCESS (0)

compare: 
    CMP X2, #0      // Check the size
    BEQ memcmp_end

    LDRB W4, [X3], #1   // Load SRC1 (X3) to W4
    LDRB W5, [X1], #1   // Load SRC2 (X1) to W5
    SUBS X2, X2, #1
    CMP W4, W5
    BEQ compare

    MOV X0, #1      // Compare is not equal so return FAILURE (1)

memcmp_end:
    ret

/*
* memcpy function: Copy the src to dest
* X0 : DEST | X1 : SRC | X2 : Size
*/
memcpy:
    CMP X2, #0      // Check size
    BEQ memcpy_end

    MOV X4, #1

    CMP X0, X1
    BHS copy
    ADD X3, X1, X2  // Add src address + size => approx address of dest
    CMP X3, X0      // Check if destination address is more than approx
    BLS copy        // If X3 is less or equal => Normal case

overlap_copy:
    SUB X3, X2, #1
    ADD X0, X0, X3
    ADD X1, X1, X3
    NEG X4, X4

copy:  
    LDRB W3, [X1]
    STRB W3, [X0]
    ADD X0, X0, X4
    ADD X1, X1, X4
    
    SUBS X2, X2, #1
    BNE copy

memcpy_end:
    ret