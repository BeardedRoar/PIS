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
   
}

void DrillUp(void);
int Nstep(int);
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

void Alarm(int);

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
