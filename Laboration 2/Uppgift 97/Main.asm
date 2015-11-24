; Main.asm
; Operat�rsstyrd borrautomat

; Definitioner
	#define	SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm
	
	ORG	$1000
	
Main:
	MOVB	#$00,DCShadow		; Passiva styrsignaler till borrens skuggvariabel
	MOVB	#$00,DrillControl	; Samt till borren

; Inv�nta vald operation
Main_Loop:
	JSR	GetKbdML15		; Tangentkod l�ggs i register B
	JSR	Command			; Den valda operationen utf�rs
	BRA	Main_Loop
	
; Subrutin Command
; Avg�r vilken kommandosubrutin som ska k�ras och anropar denna.
;
; Anrop:
;	JSR	Command
;
; Indata: Kommandonummer (register B)
; Register: B, X �ndras
; Anropar: SUB0, ..., SUB7

Command:
	CMPB	#7		; Giltigt v�rde?
	BHI	CommandExit
	
	LDX	#JUMPTAB	; Adress till pekartabellens start
	ASLB			; Offset �r 2 bytes per tabell
	LDX	B,X		; Tabellens adress + kommandonumret = subrutinens adress
	
	JSR	,X		; Utf�r vald subrutin
; Avslut
CommandExit:
	RTS
	
; Pekartabell f�r subrutiner
JUMPTAB FDB	MotorStart,MotorStop
	FDB	DrillDown,DrillUp
	FDB	Step,DrillHole
	FDB	SUB6,SUB7
	
; Subrutiner till Command
SUB5:
	MOVB	#5,Utport
	RTS
SUB6:
	MOVB	#6,Utport
	RTS
SUB7:
	MOVB	#7,Utport
	RTS
; Slut subrutiner till Command
; Slut Command
	
; USE
	USE	ML15drvr.asm
	USE	Delay.asm
	USE	Subroutines.asm
	
; Globala variabler
DCShadow	RMB	1