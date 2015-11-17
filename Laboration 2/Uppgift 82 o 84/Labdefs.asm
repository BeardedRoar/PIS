; Adress till omkopplare och display
DipSwitch	EQU	$600
HexDisplay	EQU	$700

; Adress till borrmaskinens styrregister
DrillControl	EQU	$400

; Adress till borrmaskinens statusregister
#ifdef SIMULATOR
DrillStatus	EQU	$401
#else
DrillStatus	EQU	$600
#endif

Inport	EQU	$600
Utport	EQU	$400