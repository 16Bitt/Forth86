{ LOADED
T MOV AX, TESTSTR
NT FPUSH AX
NT FWORD WRITE
NT NEXT
N TESTSTR: db ">FORTH ENVIRONMENT LOADED",0 }

{ JMP
T FPOP AX
NT POP ECX
NT POP ECX
NT JMP AX }

{ ZJMP
T FPOP AX
NT FPOP BX
NT OR BX, BX
NT JNZ NOTZJMP
NT POP ECX
NT POP ECX
NT JMP AX

N NOTZJMP: }

{ WRITEJMP
T MOV AX, JMPNAME
NT FPUSH AX
NT FWORD FIND
NT FWORD >CFA
NT FWORD WRITECALL
NT FWORD ,
NT XOR AX, AX
NT FPUSH AX
NT FWORD ,
NT NEXT

N JMPNAME: db "JMP", 0 }

{ WRITEZJMP
T MOV AX, ZJMPNAME
NT FPUSH AX
NT FWORD FIND
NT FWORD >CFA
NT FWORD WRITECALL
NT FWORD ,
NT XOR AX, AX
NT FPUSH AX
NT FWORD ,
NT NEXT

N ZJMPNAME: db "ZJMP", 0 }

: LOC HERE M> ;
: $IF WRITEPUSH LOC 0 , WRITEFIX WRITEZJMP ;
: $THEN HERE >M ! ;
: $ELSE >M WRITEPUSH LOC 0 , WRITEFIX WRITEJMP HERE SWAP ! ;
: $LOOP LOC ;
: $REPEAT WRITEPUSH >M , WRITEFIX WRITEZJMP ;

{ STACKBASE
T MOV AX, STACK
NT FPUSH AX }

{ MBASE
T MOV AX, MIRROR
NT FPUSH AX }

{ HEAPBASE
T MOV AX, HEAP
NT FPUSH AX }

{ DISKBUFFER
T MOV AX, DISK
NT FPUSH AX }

{ DISK-READ
NT FPOP CX 
NT MOV AH, 2
NT MOV AL, 1
NT MOV BX, DISK
NT XOR DX, DX
NT MOV DL, byte [0x7C05]
N TRYREAD:
NT INT 13h
NT JC TRYREAD }

{ DISK-WRITE
NT FPOP CX
NT MOV AH, 3
NT MOV AL, 1
NT MOV BX, DISK
NT XOR DX, DX
NT MOV DL, byte [0x7C05]
NT N TRYWRITE:
NT INT 13h
NT JC TRYWRITE }

: : CREATE [ ;
: $; ] WRITERET ;

{ ZEROBUFFER
T XOR AL, AL
NT MOV DI, DISK
NT MOV BX, 512

N SPCBUFLOOP:
NT STOSB
NT DEC BX
NT OR BX, BX
NT JNZ SPCBUFLOOP }

: VAR CREATE WRITEPUSH HERE 8 + , WRITEFIX WRITERET &HERE 2+! ;
: NEW ZEROBUFFER SENTENCE STR<< STR DISKBUFFER TRANSFER-STRING CLEAR-STRING-BUFFER ;
: LOCATIONS HERE . SPC STR . NEWLINE ;
: LOAD DISK-READ STR<< DISKBUFFER STR TRANSFER-STRING EVAL ;

: GO LOADED NEWLINE REPL HANG ;
