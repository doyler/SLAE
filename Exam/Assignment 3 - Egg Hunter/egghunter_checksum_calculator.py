#!/usr/bin/python

# SLAE Exam Assignment #3: Egg Hunter Shellcode (Linux/x86) Checksum Calculator
# Author: Ray Doyle (@doylersec)
# Website: https://www.doyler.net

# Shellcode to calculate the checksum for
payload = "\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x31\xd2\x52\x52\x6a\x0a\x68\x72\x6c\x64\x21\x68\x6f\x20\x57\x6f\x68\x48\x65\x6c\x6c\x89\xe1\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80"

chksum = 0

for byte in bytearray(payload):
    chksum += byte

print "Checksum byte = " + "\\x%0.2X" % (chksum & 0xff)