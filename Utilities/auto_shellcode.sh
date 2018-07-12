#!/bin/bash

printf "\n[+] Assembling with Nasm..."
nasm -f elf32 -o $1.o $1.nasm

printf "\n[+] Linking..."
ld -o $1 $1.o

printf "\n[+] Dumping with objdump...\n"

SHELLCODE=$(for i in $(objdump -d $1.o -M intel | grep "^ " | cut -f2); do echo -n '\x'$i; done)

#printf "${SHELLCODE}"

WRAPPER=$(cat <<-EOF > shellcode.c
#include<stdio.h>
#include<string.h>

unsigned char code[] = "$SHELLCODE";

main()
{
        printf("Shellcode Length: %d\\n", strlen(code));
        int (*ret)() = (int(*)())code;
        ret();
}
EOF
)

#printf "${WRAPPER}"

printf "\n[+] Compiling with GCC...\n"

gcc -o shellcode -fno-stack-protector -z execstack shellcode.c

printf "\n[+] Done!\n\n"