# HelloWorld Shellcode
Prints "Hello World!" using Linux x86 Assembly. Assembly is written to allow the program to be converted into shellcode (no hardcoded addresses or NULL bytes).
For more information, see the following blog post - https://www.doyler.net/security-not-included/hello-world-shellcode

Contains:
* HelloWorldShellcode.nasm - Hello World shellcode utilizing the JMP-CALL-POP technique
* HelloWorldStack.nasm - Hello World shellcode using the stack
* shellcode.c - Shellcode execution wrapper (currently contains HelloWorldStack shellcode)
* reverse.py - Utility program (written by Vivek) to easily prepare a string to be placed on the stack