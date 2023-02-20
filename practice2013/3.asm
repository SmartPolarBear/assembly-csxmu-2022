.MODEL SMALL
.STACK 500H

.DATA

    COUNTER DW 18
    SECS    DW 0

.CODE

MAIN PROC FAR
    START:   
             PUSH DS
             SUB  AX,AX
             PUSH AX

             MOV  AX,@DATA
             MOV  DS,AX
             MOV  ES,AX

             MOV  AH,35H
             MOV  AL,1CH
             INT  21H

             PUSH ES
             PUSH BX

             PUSH DS
             MOV  DX, OFFSET TIMERINT
             MOV  AX, SEG TIMERINT
             MOV  DS,AX
             MOV  AL, 1CH
             MOV  AH, 25H
             INT  21H
             POP  DS

             STI

             MOV  CX,0FFFFH
    D1:      
             MOV  SI,0FFFFH
    D2:      
             DEC  SI
             JNZ  D2
             LOOP D1

             POP  DS
             POP  DX
             MOV  AH,25H
             MOV  AL,1CH
             INT  21H

             RET
MAIN ENDP

DECOUT PROC NEAR
             PUSH BP
             MOV  BP,SP
             PUSH AX
             PUSH BX
             PUSH CX
             PUSH DX
             MOV  DX,[BP+4]

             MOV  AX,DX
             MOV  BX,10
             MOV  CX,0
    DEFORM:  
             MOV  BX,10
             MOV  DX,0
             DIV  BX

             INC  CX
             PUSH DX

             CMP  AX,0
             JZ   OUTPUT
             JMP  DEFORM

    OUTPUT:  
             POP  DX
             ADD  DX,30H
             MOV  AH,02H
             INT  21H
             LOOP OUTPUT

             MOV  DX,0DH
             MOV  AH,02H
             INT  21H

             MOV  DX,0AH
             MOV  AH,02H
             INT  21H

             POP  DX
             POP  CX
             POP  BX
             POP  AX
             POP  BP
             RET
DECOUT ENDP

TIMERINT PROC NEAR
             PUSH DS
             PUSH AX
             PUSH BX
             PUSH CX
             PUSH DX

             MOV  AX, @DATA
             MOV  DS,AX

             STI

             MOV  AL,20H
             OUT  20H,AL

             DEC  COUNTER
             JNZ  EXIT
             MOV  COUNTER,18

             INC  SECS

             MOV  DX, SECS
             PUSH DX
             CALL DECOUT
             ADD  SP,2

    EXIT:    
             CLI

             POP  DX
             POP  CX
             POP  BX
             POP  AX
             POP  DS
             IRET
TIMERINT ENDP
END MAIN