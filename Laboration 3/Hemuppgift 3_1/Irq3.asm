; Irq3.asm
StackAddress0	EQU	$3100
StackAddress1	EQU	$3200
IrqVector	EQU	$3FF2
IrqFlipFlop	EQU	$0DC0

	#define	SIMULATOR
	#define	RUNFAST
	
	ORG	$1000
	
	USE	Labdefs.asm
	
Main:
	LDS	#StackAddress0		;Sätt startadress för process0's stack
	LDX	#IrqHandler		
	STX	IrqVector		;Ställ in avbrottsvektor

	CLR	IrqFlipFlop+2		;Hantera "gamla" avbrott
	CLR	IrqFlipFlop+3		

	CLR	ProcCounter
	CLI				;Sätt I-flaggan = 0
	
	USE	Drill.asm
	USE	Display_ML5.asm
	
; Avbrottsrutin
;Byter process
IrqHandler:
	
	LDD	ProcCounter
	ASLB
	PSHD
	PULY
	STS	SPTable,Y
	;Räkna ut var nuvarande process' stackpekaren ska sparas undan och spara den 

	LDD	ProcCounter
	INCB
	PSHX
	LDX	#2	; Antalet processer
	IDIV		; D/X (rest i D)
	PULX
	STD	ProcCounter
	;Inkrementera ProcCounter modulo antalet processer
	
	ASLB
	PSHD
	PULY
	LDS	SPTable,Y
	;Räkna ut var nästa process' stackpekare ska läsas från och läs in den

	CLR	IrqFlipFlop+2
	CLR	IrqFlipFlop+3	

	
	CLI
	RTI
	
; Data-Area
; SP-tabell
SPTable	FDB	StackAddress0,StackAddress1

; Stacks		
	ORG	StackAddress1
	FCB	$C0		;Initialt CC-värde (Obs att I=0)
	FCB	0		;Initialt B-värde
	FCB	0		;Initialt A-värde
	FDB	0		;Initalt X-värde
	FDB	0		;Initalt Y-värde		
	FDB	DISPLAY		;Initalt PC-värde	

	
; Variabler
ProcCounter	RMB	2