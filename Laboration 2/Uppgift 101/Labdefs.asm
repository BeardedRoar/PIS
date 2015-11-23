; Adress till omkopplare och display
DipSwitch	EQU	$600
HexDisplay	EQU	$700
Keyboard	EQU	$9C0

; Adress till borrmaskinens styrregister
DrillControl	EQU	$400

; Adress till borrmaskinens statusregister
#ifdef SIMULATOR
DrillStatus	EQU	$401
#else
DrillStatus	EQU	$600
#endif

#ifdef	RUNFAST
DelayConst		EQU	$18
DelayMultiplier		EQU	$20
#else
DelayConst		EQU	1
DelayMultiplier		EQU	1
#endif

Inport	EQU	$600
Utport	EQU	$400