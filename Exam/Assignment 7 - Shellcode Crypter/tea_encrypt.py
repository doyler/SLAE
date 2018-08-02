#!/usr/bin/python

# SLAE Exam Assignment #7: Custom Shellcode Crypter (Linux/x86) - Tiny Encryption Algorithm Encrypter
# Author: Ray Doyle (@doylersec)
# Website: https://www.doyler.net
# Algorithm: https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm

import struct
import numpy as np
import warnings

# https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm
def encrypt(data, key):
    delta = int("0x9e3779b9", 0)
    sum = np.int32(0)

    y = np.uint32(struct.unpack("I", data[0:4])[0])
    z = np.uint32(struct.unpack("I", data[4:8])[0])

    #print "Y: " + str(y)
    #print "Z: " + str(z)

    k0 = struct.unpack("I", key[0:4])[0]
    k1 = struct.unpack("I", key[4:8])[0]
    k2 = struct.unpack("I", key[8:12])[0]
    k3 = struct.unpack("I", key[12:16])[0]

    for n in range(0, 32):
        sum += delta
        sum = np.int32(sum)

        #print "SUM #" + str(n) + ": " + str(sum)

        q = ((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1)

        r = ((z << 4) + k0)
        s = z + sum
        t = ((z >> 5) + k1)

        #print "First sum: " + '0x{:08x}'.format(r % 4294967295)
        #print "Second sum: " + '0x{:08x}'.format(s % 4294967295)
        #print "XOR: " + '0x{:08x}'.format((r ^ s) % 4294967295)
        #print "Second shift: " + '0x{:08x}'.format((z >> 5) % 4294967295)
        #print "Key1: " + '0x{:08x}'.format((k1) % 4294967295)
        #print "Third sum: " + '0x{:08x}'.format((t) % 4294967295)
        #print "Final XOR: " + '0x{:08x}'.format((r ^ s ^ t) % 4294967295)

        y += np.uint32(((z << 4) + k0) ^ (z + sum) ^ ((z >> 5) + k1))
        z += np.uint32(((y << 4) + k2) ^ (y + sum) ^ ((y >> 5) + k3))

    #print "FINAL SUM: " + '0x{:08x}'.format(sum % 4294967295)

    #print '0x{:08x}'.format(y % 4294967295)
    #print '0x{:08x}'.format(z % 4294967295)

    #print k0
    #print k1
    #print k2
    #print k3

    return (y, z)

def main():
    # Execve-stack
    # https://www.doyler.net/security-not-included/execve-shellcode-generator
    shellcode = "\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"
    # Randomly generated key
    key = "WQVh8{7C?gE_B<d$"
    crypted = []
    output = ''

    # Ignore all warnings
    # This is for the overflow occasionally caused by the unsigned integer addition
    warnings.filterwarnings("ignore")

    # Pad the shellcode length to be divisible by 8, mades encrypting/decrypting easier
    while not (len(shellcode) % 8 == 0):
        shellcode += "\x90"

    # Encrypt each word pair in the shellcode
    for x in range(0, len(shellcode) / 8):
        y, z = encrypt(shellcode[8*x:8*(x+1)], key)
        crypted.append(y)
        crypted.append(z)
    
    # Combine the shellcode into a printable string
    for word in crypted:
        output += ''.join(map(lambda c:'\\x%02x'%c, map(ord, struct.pack('L', word))))

    print "\nEncrypted Shellcode"
    print "Length: " + str(len(shellcode)) + " bytes"
    print "--------------------------------"
    print output
    print ""
    print "\nASM ready: \n" + output.replace('\\', ', 0')[2:]
    print

if __name__ == '__main__':
    main()