# Execve Shellcode
Executes the sys_execve system call using Linux x86 Assembly. Assembly is written to allow the programs to be converted into shellcode (no hardcoded addresses or NULL bytes).
Multiple versions are included, as well as a Python application to generate shellcode.
For more information, see the following blog post - https://www.doyler.net/security-not-included/execve-shellcode-generator

Contains:
* execve.nasm - Execve shellcode (/bin/bash) utilizing the JMP-CALL-POP technique
* execve-stack.nasm - Execve shellcode (/bin/bash) using the stack
* execve-argv.nasm - Execve shellcode (/bin/ls) including argument (-al) using JMP-CALL-POP
* execve-argv-stack.nasm - Execve shellcode including arguments (/bin/ls -a) utilizing the stack
* shellcode.c - Shellcode execution wrapper (currently contains execve '/bin/cat /etc/shadow' shellcode)
* execve-shellcode-generator.py - Execve shellcode generator that allows for custom binaries and arguments