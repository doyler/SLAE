; HelloWorld.nasm
; Author: Ray Doyle

; Global identifier - identifies that "_start" is the entry point
global _start

; Text section - where the program code lives
section .text

; The entry point of the program
_start:
    ;
    ; Print "Hello World!" on the screen
    ;

    ; Move the value 4 into EAX (system call for write)
    mov eax, 4

    ; Move the value 1 into EBX (fd1 = STDOUT)
    mov ebx, 1

    ; Move the pointer to the string into ECX via its label
    mov ecx, message

    ; Move the value 12 into EDX (length of "Hello World!")
    ;mov edx, 12
    mov edx, mlen

    ; Send an 0x80 interrupt to invoke the system call
    int 0x80

    ;
    ; Exit the program gracefully
    ;
    
    ; Move the value 1 into EAX (system call for exit)
    mov eax, 1

    ; Move the value 5 into EBX (arbitrary value for exit status)
    mov ebx, 5

    ; Send an 0x80 interrupt to invoke the system call
    int 0x80

; Data section - where all the initialized data is located
section .data
    ; Defining and storing the "Hello World!" string
    ; Label "message" used for this string
    ; db = define byte or series of bytes
    message: db "Hello World!"

    ; Define an mlen value that is equal to the length of message
    ; This is a shortcut that NASM understands and computes
    mlen equ $-message