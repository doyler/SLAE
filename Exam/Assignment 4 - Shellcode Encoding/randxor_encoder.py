#!/usr/bin/python

# SLAE Exam Assignment #4: Shellcode Encoding (Linux/x86) - Random Bytewise XOR + Insertion Encoder
# Author: Ray Doyle (@doylersec)
# Website: https://www.doyler.net

import array
from random import randint

def valid(byte):
    for c in badChars:
        if c == byte:
            return False
    return True

inserted = []
insertedEscaped = ""
encoded = ""
encoded2 = ""

badChars = [0x00]

#signature = randint(1, 255)
signature = 0x90

print "\nSignature byte: " + hex(signature)

shellcode = ("\xeb\x17\x31\xc0\xb0\x04\x31\xdb\xb3\x01\x59\x31\xd2\xb2\x0d\xcd\x80\x31\xc0\xb0\x01\x31\xdb\xcd\x80\xe8\xe4\xff\xff\xff\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x21\x0a")

for x in bytearray(shellcode):
    inserted.append(signature)
    inserted.append(x)

    insertedEscaped += '\\x%02x' % signature
    insertedEscaped += '\\x%02x' % x

print "\nInserted: \n" + insertedEscaped

print "\nLength: %d\n\n" % len(bytearray(shellcode))

print "------------------------------------------------------------------------------------------------------------------------"

insertedArray = array.array('B', inserted)

for x in xrange(0, len(insertedArray), 2):
    validKey = False

    while not validKey:
        key = randint(1, 255)
        #print "KEY: " + str(key)
    
        newByte1 = insertedArray[x] ^ key
        newByte2 = insertedArray[x + 1] ^ key

        if valid(newByte1) and valid(newByte2):
            validKey = True
            encoded += "\\x%02x" % newByte1
            encoded += "\\x%02x" % newByte2

            encoded2 += "0x%02x," % newByte1
            encoded2 += "0x%02x," % newByte2

encoded += "\\xaa" 
encoded2 += "0xaa"

print "\nXORed: \n" + encoded
print "\nASM ready: \n" + encoded2
print