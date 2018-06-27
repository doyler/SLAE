; Filename: execve.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: Execute /bin/bash

global _start            

section .text

_start:
    jmp short call_shellcode

shellcode:
    ; JMP - CALL - POP  =  ESI now contains message
    pop esi    

    ; Zero out the EBX register (will be used for filename)
    xor ebx, ebx
    
    ; Move BL (0x0) into [ESI+9] (the "A" in message) to null terminate /bin/bash
    mov byte [esi+9], bl

    ; Move ESI (the location of /bin/bash) into [ESI+10] (the "BBBB" in message)
    mov dword [esi+10], esi

    ; Move EBX (0x00000000) into [ESI+10] (the "CCCC" in message)
    mov dword [esi+14], ebx

    ; Load the null-terminated "/bin/bash" string into EBX for execve's filename
    lea ebx, [esi]

    ; Load the address of /bin/bash into ECX for execve's argv
    lea ecx, [esi+10]

    ; Load the address of the null bytes into EDX for execve's envp
    lea edx, [esi+14]

    ; Zero out the EAX register
    xor eax, eax
    
    ; Load 11 (sys_execve) into EAX
    mov al, 0xb

    ; Call interrupt 0x80 to execute the syscall
    int 0x80

call_shellcode:
    call shellcode

    ; The CALL places this at the top of the stack
    message db "/bin/bashABBBBCCCC"