# XOR Decoder Shellcode
Decodes shellcode that has been encoded using a XOR encoder using Linux x86 Assembly.
An encoder is included as well, and just requires a working shellcode to be passed as input.
For more information, see the following blog post - https://www.doyler.net/security-not-included/shellcode-xor-encoder-decoder

Contains:
* xor_decoder_marker.nasm - XOR decoder stub that jumps to decoded shellcode
* shellcode.c - Shellcode execution wrapper (currently contains XOR encoded execve '/bin/sh' shellcode)
* XOREncoder.py - Takes in a custom shellcode, and XOR encodes each byte