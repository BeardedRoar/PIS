;	USE	Labdefs.asm
;	ORG	$1000
;
;Start:
;	LDAB	#$00
;	STAB	DCShadow
;	
;Loop:
;	LDAB	Inport
;	JSR	Outone
;	LDAA	DCShadow
;	STAA	Utport
;	JMP	Start
	

; Subroutine Outzero
; Reads the DrillControl shadow variable DCShadow and zeroes a specified bit.
; The new value is then written to DCShadow and DrillControl.
;
; The bit that is to be zeroed is given by register B (bit 0-7).
; Usage:
;	LDAB	#bitnumber
;	JSR	Outzero

Outzero:	
	CMPB	#7
	BHI	Outzero_End	; Branch if higher (unsigned): C + Z = 0

	PSHX	
	PSHB
	
	LDX	#ZeroMaskTable	; Loads the adress for the first mask table entry
	LDAB	B,X		; Loading the mask from the table with adress X+B
	
	ANDB	DCShadow	; Masking mask in B and DCShadow (zeroing chosen bit)
	STAB	DCShadow	; Storing new DrillCOntrol value in shadow variable and original
	STAB	DrillControl
	
	PULB
	PULX
Outzero_End:
	RTS
; End of Outzero

; Subroutine Outone
; Reads the DrillControl shadow variable DCShadow and sets a specified bit to 1.
; The new value is then written to DCShadow and DrillControl.
;
; The bit that is to be set to 1 is given by register B (bit 0-7).
; Usage:
;	LDAB	#bitnumber
;	JSR	Outone

Outone:	
	CMPB	#7
	BHI	Outone_End	; Branch if higher (unsigned): C + Z = 0

	PSHX	
	PSHB
	
	LDX	#OneMaskTable	; Loads the adress for the first mask table entry
	LDAB	B,X		; Loading the mask from the table with adress X+B
	
	ORAB	DCShadow	; Masking mask in B and DCShadow (zeroing chosen bit)
	STAB	DCShadow	; Storing new DrillCOntrol value in shadow variable and original
	STAB	DrillControl
	
	PULB
	PULX
Outone_End:
	RTS
; End of Outone
	
ZeroMaskTable:	FCB	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
OneMaskTable:	FCB	$01,$02,$04,$08,$10,$20,$40,$80
;DCShadow	RMB	1