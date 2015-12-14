#include "clock.h"
#include "displayML15.h"

void main(void) {
   int i = 0;
   init_clock();
   while(1) {
      if (i == 100) {
	display_dec((unsigned int)get_time());
	i = 0;
      }
      i++;
   }
}
