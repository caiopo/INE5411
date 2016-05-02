#include <stdio.h>

int fib(int a, int b, int n) {
	if (n == 0)
		return b;
	else
		return fib(a+b, a, n-1);
}

int main() {
	printf("%d", fib(1, 1, 10));
}