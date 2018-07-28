# SLAE Exam - Metasploit Shellcode Analysis (Assignment #5)
Solution(s) for assignment #5 (Metasploit shellcode analysis) of the SLAE exam.

For more information, please see the following blog posts:
* https://www.doyler.net/security-not-included/metasploit-shellcode-analysis
* https://www.doyler.net/security-not-included/metasploit-adduser-analysis
* https://www.doyler.net/security-not-included/metasploit-exec-analysis

Contains the Following Applications (no null bytes or hardcoded addresses):
* metasploit_read_passwd.nasm - Reads the /etc/passwd file and outputs the contents
* metasploit_adduser.nasm - Adds a new user with the credentials metasploit/passw0rd and ID=0
* metasploit_exec.nasm - Executes `/bin/sh -c 'cat /etc/passwd'`