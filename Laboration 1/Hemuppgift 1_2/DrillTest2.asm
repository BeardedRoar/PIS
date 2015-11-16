	#define	SIMULATOR
;	#define RUNFAST
	USE	Labdefs.asm
	ORG	$1000
	
Start:
	CLRA
	STAA	DCShadow
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
	
	LDAA	DCShadow
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DCShadow
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
	LDAA	DCShadow
	ORAA	#%00000100	; Starta motorn
	STAA	DCShadow
	STAA	DrillControl
	
	LDAA	DCShadow
	ORAA	#%00001000	; Sänk borr
	STAA	DCShadow
	STAA	DrillControl
	
Borra_While:
	BRCLR	DrillStatus,#%00000100,Borra_While
	
	LDAA	DCShadow
	ANDA	#%11110111	; Höj borr
	STAA	DCShadow
	STAA	DrillControl
	
	LDAA	DCShadow
	ANDA	#%11111011	; Stoppa motorn
	STAA	DCShadow
	STAA	DrillControl
	
	RTS
; Slut Borra
	
; Subrutin GeLarm
GeLarm:
	LDAA	DCShadow
	ORAA	#%00010000	; Sätt på larm
	STAA	DCShadow
	STAA	DrillControl
	RTS
; Slut GeLarm

DCShadow	RMB	1