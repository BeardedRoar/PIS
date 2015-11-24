; Delay.asm
; Delays about 500 ms (simulator) or 250 ms (lab equipment).
;
; Usage:
;	JSR	Delay
	
Delay:
	PSHX
	PSHY
DoDelay:
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
Delay_End:
	PULY
	PULX
	RTS
	