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

#ifdef SIMULATOR
#ifdef RUNFAST
DelayConst	EQU	$02
DelayMultiplier	EQU	$80
#else
DelayConst	EQU	$01
DelayMultiplier	EQU	$1
#endif
#else
DelayConst	EQU	$01
DelayMultiplier	EQU	$100
#endif