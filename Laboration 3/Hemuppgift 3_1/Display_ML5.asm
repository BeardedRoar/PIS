;	Display_ML5.S12
;	Används vid laboration 2 ("tidsdelning")


ML5_SEG		EQU	$C02
ML5_POS		EQU	$C03
ML5_ROW		EQU	$C00
ML5_COL		EQU	$C01

DelayValue	equ	200
DelayValue2	equ	200

;- Anropa "Display"-rutin kontinuerligt
DISPLAY:
	BSR	DisplayML5
	BRA	DISPLAY
;--------------------------------------

;	Skriv ut aktuell tid och
;	fördröj c:a 0,1 s

DisplayML5:
	LDAB	#DelayValue2
Display1:
	PSHB
	BSR	disp_all
	PULB
	SUBB	#1
	BNE	Display1
	RTS


; Kod för att visa samtliga siffror EN gång
disp_all:
	LDAA	#%11011111	; Segment längst till vänster
	LDY	#seg_tab	; Pekare till segmentskoder
	LDX	#Clock		; Pekare till Klockvariabeln

disp_all_1:
	LDAB	1,X+		; läs byte från klockvariabel, peka på nästa
	LDAB	B,Y		; läs motsvarande segmentsmönster till B
	STAB	ML5_SEG		; skriv segmentmönster till port
	STAA	ML5_POS		; tänd denna display
	BSR	del_3ms		; vänta ett ögonblick
	ASRA			; nästa display...
	BCS	disp_all_1	; tills alla displayer visats

	MOVB	#$FF,ML5_POS	; släck alla displayer
	RTS

del_3ms:
	PSHB	
	LDAB	#DelayValue	
dummy:
	DBNE	B,dummy	

	PULB
	RTS

seg_tab	FCB	$77,$24,$5d,$6d,$2e,$6b,$7b,$25
	FCB	$7f,$6f,$3f,$7a,$58,$7c,$5b,$1b

; Variabler
Clock	FCB	1,2,3,4,5,6,7,8

	
