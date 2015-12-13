#include "ports.h"

void main(void) {
	char c;
	c = ML4IN;
	ML4OUT = c;
}
