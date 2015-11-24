	ORG	$1000
	#define	SIMULATOR
;	#define	RUNFAST
	USE 	Labdefs.asm
	
Main:
	MOVB	#$00,DCShadow		; Passiva styrsignaler till borrens skuggvariabel
	MOVB	#$00,DrillControl	; Samt till borren	
Main_Loop:
	JSR	GetKbdML15
	
; Tangent nu i B

	JSR	Command
	BRA	Main_Loop
; End Main	

Command:
	CMPB	#$07
	BHI	Command_Exit
	
	LDX	#JUMPTAB
	
	ASLB
	LDX	B,X
	JSR	,X
	
Command_Exit:
	RTS
	
; Constants for Command

JUMPTAB	FDB	MotorStart,MotorStop,DrillDown,DrillUp,Step,DrillHole,RefPos,DoAuto

; End Command
SUB6:
	MOVB	#6,HexDisplay
	RTS
SUB7:
	MOVB	#7,HexDisplay
	RTS

	
	USE	Delay.asm
	USE	KeyboardML15.asm
	USE	Subroutines.asm
	
DCShadow	RMB	1	; DrillControl shadow variable
Pattern:	FCB	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,$FF