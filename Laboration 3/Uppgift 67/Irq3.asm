; Irq3.asm

Port1	EQU	$400
Port2	EQU	$401

	ORG	$1000
	
	USE	Labdefs.asm
	
Main:
	; Nollst�ll variabler
	CLR	Var1
	CLR	Var2
	; Initiera avbrottsvektor IRQ
	LDX	#IrqR
	STX	$3FF2
	; Nollst�ll I-bit (till�t avbrott)
	CLI
	
; I huvudprogrammet skrivs variablev�rdena till olika
; utportar. Endast Var1 �kas dock f�r varje varv i slingan.
Main_Loop:
	INC	Var1
	MOVB	Var1,Port1
	MOVB	Var2,Port2
	BRA	Main_Loop

; Avbrottsrutin
; �kar Var2 med 1 vid h�ndelse 1, nollst�ller Var2 vid h�ndelse 2
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