.global delay
.global mmio_write
.global mmio_read
.global get_exceptionLevel

delay:
    SUBS X0, X0, #1
    BNE delay
    ret

mmio_write:
    STR W1, [X0]
    ret

mmio_read:
    LDR W0, [X0]
    ret

get_exceptionLevel:
    MRS X0, CurrentEL
    LSR X0, X0, #2
    ret