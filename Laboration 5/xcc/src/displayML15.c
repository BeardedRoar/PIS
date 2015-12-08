#include "displayML15.h"
#include "ports.h"
#include "macros.h"

/* Takes a char array of size 6 and prints it to the display */
void display_digits(unsigned char* digits) {
   int i;
   
   set(ML3MODE, 1);	//Sets the display to control mode
   ML3DISPLAY = 0xD0;
   
   set(ML3MODE, 0);	//Sets the display to data mode
   
   for(i = 0; i < 6; i++) {
      ML3DISPLAY = *(digits+i);
   }
   
   ML3DISPLAY = 0;
   ML3DISPLAY = 0;
}

void display_dec(unsigned int number) {
   unsigned char* digits;
   int i = 0;
   
   for(i = 0; i < 6; i++) {
      *(digits+i) = (number % 10^(i+1)) / 10^i;
   }
   
   display_digits(digits);
}
