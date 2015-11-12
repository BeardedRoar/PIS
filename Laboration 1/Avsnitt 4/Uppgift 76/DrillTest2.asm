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
	RTS
TillRefPos:
	RTS
Borra:
	RTS
GeLarm:
	RTS