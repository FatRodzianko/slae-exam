global _start

section .text
_start:
	jmp short get_address

;this will set up the egg to be hunted
egg:
	pop eax ; put a memory address in eax after doing the jmp-call-pop
	mov dword ebx, 0xdeadbeef ; this is the egg to search for

; this will sequentially go through each memory address that is stored in EAX, do a comparison to the egg stored in ebx, and if the comparison is true, jump to the address after the one in eax
egghunter:
	inc eax
	cmp dword [eax], ebx
	jne egghunter
	add eax,0x4
	jmp eax

; this is just for the jmp-call-pop to get a memory address in EAX as a starting point to start searching for the egg	
get_address:
	call egg	

