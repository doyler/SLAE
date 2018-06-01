; HelloWorldStack.nasm
; Author: Ray Doyle

global _start
section .text
_start:
    ; Move the value 4 into EAX (system call for write)
    ; Zeros out the register and then uses al to avoid nulls in the resulting shellcode
	xor eax, eax
    mov al, 0x4

	; Move the value 1 into EBX (fd1 = STDOUT)
	xor ebx, ebx
    mov bl, 0x1
	
    ; Zero out the EDX register and push it onto the stack (null terminate the output string)
    xor edx, edx
    push edx
    
    ; Push "Hello World\n" onto the stack in reverse order
    ; "\ndlr"
	push 0x0a646c72
	; "oW o"
    push 0x6f57206f
	; "lleH"
    push 0x6c6c6548
    
    ; Move the stack pointer (points to the beginning of the string) into ECX
    mov ecx, esp
    
    ; Move the value 12 into EDX (length of "Hello World\n1")
    mov dl, 12
    
	; Send an 0x80 interrupt to invoke the system call
	int 0x80

	; Exit the program gracefully
		
	; Move the value 1 into EAX (system call for exit)
	xor eax, eax
    mov al, 0x1

	; Zero out the EBX register for a successful exit status
	xor ebx, ebx

	; Send an 0x80 interrupt to invoke the system call
	int 0x80