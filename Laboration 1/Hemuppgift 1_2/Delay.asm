; Delay.asm

	#define SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm
	ORG	$1000
	
;Delay_Start:
;	PSHA
Start:
	CLRA
Delay:
	LDX	#DelayConst
Next:
	LEAX	-1,X
	LDY	#DelayMultiplier
Next2:
	LEAY	-1,Y
	CPY	#0
	BNE	Next2
	CPX	#0
	BNE	Next
	COMA
	STAA	$400
	BRA	Delay
Delay_End:
;	PULA
	RTS
	