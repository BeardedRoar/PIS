#include "displayML15.h"
#include "ports.h"
#include "macros.h"
#include <math.h>

/* Takes a char array of size 6 and prints it to the display */
void display_digits(unsigned char* digits) {
   int i;
   
   set(ML3MODE, 1);	//Sets the display to control mode
   ML3DISPLAY = 0xD0;
   
   clear(ML3MODE, 1);	//Sets the display to data mode
   
   for(i = 0; i < 6; i++) {
      ML3DISPLAY = digits[i];
   }
   
   ML3DISPLAY = 0;
   ML3DISPLAY = 0;
}

void display_dec(unsigned int number) {
   unsigned char digits[6];
   int i = 0;
   
   for(i = 0; i < 6; i++) {
      digits[5-i] = number % 10; //Filling from the end
      number /= 10;
   }
   
   display_digits(digits);
}
