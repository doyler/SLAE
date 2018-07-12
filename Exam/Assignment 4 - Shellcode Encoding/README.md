# SLAE Exam - Shellcode Encoding (Assignment #4)
Solution for assignment #4 (shellcode encoding) of the SLAE exam.

Performs a random bytewise XOR + insertion encode, and then decode.

For more information, please see the following blog post - https://www.doyler.net/security-not-included/shellcode-encoding

Contains the Following Applications:
* decode_randxor.nasm - Shellcode decoder stub + location for encoded shellcode (54 bytes)
* shellcode.c - Shellcode execution wrapper (contains 87 byte encoded hello world shellcode)
* randxor_encoder.py - Encodes a provided payload with the random bytewise XOR + insertion