#include "clock.h"
#include "ports.h"
#include "macros.h"

//Shadow variable for the clock
port8 clockshadow;

char *crgflg = 0x0037;
char *crgint = 0x0038;
char *rtictl = 0x003B;

#define CRGINT ((char *)0x38)

//Clock constant
#ifdef SIMULATOR
#define CLOCKCONSTANT 0x10
#else
#define CLOCKCONSTANT 0x49
#endif

volatile time_type count;

extern void clocktrap(void);
extern void cleari(void);

void init_clock(void) {
   //CRGptr ptr = 0x0034;
   
   //Reset the clock
   count = 0;
   CLOCKVECTOR = clocktrap;
   clockshadow = 0;
   //Initialize the CRG circuit to generate a interruption every 10 ms.   
   set(*crgint, 0x80);
   set(*rtictl, CLOCKCONSTANT);
   set(*crgflg, 0x80);
   cleari();
}

void clock_inter(void) {
   //Tickar up klockan
   count++;
   //clear crgflg rtif
   set(*crgflg, 0x80);
 //  cleari();
}

time_type get_time(void) {
   //Returns the approximate amount of ms that has passed since the clock was initialized.
   return 10 * count;
}

void hold(time_type time) {
   time_type start = get_time();
   while(time) {
      if (time <= (start - get_time())) { //If the time (or more time) has passed, end.
         time = 0;
      }
   }
}
