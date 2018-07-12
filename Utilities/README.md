# SLAE - Utilities
Utility programs or scripts that I found useful during my SLAE journey.

Contains the Following Applications:
* compile.sh - Quick bash script (written by Vivek) to compile and link a .nasm file
* auto_shellcode.sh - Bash script to compile and link a .nasm file, extract the shellcode with objdump, create a C wrapper containing the shellcode, and compile the C program using GCC
* reverse.py - Utility program (written by Vivek) to easily prepare a string to be placed on the stack
* unReverse.py - Utility program (by me) to easily convert push <little-endian string> statements to their original string format