from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE
import sys
import argparse
from Crypto.Cipher import AES

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--shellcode", help="Please provide the shellcode in the format \\xAA\\xAA", type=str, required=True)
parser.add_argument("-k", "--key", help="Please provide the encryption key", type=str, required=True)
args = parser.parse_args()

# shellcode needs 16 garbage chars to begining with
shellcode = "sixteen chars123"

shellcode += args.shellcode.replace('\\x', '').decode('hex')
print "This is your shellcode"
print shellcode[16:]
formatted_shell = ""
for x in bytearray(shellcode[16:]):
	formatted_shell += "\\x"
	formatted_shell += "%02x" % x
print formatted_shell

key = args.key

if len(key) != 16:
	print "The key must be 16 characters long"
	sys.exit()

#encryption
encryption_suite = AES.new(key, AES.MODE_CFB, key)
encrypted = encryption_suite.encrypt(shellcode)
print "This is the encrypted shellcode"
print encrypted[15:]

encrypted_shellcode = ""
for x in bytearray(encrypted[16:]):
	encrypted_shellcode += "\\x"
	encrypted_shellcode += "%02x" % x
	
print encrypted.encode('hex')[16:]
print encrypted_shellcode

#decryption
decrypted = encryption_suite.decrypt(shellcode)
print "This is the decrypted shellcode"
print decrypted[16:]
print decrypted.encode('hex')[16:]

decrypted_shellcode = ""
for x in bytearray(decrypted[16:]):
	decrypted_shellcode += "\\x"
	decrypted_shellcode += "%02x" % x
print decrypted_shellcode

"""
#Execute the shellcode
libc = CDLL('libc.so.6')
sc = c_char_p(shellcode)
size = len(shellcode)
addr = c_void_p(libc.valloc(size))
memmove(addr, sc, size)
libc.mprotect(addr, size, 0x7)
run = cast(addr, CFUNCTYPE(c_void_p))
run()
"""
