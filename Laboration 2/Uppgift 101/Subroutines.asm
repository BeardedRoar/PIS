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

; Subroutine MotorStart
; Strarts drillengine and then waits for 1 second for 
; the engine to reach full speed
MotorStart:
	PSHB
	
	LDAB	DCShadow
	CMPB	#4
	BEQ	MotorStart_End
	
	LDAB	#2
	JSR	Outone
	
	JSR	Delay_Start
	JSR	Delay_Start
	JSR	Delay_Start
	JSR	Delay_Start
	
MotorStart_End:
	PULB
	RTS
; End of MotorStart

; Subroutine MororStop
MotorStop:
	PSHB
	LDAB	#2
	JSR	Outzero
	PULB
	RTS
; End MotorStop

; Subroutine DrillDown
DrillDown:
	PSHB
	LDAB	#3
	JSR	Outone
	PULB
	RTS
; End DrillDOwn

; Subroutine DrillUp
DrillUp:
	PSHB
	LDAB	#3
	JSR	Outzero
	PULB
	
	JSR	Delay_Start
	
	RTS
; End DrillDOwn

; Subroutine Alarm
Alarm:
	PSHB
	PSHA
	CMPB	#0
	BEQ	Alarm_End
	PSHB
	PULA
	
Alarm_loop:
	LDAB	#4
	JSR	Outone
	JSR	Delay_Start
	JSR	Delay_Start
	LDAB	#4
	JSR	Outzero
	DECA
	BEQ	Alarm_End
	
	JSR 	Delay_Start
	JSR	Delay_Start
	BRA	Alarm_loop
	
Alarm_End:
	PULA	
	PULB
	RTS
; End Alarm

; Subroutine Step
Step:
	BRCLR	DrillStatus,#2,Step_Error
	
	PSHA
	LDAA	DCShadow
	ANDA	#%11111110	; Nollställa stegpuls-biten
	STAA	DCShadow
	STAA	DrillControl
	
	ORAA	#%00000010	; Ettställa vridningsriktningsbiten (vridningsriktioning moturs)
	STAA	DCShadow
	STAA	DrillControl
	
	ORAA	#%00000001	; Ettställa stegpuls-biten (ge puls)
	STAA	DCShadow
	STAA	DrillControl
	
	JSR	Delay_Start
	JSR	Delay_Start
	
	PULA
	LDAB	#1
	RTS
	
Step_Error:
	LDAB	#2
	JSR	Alarm
	
	CLRB
	RTS
; End Step

; Subroutine DrillDownTest
DrillDownTest:
	PSHA
	
	LDAA 	#20
	
DrillDownTest_Loop
	BRSET	DrillStatus,#4,DrillDownTest_Success
	JSR	Delay_Start
	DECA
	BNE	DrillDownTest_Loop
	
	LDAB	#2
	JSR	Alarm
	
	CLRB
	PULA
	RTS
	
DrillDownTest_Success:
	LDAB 	#2
	PULA
	RTS
	
; End DrillDownTest

; Subroutine DrillHole
DrillHole:
	JSR	DrillDown
	
	JSR	DrillDownTest
	
	JSR	DrillUp
	
	RTS
; End DrillHole

; Subroutine RefPos
RefPos:
	BRSET	DrillStatus,#1,RefPos_Success
	JSR	Step
	BNE	RefPos
	
	CLRB
	RTS
	
RefPos_Success:
	LDAB	#1
	RTS
	
; End RefPos

; Subroutine Nstep
Nstep:
	PSHA
	PSHB
	PULA
Nstep_Loop:
	CMPA	#0
	BEQ	Nstep_Success
	
	DECA
	
	JSR	Step
	BNE	Nstep_Loop
	
	PULA
	RTS
	
Nstep_Success:
	LDAB	#1
	PULA
	RTS
; End Nstep

; Subroutine DoAuto
DoAuto:
	PSHX
	LDX	#Pattern
	JSR	Auto
	PULX
	RTS
; End DoAuto

; Subroutine Auto
Auto:
	PSHB
	
	JSR	RefPos
	BEQ	Auto_Done
	
	JSR	MotorStart
	
Auto_DrillLoop:
	LDAB 	,X
	INX
	
	CMPB	#$FF
	BEQ	Auto_Done
	
	JSR	Nstep
	CMPB	#0
	BEQ	Auto_Done
	
	JSR	DrillHole
	CMPB	#0
	BNE	Auto_DrillLoop
	
Auto_Done:
	JSR	MotorStop
	PULB
	RTS

; End Auto
	
ZeroMaskTable:	FCB	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
OneMaskTable:	FCB	$01,$02,$04,$08,$10,$20,$40,$80
;DCShadow	RMB	1