DisplayMode	EQU	$9C2
Display		EQU	$9C3

	ORG	$1000

	LDX	#Tabell
Start:
	JSR	DisplayML15
	BRA	Start

; Subroutine DisplayML15
DisplayML15:
	MOVB	#1,DisplayMode
	
	MOVB	#$D0,Display
	
	MOVB	#0,DisplayMode
	
	LDAA	#0
	
DisplayML15_While:
	CMPA	#6
	BEQ	DisplayML15_End
	
	MOVB	A,X,Display
	INCA
	BRA	DisplayML15_While
	
DisplayML15_End:
	LDAB	#0	; Temporarily
	STAB	Display
	STAB	Display
	RTS
; End of DisplayML15

; Constants
Tabell:	FCB	1,2,3,4,5,6