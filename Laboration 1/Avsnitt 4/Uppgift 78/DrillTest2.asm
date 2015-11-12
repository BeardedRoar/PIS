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
	
; Subrutin Vrid1steg	
Vrid1steg:
	LDAA	DrillControl
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DrillControl
	
	LDAA	DrillControl
	ORAA	#%00000010	; Ettställa vridningsriktningsbiten (vridningsriktioning moturs)
	STAA	DrillControl
	
	LDAA	DrillControl
	ORAA	#%00000001	; Ettställa stegpuls-biten (ge puls)
	STAA	DrillControl
	
	LDAA	DrillControl
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DrillControl
	
	RTS
; Slut Vrid1steg
	
; Subrutin TillRefPos	
TillRefPos:
	BRSET	DrillStatus,#%00000001,TillRefPos_End
	JSR	Vrid1steg
	BRA	TillRefPos
TillRefPos_End:
	RTS
; Slut TillRefPos

; Subrutin Borra
Borra:
	RTS
; Slut
	
; Subrutin GeLarm
GeLarm:
	RTS
	