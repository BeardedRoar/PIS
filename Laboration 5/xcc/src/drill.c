#include "drill.h"
#include "ports.h"
#include "clock.h"

char DCShadow = 0;

/* Reads the DrillControl shadow variable DCShadow and zeroes a specified bit.
The new value is then written to DCShadow and DrillControl. */
void Outzero(int bit) {
   if (bit <= 7) {
      char mask = 1;
      mask = mask << bit;
      
      DCShadow &= ~mask;
      DrillControl = DCShadow;
   }
}

/* Reads the DrillControl shadow variable DCShadow and sets a specified bit to 1.
The new value is then written to DCShadow and DrillControl. */
void Outone(int bit) {
   if (bit <= 7) {
      char mask = 1;
      mask = mask << bit;
      
      DCShadow |= mask;
      DrillControl = DCShadow;
   }
}

/* Turns the workpiece one step clockwise, if the drill is in
 the up position when the subroutine is called. If the drill is in the
 down position the workpiece is not turned and two alarm signals are sent. */
int Step(void) {
   if (!(DrillStatus & 8)) {
      Alarm(2);		//Give 2 alarm signals
      return 0;
   } else {
      Outzero(0);	//Turn off possible workspace turning bit
      Outone(1); 	//Enable clockwise turning
      Outone(0);	//Turn workpiece
      
      hold((time_type)500);	//Wait for 0,5 s (500 ms)
      
      return 1;
   }
}

/* Starts the drill engine and then waits for 1 second so that the drill
 gets the correct speed. */
void MotorStart(void) {
   Outone(2);
   hold((time_type)1000);
}

/* Stops the drill engine. */
void MotorStop(void) {
   Outzero(2);
}

/* Lowers the drill. */
void DrillDown(void) {
   Outone(3);
}

/* Pulls up the drill. */
void DrillUp(void) {
   Outzero(3);
   hold((time_type)1000);
}

/* Rotates the workpiece n steps clockwise */
int Nstep(int steps) {
   int i = 0;
   
   for(i = 0; i < steps; i++) {
      if (!Step()) {
         return 0;	//Alarm has sounded, someting went wrong.
      }
   }
   return 1;
}

int DrillDownTest(void){
	int i;
	for (i = 0; i < 20; i++){
		if ((DrillStatus) & 4){
			return 1;
		}
		hold((time_type)250);
	}
	Alarm(2);
	return 0;
}

/* Gives N alarm signals of the length 1 s, with a pause of 0,5 s between each signal. */
void Alarm(int n) {
   int i = 0;
   for(i = 0; i < n; i++) {
      if (!i) {
         hold((time_type)500);	//Wait for last alarm to finish
      }
      Outone(4);		//Turn on alarm
      hold((time_type)1000);	//Delay for 1 s (1000 ms)
      Outzero(4);		//Turn off alarm
   }
}

int DrillHole(void){
	unsigned int success;
	DrillDown();
	success = DrillDownTest();
	DrillUp();
	return success;
}

int RefPos(void){
	while((DrillStatus) & 1){
		if (!Step()){
			return 0;
		}
	}
	return 1;
}

void DoAuto(void);
