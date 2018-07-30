# SLAE Exam - Polymorphic Shellcode (Assignment #6)
Solutions for assignment #6 (polymorphic shellcode) of the SLAE exam.

For more information, please see the following blog post:
* https://www.doyler.net/security-not-included/polymorphic-shellcode

Contains the Following Applications (no null bytes or hardcoded addresses):
* poly_modify_hosts - Adds a new entry to the hosts file for "127.1.1.1 google.com"
* poly_rot7_execve - ROT7 encoded execve /bin/bash
* poly_add_user - Adds a new user 'r00t' with no password to /etc/passwd