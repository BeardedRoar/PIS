; Irq2.asm

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
; Ökar Var2 med 1
IrqR:
	INC	Var2
	CLR	ML19_AckIrq_1
	RTI
	
	
; Variabler
Var1	RMB	1
Var2	RMB	1