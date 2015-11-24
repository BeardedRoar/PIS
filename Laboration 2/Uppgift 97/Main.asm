; Main.asm
; Operatörsstyrd borrautomat

; Definitioner
	#define	SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm
	
	ORG	$1000
	
Main:
	MOVB	#$00,DCShadow		; Passiva styrsignaler till borrens skuggvariabel
	MOVB	#$00,DrillControl	; Samt till borren

; Invänta vald operation
Main_Loop:
	JSR	GetKbdML15		; Tangentkod läggs i register B
	JSR	Command			; Den valda operationen utförs
	BRA	Main_Loop
	
; Subrutin Command
; Avgör vilken kommandosubrutin som ska köras och anropar denna.
;
; Anrop:
;	JSR	Command
;
; Indata: Kommandonummer (register B)
; Register: B, X ändras
; Anropar: SUB0, ..., SUB7

Command:
	CMPB	#7		; Giltigt värde?
	BHI	CommandExit
	
	LDX	#JUMPTAB	; Adress till pekartabellens start
	ASLB			; Offset är 2 bytes per tabell
	LDX	B,X		; Tabellens adress + kommandonumret = subrutinens adress
	
	JSR	,X		; Utför vald subrutin
; Avslut
CommandExit:
	RTS
	
; Pekartabell för subrutiner
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