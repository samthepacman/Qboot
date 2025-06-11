gdt_start:
dq 0x0000000000000000
dq 0x00cf9a000000ffff
dq 0x00cf92000000ffff
gdt_descriptor:
dw gdt_end - gdt_start - 1
dd gdt_start
gdt_end:
