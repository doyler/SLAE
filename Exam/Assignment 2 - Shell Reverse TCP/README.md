# SLAE Exam - Shell Reverse TCP Shellcode (Assignment #2)
Solution for assignment #2 (shell_bind_tcp) of the SLAE exam

For more information, please see the following blog post - https://www.doyler.net/security-not-included/shell-reverse-tcp-shellcode

Contains the Following Applications:
* revshell.c - Shell_Reverse_TCP Application written in C
* shell_reverse_tcp.nasm - Shell_Reverse_TCP Assembly program
* shellcode.c - Shellcode execution wrapper (contains 75 byte shell_reverse_tcp shellcode)
* generate_reverse_shellcode.py - Shellcode generator for shell_reverse_tcp that allows for easy configuration of the IP address and port to connect to