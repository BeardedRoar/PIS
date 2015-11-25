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

; Constants for delay with different setups
#ifdef SIMULATOR
#ifdef RUNFAST
DelayConst	EQU	$02 ;$02
DelayMultiplier	EQU	$80
#else
DelayConst	EQU	$01
DelayMultiplier	EQU	$1
#endif
#else
DelayConst	EQU	$01
DelayMultiplier	EQU	$100
#endif

Inport	EQU	$600
Utport	EQU	$400

; Adress till tangentbordet
Keyboard	EQU	$9C0

; ML19-definitioner
ML19_Stat	EQU	$0DC0
; Kvittera händelse 1
ML19_AckIrq_1	EQU	$0DC2
; Kvittera händelse 2
ML19_AckIrq_2	EQU	$0DC3