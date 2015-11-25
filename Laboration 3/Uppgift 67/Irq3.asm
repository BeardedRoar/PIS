; Irq3.asm

Port1	EQU	$400
Port2	EQU	$401

	ORG	$1000
	
	USE	Labdefs.asm
	
Main:
	; Nollställ variabler
	CLR	Var1
	CLR	Var2
	; Initiera avbrottsvektor IRQ
	LDX	#IrqR
	STX	$3FF2
	; Nollställ I-bit (tillåt avbrott)
	CLI
	
; I huvudprogrammet skrivs variablevärdena till olika
; utportar. Endast Var1 ökas dock för varje varv i slingan.
Main_Loop:
	INC	Var1
	MOVB	Var1,Port1
	MOVB	Var2,Port2
	BRA	Main_Loop

; Avbrottsrutin
; Ökar Var2 med 1 vid händelse 1, nollställer Var2 vid händelse 2
IrqR:
	PSHA
	LDAA	ML19_Stat
	CMPA	#$81
	BEQ	IrqR_Event1
	CMPA	#$82
	BEQ	IrqR_Event2
	
	BRA	IrqR_End		; If none of these, end
IrqR_Event1:
	INC	Var2
	CLR	ML19_AckIrq_1
	BRA	IrqR_End
IrqR_Event2:
	CLR	Var2
	CLR	ML19_AckIrq_2
IrqR_End:
	PULA
	RTI
	
	
; Variabler
Var1	RMB	1
Var2	RMB	1