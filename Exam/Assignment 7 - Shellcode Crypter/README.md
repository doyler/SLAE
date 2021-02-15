# SLAE Exam - Shellcode Crypter (Assignment #7)
Solution for assignment #7 (custom shellcode crypter) of the SLAE exam.

For more information, please see the following blog post:
* https://www.doyler.net/security-not-included/custom-shellcode-crypter

Contains the Following Applications:
* tea_encrypt.py - Encrypts a provided shellcode using the Tiny Encryption Algorithm - https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm
* tea_decrypt.nasm - Decrypts and executes a shellcode encrypted with TEA
