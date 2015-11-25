; Irq1.asm

Port1	EQU	$400
Port2	EQU	$401

	ORG	$1000
	
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
; �kar Var2 med 1
IrqR:
	INC	Var2
	RTI
	
	
; Variabler
Var1	RMB	1
Var2	RMB	1