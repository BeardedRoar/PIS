Keyboard	EQU	$9C0
Error_Code	EQU	$FF

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