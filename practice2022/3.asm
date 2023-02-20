.MODEL SMALL
.STACK 500H

.DATA

    CNT       DB 18
    STATE     DB 0

    TICKS1SEC DB 18

    AURD      DB 'ARE YOU READY?',0DH,0AH,'$'
    GO        DB 'GO',0DH,0AH,'$'

.CODE

MAIN PROC FAR
    START:    
              PUSH DS
              SUB  AX,AX
              PUSH AX

              MOV  AX,@DATA
              MOV  DS,AX
              MOV  ES,AX

              MOV  AL, 1CH
              MOV  AH, 35H
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

              MOV  SI,0FFFFH
              MOV  DI,0FFFFH
              MOV  CX,0FFFFH
    L1:       
    L2:       
              DEC  SI
              JNZ  L2
              DEC  DI
              JNZ  L1
              LOOP L1

              POP  DX
              POP  DS
              MOV  AL, 1CH
              MOV  AH, 25H
              INT  21H

              MOV  AX,4C00H
              INT  21H

              RET
MAIN ENDP

CRLF PROC NEAR
              PUSH DX
              PUSH AX
              MOV  DL,0DH
              MOV  AH, 02H
              INT  21H
              MOV  DL,0AH
              MOV  AH, 02H
              INT  21H
              POP  AX
              POP  DX
              RET
CRLF ENDP

TIMERINT PROC NEAR
              PUSH DS
              PUSH AX
              PUSH CX
              PUSH DX

              MOV  AX,@DATA
              MOV  DS,AX

              STI

              MOV  AL, 20H
              OUT  20H, AL

              DEC  CNT
              JNZ  EXIT

              MOV  DL, TICKS1SEC
              MOV  CNT, DL

              CMP  STATE, 10
              JB   COUNT10S
              JE   OUTSTR
              CMP  STATE, 11
              JE   INPUT
              JA   COUNTDOWN
              JMP  EXIT

    COUNT10S: 
              INC  STATE
              JMP  EXIT

    OUTSTR:   
              MOV  AH, 09H
              LEA  DX, AURD
              INT  21H
              INC  STATE
              JMP  EXIT

    INPUT:    
              MOV  AH, 01H
              INT  21H
              CMP  AL, 'Y'
              JNZ  N
              MOV  DL, 12
              JMP  NEXT
    N:        
              MOV  DL, 0
    NEXT:     
              MOV  STATE, DL
              CALL CRLF
              JMP  EXIT

    COUNTDOWN:
              CMP  STATE, 15
              JNB  OGO
              CMP  STATE, 15
              JB   ONUM
              JMP  EXIT
    ONUM:     
              MOV  AL, STATE
              MOV  DL, 15
              SUB  DL, AL
              ADD  DL, 30H
              MOV  AH, 02H
              INT  21H
              CALL CRLF
              INC  STATE
              JMP  EXIT
    OGO:      
              MOV  AH, 09H
              LEA  DX, GO
              INT  21H
              MOV  STATE,0
              JMP  EXIT

    EXIT:     
              CLI

              POP  DX
              POP  CX
              POP  AX
              POP  DS

              IRET
TIMERINT ENDP

END START