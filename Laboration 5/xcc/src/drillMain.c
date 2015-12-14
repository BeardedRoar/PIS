#include "keyboardML15.h"
#include "drill.h"
#include "clock.h"

void main(void) {
   init_clock();
   while(1) {
      char pressedKey = get_key();
      switch (pressedKey) {
         case 0:
	    MotorStart();
	 case 1:
	    MotorStop();
      }
   }
}
