; Operatörsstyrd borrautomat

; Definitioner	
	ORG	$1000
	
	#define	SIMULATOR
	#define	RUNFAST
	USE	Labdefs.asm
	
Error_Code	EQU	$FF
	
Main:
	MOVB	#$00,DCShadow		; Passiva styrsignaler till borrens skuggvariabel
	MOVB	#$00,DrillControl	; Samt till borren

; Invänta vald operation
Main_Loop:
	JSR	GetKbdML15		; Tangentkod läggs i register B
	JSR	Command			; Den valda operationen utförs
	BRA	Main_Loop
	
; Subrutin Command
; Avgör vilken kommandosubrutin som ska köras och anropar denna.
;
; Anrop:
;	JSR	Command
;
; Indata: Kommandonummer (register B)
; Register: B, X ändras
; Anropar: SUB0, ..., SUB7

Command:
	CMPB	#7		; Giltigt värde?
	BHI	CommandExit
	
	LDX	#JUMPTAB	; Adress till pekartabellens start
	ASLB			; Offset är 2 bytes per tabell
	LDX	B,X		; Tabellens adress + kommandonumret = subrutinens adress
	
	JSR	,X		; Utför vald subrutin
; Avslut
CommandExit:
	RTS
; End Command
	
; Subroutine CheckKdbML15
CheckKbdML15:
	LDAB	Keyboard
	BITB	#%10000000	; Z=1 if 8th bit is 0
	BNE	CheckKbdML15_NoPress
	
CheckKbdML15_Press:
	PSHB
CheckKbdML15_Press_WhilePress:
	LDAB	Keyboard
	BITB	#%10000000
	BEQ	CheckKbdML15_Press_WhilePress
	PULB
	BRA	CheckKbdML15_End	; Extra branch to keep return last in subroutine
	
CheckKbdML15_NoPress:
	LDAB	#Error_Code
	BRA	CheckKbdML15_End

CheckKbdML15_End:	
	RTS
; End of CheckKbdML15

; Subroutine GetKbdML15
GetKbdML15:
	JSR	CheckKbdML15
	CMPB	#Error_Code
	BEQ	GetKbdML15
	RTS
; End of GetKbdML15

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
; Register: Changes register B
; Calls: Alarm, Delay, Outzero, Outone

Step:
	BRCLR	DrillStatus,#2,Step_Alarm
	
	LDAB	#0
	JSR	Outzero		; Set workpiece turning bit to 0
	
	LDAB	#1
	JSR	Outone		; Set clockwise turning
	
	LDAB	#0
	JSR	Outone		; Turn workpiece
	
	JSR	Delay
	JSR	Delay		; Delay 0,5 s
	
	LDAB	#1
	BRA	Step_End
Step_Alarm:
	LDAB	#2
	JSR	Alarm
	LDAB	#0
Step_End:
	RTS
; End of Step

; Subroutine DrillDownTest
; Waits a maximum of 5 s for the drill to reach the down position. The indicator
; will be read 4 times s second. If the drill is not in the down position after
; 5 s two alarm signals will be given instead.
;
; Usage:
;	JSR	DrillDownTest
; Output: Value 1 in register B if the workpiece has been turned, value 0 else.
; Register: Changes register B
; Calls: Alarm, Delay

DrillDownTest:
	PSHA
	LDAA	#20	; retry value
	LDAB	#1	; code to return if everything works
DrillDownTest_Loop:
	BRSET	DrillStatus,#4,DrillDownTest_End	; If drill is down, end subroutine
	
	JSR	Delay			; Delay for 250 ms
	DECA				; Decrease retry amount
	BNE	DrillDownTest_Loop	; If retry value != 0, retry
	
	; Else, give alarm signal
	LDAB	#2
	JSR	Alarm
	
	LDAB	#0		; Error code
DrillDownTest_End:
	PULA
	RTS
; End of DrillDownTest

; Subroutine DrillHole
DrillHole:
	JSR	DrillDown
	JSR	DrillDownTest
	JSR	DrillUp
	RTS
; End of DrillHole

; Subroutine RefPos
; Rotates the workpiece until it is in the reference position.
; Usage:
;	JSR	RefPos
; Output: 1 in register B if correct, 0 else
; Register: Changes B
; Calls: Step

RefPos:
	LDAB	#1
RefPos_Loop:
	BRSET	DrillStatus,#1,RefPos_End	; If it is in reference position, end subroutine
	
	JSR	Step
	BNE	RefPos_Loop
	
	CLRB
RefPos_End:
	RTS
; End of RefPos

; Subroutine Nstep
; Rotates trhe workpiece n steps clockwise.
;
; Usage:
;	LDAB	#n
;	JSR	Step
; Input: Number of steps, n, in register B
; Output: 1 in register B if correct, 0 else
; Register: B changes
; Calls: Step
Nstep:
	PSHA
	TBA	; Transfer B to A
	LDAB	#1
Nstep_Loop:
	CMPA	#0
	BEQ	Nstep_End
	
	DECA
	
	JSR	Step
	BNE	Nstep_Loop
	
	CLRB
Nstep_End:
	PULA
	RTS
; End of Nstep

; Subroutine DoAuto
DoAuto:
	PSHX
	
	LDX	#Pattern
	JSR	Auto
	
	PULX
	RTS
; End of DoAuto

; Subroutine Auto
; Drills according to a given pattern in a workpiece.
;
; Usage:
;	LDX	#Pattern
;	JSR	Auto
; Input: The adress to the pattern table in register X
; Calls: MotorStart, MotorStop, RefPos, Nstep, DrillHole

Auto:
	PSHB
	PSHX
	
	JSR	RefPos
	BEQ	Auto_End
	
	JSR	MotorStart
Auto_Loop:
	LDAB	,X
	INX
	
	CMPB	#$FF
	BEQ	Auto_End
	
	JSR	Nstep
	CMPB	#0
	BEQ	Auto_End
	
	JSR	DrillHole
	CMPB	#0
	BNE	Auto_Loop
	
Auto_End:
	JSR	MotorStop

	PULX
	PULB
	RTS

; End of Auto

; Delay
Delay:
	PSHX
	PSHY
DoDelay:
	LDX	#DelayConst
Next:
	LEAX	-1,X
	LDY	#DelayMultiplier
Next2:
	LEAY	-1,Y
	CPY	#0
	BNE	Next2
	CPX	#0
	BNE	Next
Delay_End:
	PULY
	PULX
	RTS
; End Delay

	USE Labdefs.asm
	
; Pekartabell för subrutiner till Command
JUMPTAB FDB	MotorStart,MotorStop
	FDB	DrillDown,DrillUp
	FDB	Step,DrillHole
	FDB	RefPos,DoAuto

; Masktabell för Outone och Outzero
ZeroMaskTable:	FCB	$FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
OneMaskTable:	FCB	$01,$02,$04,$08,$10,$20,$40,$80
	
; Globala variabler
DCShadow	RMB	1
Pattern		FCB	0,1,1,1,1,1,1,1,2,1,5,2,2,2,2,4,4,3,8,2,$FF