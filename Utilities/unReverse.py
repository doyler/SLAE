#!/usr/bin/python
import sys

input = """
	push 0x736c2f2f
	push 0x6e69622f
"""

input = input.splitlines()
input = filter(None, input)

instructions = []
decoded = ""

for i in input:
    instructions.append(i.replace('\t',''))

print '\nNumber of instructions: ' +str(len(instructions)) + '\n'

for inst in instructions[::-1]:
    print inst
    if inst.startswith("push 0x"):
        inst = inst.strip("push 0x")
    byteList = [inst[i:i+2] for i in range(0, len(inst), 2)]
    for item in byteList[::-1] :
        print item + ' : ' + str(item.decode('hex'))
        decoded += str(item.decode('hex'))

print '\nDecoded string: ' + decoded