; Main.asm
; Operat�rsstyrd borrautomat

; Definitioner	
	ORG	$1000
	
	#define	SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm
	
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
	FDB	RefPos,DoAuto
; Slut Command
	
; USE
	USE	ML15drvr.asm
	USE	Delay.asm
	USE	Subroutines.asm
	
; Globala variabler
DCShadow	RMB	1
Pattern		FCB	0,1,1,1,1,1,1,1,2,1,5,2,2,2,2,4,4,3,8,2,$FF