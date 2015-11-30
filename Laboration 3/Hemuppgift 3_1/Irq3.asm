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
	LDS	#StackAddress0		;S�tt startadress f�r process0's stack
	LDX	#IrqHandler		
	STX	IrqVector		;St�ll in avbrottsvektor

	CLR	IrqFlipFlop+2		;Hantera "gamla" avbrott
	CLR	IrqFlipFlop+3		

	CLR	ProcCounter
	CLI				;S�tt I-flaggan = 0
	
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
	;R�kna ut var nuvarande process' stackpekaren ska sparas undan och spara den 

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
	;R�kna ut var n�sta process' stackpekare ska l�sas fr�n och l�s in den

	CLR	IrqFlipFlop+2
	CLR	IrqFlipFlop+3	

	
	CLI
	RTI
	
; Data-Area
; SP-tabell
SPTable	FDB	StackAddress0,StackAddress1

; Stacks		
	ORG	StackAddress1
	FCB	$C0		;Initialt CC-v�rde (Obs att I=0)
	FCB	0		;Initialt B-v�rde
	FCB	0		;Initialt A-v�rde
	FDB	0		;Initalt X-v�rde
	FDB	0		;Initalt Y-v�rde		
	FDB	DISPLAY		;Initalt PC-v�rde	

	
; Variabler
ProcCounter	RMB	2