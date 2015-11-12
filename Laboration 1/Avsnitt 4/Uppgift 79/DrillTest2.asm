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
	ORAA	#%00000011	; Ettställa stegpuls-biten (ge puls)
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
	LDAA	DrillControl
	ORAA	#%00000100	; Starta motorn
	STAA	DrillControl
	
	LDAA	DrillControl
	ORAA	#%00001100	; Sänk borr
	STAA	DrillControl
	
Borra_While:
	BRCLR	DrillStatus,#%00000100,Borra_While
	
	LDAA	DrillControl
	ANDA	#%11110111	; Höj borr
	STAA	DrillControl
	
	LDAA	DrillControl
	ANDA	#%11111011	; Stoppa motorn
	STAA	DrillControl
	
	RTS
; Slut Borra
	
; Subrutin GeLarm
GeLarm:
	RTS
; Slut GeLarm