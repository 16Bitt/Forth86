;How do I into registers? :(
;Another garbage implementation.
;This simply compares an int to a LUT 4 times
	
	FPOP AX
	MOV DX, AX
	MOV BX, REF_TAB
	
	SHR AX, 12
	AND AX, 0x000F
	ADD BX, AX
	MOV AL, byte  [BX]
	MOV AH, 0x0E
	INT 0x10
	MOV AX, DX
	MOV BX, REF_TAB

	SHR AX, 8
	AND AX, 0x000F
	ADD BX, AX
	MOV AL, byte [BX]
	MOV AH, 0x0E
	INT 0x10
	MOV AX, DX
	MOV BX, REF_TAB

	SHR AX, 4
	AND AX, 0x000F
	ADD BX, AX
	MOV AL, byte [BX]
	MOV AH, 0x0E
	INT 0x10
	MOV AX, DX
	MOV BX, REF_TAB

	AND AX, 0x000F
	ADD BX, AX
	MOV AL, byte [BX]
	MOV AH, 0x0E
	INT 0x10
	
	NEXT

REF_TAB: db "0123456789ABCDEF"
