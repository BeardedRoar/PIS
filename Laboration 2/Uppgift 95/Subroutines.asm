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
	
	JSR	Delay		; Run Delay four times to delay 1 sec.
	JSR	Delay
	JSR	Delay
	JSR	Delay
MotorStart_End:
	PULB
	PULA
	RTS
; End of MotorStart

; Subroutine MotorStop
; Stops the drill engine.
;
; Usage:
;	JSR	MotorStop
;
; Calls: Outzero

MotorStop:
	PSHB
	
	LDAB	#2
	JSR	Outzero		; Sets engine bit to 0 (turns off the engine).

	PULB
	RTS
; End of MotorStop

; Subroutine DrillDown
; Lowers the drill.
;
; Usage:
; 	JSR	DrillDown
; Calls: Outone

DrillDown:
	PSHB
	
	LDAB	#3
	JSR	Outone		; Sets up/down bit to 1 (lower drill).
	
	PULB
	RTS
; End of DrillDown

; Subroutine DrillUp
; Pulls up the drill.
;
; Usage:
; 	JSR	DrillUp
; Calls: Delay, Outzero

DrillUp:
	PSHB
	
	LDAB	#3
	JSR	Outzero		; Sets up/down bit to 0 (raise drill).
	
	JSR	Delay
	
	PULB
	RTS
; End of DrillUp

; Subroutine Alarm
; Gives N alarm signals of the length 1 s, with a pause of 0,5 s between each signal.
;
; Usage:
;	LDAB	#N
;	JSR	Alarm
; Input: Number of signals, N, in register B
; Calls: Delay, Outzero, Outone
Alarm:
	CMPB	#0
	BEQ	Alarm_End	; If 0 signals, end the subroutine
	
	PSHA			; Save value from register A on the stack
	
	PSHB			; Save value from register B (N) to the stack
	PULA			; Put pushed value (N) from register B in register A
	
	PSHB			; Save value from register B (N) to the stack
				; (again, after pulling to A)
	
	LDAB	#4		; Load alarm bit number to register B (b4)
Alarm_Loop:
	JSR	Outone		; Set alarm bit to 1 (turn on alarm)
	
	JSR	Delay
	JSR	Delay
	JSR	Delay
	JSR	Delay		; Delay for 1 sec
	
	JSR	Outzero		; Set alarm bit to 0 (turn off alarm)
	DECA			; Decrease N (stored in register A)
	
	BEQ	Alarm_End	; If N (register A) is 0, end the subroutine
	
	JSR	Delay
	JSR	Delay		; Delay for 0,5 s
	BRA	Alarm_Loop	; Else, sound alarm again
Alarm_End:
	PULB
	PULA
	RTS
; End of Alarm

; Subroutine Step
; Turns the workpiece one step clockwise, if the drill is in
; the up position when the subroutine is called. If the drill is in the
; down position the workpiece is not turned and two alarm signals are sent.
;
; Usage:
;	JSR	Step
; Output: Value 1 in register B if the workpiece has been turned, value 0 else.
; Calls: Alarm, Delay, Outzero, Outone

Step:
	BRCLR	DrillStatus,#2,Step_Alarm
	PSHB
	
	LDAB	#0
	JSR	Outzero		; Set workpiece turning bit to 0
	
	LDAB	#1
	JSR	Outone		; Set clockwise turning
	
	LDAB	#0
	JSR	Outone		; Turn workpiece
	
	JSR	Delay
	JSR	Delay		; Delay 0,5 s
	
	BRA	Step_End
Step_Alarm:
	LDAB	#2
	JSR	Alarm
Step_End:
	PULB
	RTS
; End of Step
	
ZeroMaskTable:	FCB	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
OneMaskTable:	FCB	$01,$02,$04,$08,$10,$20,$40,$80