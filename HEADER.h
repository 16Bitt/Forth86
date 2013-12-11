
%macro NEXT 0
	RETF
%endmacro

%define PUSHVAL 0xB8

%macro FPUSH 1
	MOV AX, %1
	MOV [BP], AX
	ADD BP, 2
%endmacro

%macro FPOP 1
	SUB BP, 2
	MOV %1, [BP]
%endmacro

CPUSHF:
	FPUSH AX
	NEXT

%define STACK ENDKERNEL
;STACK:	times 32 db 0
%define DISK STRBUF+512
%define HEAP DISK+512
;HEAP: times 64 db 0
%define MIRROR STACK+512
;MIRROR: times 16 db 0
%define STRBUF MIRROR+128
;STRBUF: times 128 db 0

STR_DAT: dw STRBUF
HEAP_DAT: dw HEAP
MIR_DAT: dw MIRROR
LAST: dw FLBL33
