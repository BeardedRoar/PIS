#include "keyboardML15.h"
#include "ports.h"

unsigned char get_key(void) {
   unsigned char input;
   
   while(ML15IN & 0x80) {
      //Wait for input
   }
   
   input = ML15IN;
   
   while(!(ML15IN & 0x80)) {
      //Wait for release of button
   }
   
   return input;
}
