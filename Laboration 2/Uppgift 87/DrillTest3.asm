; DrillTest3.asm

	#define	SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm	
	ORG	$1000
	
Start:
	JSR	Vrid1steg
	BRA	Start
	
; Subrutin Vrid1steg
Vrid1steg:
	LDAA	DCShadow
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DCShadow
	STAA	DrillControl
	
	LDAA	DCShadow
	ORAA	#%00000010	; Ettställa vridningsriktningsbiten (vridningsriktioning moturs)
	STAA	DCShadow
	STAA	DrillControl
	
	LDAA	DCShadow
	ORAA	#%00000001	; Ettställa stegpuls-biten (ge puls)
	STAA	DCShadow
	STAA	DrillControl
	
	JSR	Delay
	
	LDAA	DCShadow
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DCShadow
	STAA	DrillControl
	
	RTS
; Slut Vrid1steg

DCShadow	RMB	1
	USE	Delay.asm