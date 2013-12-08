	[ORG 0x7c00]
	[BITS 16]

	JMP 0:ENTRYPOINT
ENTRYPOINT:
	CLI
	XOR AX, AX
	MOV ES, AX
	MOV DS, AX
	MOV SS, AX
	MOV AX, 0x7C00			;stack grows down
	MOV SP, AX
	STI
	
	MOV byte [ENTRYPOINT], DL	;Save boot drive at 0x7C05
	MOV SI, STR
	CALL PUTS			;Print string

	MOV BX, 0x7E00			;Address to write to
	MOV AH, 2			;FLOPPYREAD
	MOV AL, 10			;Number of sectors to load
	MOV CH, 0			;Track
	MOV CL, 2			;Segment
	MOV DH, 0			;Drive head
LOAD_DISK:
	INT 0x13			;Floppy interrupt
	JC LOAD_DISK			;If issue, try again
	
	CLI
	JMP NEXT
	
PUTS:
	PUSHA
	MOV AH, 0x0E
LOOP:
	LODSB
	OR AL, AL
	JZ ENDPUTS
	INT 0x10
	JMP LOOP
ENDPUTS:
	POPA
	RET

STR: 	db ">MINIMAL BOOT ENVIRONMENT STARTED",13,10,0

	times 510 - ($ - $$) db 0

	DW 0xAA55	;boot signature

NEXT:
