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

	; Next will need to bind an address/port to the socket
	; the file descriptor created by the socket will be stored in EAX
	xor ebx,ebx ; 0 out ebx
	
	; pushing the the value for sockaddr. First push the address which is 0x0, or all interfaces. Then push the port number
	; which is 8080 in decimal or 1f90 in hex. Then set the type/domain/whatever to 0x2 or AF_INET/IPv4
	push ebx ; null terminator
	push word 0x901f ; port number. 8080 in hex is 1f90. 0x901f is 8080 in reverse order
	push ebx
	push 0x2 ; push 0x2 to use AF_INET/IPv4

	mov ecx, esp ; put stack pointer address in ECX. This is a pointer to the parameters defined above for the sockaddr

	; now set up the stack to contain the parameters for the bin. This is the socket file descriptor, the pointer to the values for
	; sockadd, and the length of the address
	push 0x10 ; size of the server address or 16 in decimal
	push ecx ; pointer to the values for sockaddr
	push eax ; eax contains the FD of the socket from the last syscall
	mov ecx, esp ; after above is done, set ECX to the stack pointer address so it can all be passed to sys_socketcall

	; make the syscall for the bind
	mov bl, 0x2 ; moving 0x2 into EBX so that the bind call from sys_socketcall will be used
	mov al, 0x66
	int 0x80


	; setup the "listen" sys_socketcall
	
	
