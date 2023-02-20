.MODEL SMALL
.STACK 500H
.DATA
CNT DW 18
SECS DW 10
PRINT DB 0

.CODE
MAIN PROC FAR
START:
PUSH DS
SUB AX,AX
PUSH AX

MOV AX,@DATA
MOV DS,AX
MOV ES,AX

MOV AH, 35H
MOV AL, 1CH
INT 21H

PUSH ES
PUSH BX

PUSH DS
MOV DX,OFFSET TIMER
MOV AX,SEG TIMER
MOV DS,AX
MOV AH,25H
MOV AL,1CH
INT 21H
POP DS

STI

MOV CX,0FFFFH
L1:
MOV DI,0FFFFH
L2:
DEC DI
JNZ L2
LOOP L1

POP DX
POP DS

MOV AH,25H
MOV AL,1CH
INT 21H

RET
MAIN ENDP

TIMER PROC NEAR
PUSH DS
PUSH AX
PUSH BX
PUSH CX
PUSH DX

MOV  AX, @DATA
MOV  DS,AX

STI
MOV AL,20H
OUT 20H,AL

DEC CNT
JNZ EXIT
MOV CNT,18

MOV DL,PRINT
AND DL,01H
ADD DL,30H
MOV AH,02H
INT 21H

MOV DL,0AH
MOV AH,02H
INT 21H

MOV DL,0DH
MOV AH,02H
INT 21H

DEC SECS
JNZ EXIT
MOV SECS,10

MOV DL,PRINT
NOT DL
MOV PRINT,DL

EXIT:
CLI
POP DX
POP CX
POP BX
POP AX
POP DS
IRET
TIMER ENDP

END START