	USE	Labdefs.asm
	ORG	$1000
	
Start:
	LDAA	#0	; Reset
	STAA	DrillControl
	
	JSR	TillRefPos
	JSR	Borra
	JSR	Vrid1steg
	JSR	Borra
	JSR	Vrid1steg
	JSR	Borra
	JSR	Vrid1steg
	JSR	Vrid1steg
	JSR	Vrid1steg
	JSR	Borra
	JSR	GeLarm
Stopp:
	BRA	Stopp
	
Vrid1steg:
	LDAA	DrillControl
	ANDA	#%11111110	; Nollst�lla stegpuls-biten
	STAA	DrillControl
	
	LDAA	DrillControl
	ORAA	#%00000010	; Ettst�lla vridningsriktningsbiten (vridningsriktioning moturs)
	STAA	DrillControl
	
	LDAA	DrillControl
	ORAA	#%00000001	; Ettst�000000000000+0++lla stegpuls-biten (ge puls)
	STAA	DrillControl
	
	LDAA	DrillControl
	ANDA	#%11111110	; Nollst�lla stegpuls-biten
	STAA	DrillControl
	
	RTS
TillRefPos:
	RTS
Borra:
	RTS
GeLarm:
	RTS
	