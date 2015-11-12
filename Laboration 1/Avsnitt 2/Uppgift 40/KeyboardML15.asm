	ORG	$1000

Start:
	JSR	CheckKdb_First
	CMPB	#$FF
	BEQ	Start
	NOP
	BRA	Start
	
	
; Subrutin CheckKbd_First
; L�ser tangentbord via ML15
; Returv�rde i B:
; B = 0..F (hexadecimalt(, tangentkod
; B = FF om ingen tangent �r nedtryckt
; Inga andra register p�verkas

CheckKdb_First:
	LDAB	$9C0
	BITB	#%10000000	; 0 if 8th bit is 0
	BEQ	Return
	LDAB	#$FF
Return:
	RTS
