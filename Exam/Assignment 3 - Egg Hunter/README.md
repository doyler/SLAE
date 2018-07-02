# SLAE Exam - Egg Hunter Shellcode (Assignment #3)
Solution for assignment #3 (egghunter) of the SLAE exam

For more information, please see the following blog post - https://www.doyler.net/security-not-included/egg-hunter-shellcode

Contains the Following Applications:
* egghunter.nasm - Egg hunter Assembly program (50 bytes)
* shellcode.c - Shellcode execution wrapper (contains 52 byte hello world shellcode including eggs and checksum)
* egghunter_checksum_calculator.py - Calculates the egg hunter checksum byte for a provided payload