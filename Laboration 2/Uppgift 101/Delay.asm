; Delay.asm

;	#define SIMULATOR
;	#define	RUNFAST
	USE	Labdefs.asm
	
Delay_Start:
	PSHX
	PSHY
	PSHA
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
Delay_End:
	PULA
	PULY
	PULX
	RTS
	