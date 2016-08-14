#include <stdlib.h>
#include <stdio.h>
int mystery(int x)	
{
	int a = 2;
	a= a << (x-1);
	a = a-1;
	return a;

}






int main() {
	int x;
	x = mystery(32);
	printf("num is %d\n", x);
	return 0;

}
