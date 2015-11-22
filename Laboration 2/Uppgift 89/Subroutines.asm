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

; Subroutine MotorStart
; Starts the drill engine and then waits for 1 second so
; that the drill gets the correct speed.
;
; Usage:
;	JSR	MotorStart
;
; Calls: Outone, Delay

MotorStart:
	PSHA
	PSHB
	
	LDAA	DCShadow
	ANDA	#%00000100	; Loads DCShadow and checks if the engine bit is 1 (on).
	BNE	MotorStart_End	; If engine is on, do nothing more.

	LDAB	#2
	JSR	Outone		; Sets engine bit to 1 (turns on the engine).
	
	JSR	Delay		; Run Delay twice to delay 1 sec.
	JSR	Delay
MotorStart_End:
	PULB
	PULA
	RTS
; End of MotorStart
	
ZeroMaskTable:	FCB	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
OneMaskTable:	FCB	$01,$02,$04,$08,$10,$20,$40,$80
;DCShadow	RMB	1