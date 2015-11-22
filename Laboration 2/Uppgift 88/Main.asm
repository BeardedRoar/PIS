; Main.asm
; Operatörsstyrd borrautomat

; Definitioner
	USE	Labdefs.asm
	
	ORG	$1000
	
Main:
;	---	Initiera borrmaskin

; Invänta vald operation
Main_Loop:
	JSR	GetKbdML15
;*Tangentkod nu i register B...
;*Utför vald operation
	JSR	Command
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
JUMPTAB FDB	SUB0,SUB1,SUB2,SUB3
	FDB	SUB4,SUB5,SUB6,SUB7
	
; Subrutiner till Command
SUB0:
	MOVB	#0,Utport
	RTS
SUB1:
	MOVB	#1,Utport
	RTS
SUB2:
	MOVB	#2,Utport
	RTS
SUB3:
	MOVB	#3,Utport
	RTS
SUB4:
	MOVB	#4,Utport
	RTS
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
	;---
	
; Globala variabler
DCShadow	RMB	1