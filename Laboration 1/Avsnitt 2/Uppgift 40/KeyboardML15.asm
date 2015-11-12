	ORG	$1000

Start:
	JSR	CheckKdb_First
	CMPB	#$FF
	BEQ	Start
	NOP
	BRA	Start
	
	
; Subrutin CheckKbd_First
; Läser tangentbord via ML15
; Returvärde i B:
; B = 0..F (hexadecimalt(, tangentkod
; B = FF om ingen tangent är nedtryckt
; Inga andra register påverkas

CheckKdb_First:
	LDAB	$9C0
	BITB	#%10000000	; 0 if 8th bit is 0
	BEQ	Return
	LDAB	#$FF
Return:
	RTS
