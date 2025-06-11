; boot.asm
[bits 16]
[org 0x7c00]

KERNEL_OFFSET equ 0x1000   ; Load kernel at 1MB

start:
    mov [BOOT_DRIVE], dl    ; BIOS stores boot drive in dl
    mov bp, 0x9000          ; Setup stack
    mov sp, bp

    ; Load kernel
    mov bx, KERNEL_OFFSET
    mov dh, 15              ; Load 15 sectors (7.5KB)
    mov dl, [BOOT_DRIVE]
    call disk_load

    ; Switch to protected mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; Update segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000        ; 32-bit stack
    mov esp, ebp
    jmp KERNEL_OFFSET       ; Jump to kernel

%include "disk.asm"
%include "gdt.asm"

BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xaa55
