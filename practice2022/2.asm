.MODEL SMALL
.STACK 500H
.DATA

    MAP  DB 105 DUP(0)
    MSG  DB 'Last digit is $'
    MSG2 DB ':',0DH,0AH,'$'

.CODE

MAIN PROC FAR
    START:    
              PUSH DS
              SUB  AX,AX
              PUSH AX
              MOV  AX,@DATA
              MOV  DS,AX
              MOV  ES,AX

              MOV  CX, 99

    L:        
              MOV  DX,CX
              ADD  DX,1

              PUSH DX
              CALL TESTPRIME
              ADD  SP,2

              CMP  AX,0
              JZ   NEXT

              MOV  SI,DX
              MOV  MAP[SI],AL

    NEXT:     
              LOOP L

              MOV  CX,9
    OL:       
              PUSH CX
              MOV  DI,10
              SUB  DI,CX

              LEA  DX,MSG
              MOV  AH,09H
              INT  21H

              MOV  DX, DI
              ADD  DL, 30H
              MOV  AH,02H
              INT  21H

              LEA  DX,MSG2
              MOV  AH,09H
              INT  21H

              MOV  CX,100
    ALL:      
              MOV  SI,CX
              MOV  BX,0
              MOV  BL,MAP[SI]
              CMP  BX,DI
              JNZ  SKIP

              PUSH SI
              CALL DECOUT
              ADD  SP,2

    SKIP:     
              LOOP ALL

              POP  CX
              LOOP OL

              RET
MAIN ENDP

DECOUT PROC NEAR
              PUSH BP
              MOV  BP, SP
              PUSH DX
              PUSH CX
              PUSH BX
              PUSH AX

              MOV  AX,[BP+4]
              MOV  BX,10
              MOV  CX,0

    DEPART:   
              MOV  DX,0
              MOV  BX,10
              DIV  BX

              PUSH DX
              INC  CX

              CMP  AX,0
              JZ   OUTPUT
              JMP  DEPART

    OUTPUT:   
              POP  DX
              ADD  DL,30H
              MOV  AH,02H
              INT  21H
              LOOP OUTPUT

              MOV  DL, 0AH
              MOV  AH, 02H
              INT  21H

              MOV  DL, 0DH
              MOV  AH, 02H
              INT  21H

              POP  AX
              POP  BX
              POP  CX
              POP  DX
              POP  BP

              RET
DECOUT ENDP

TESTPRIME PROC NEAR
              PUSH BP
              MOV  BP,SP
              PUSH DX
              PUSH BX
              PUSH CX
              PUSH SI

              MOV  DX, [BP+4]
              MOV  SI, DX

              CMP  SI,2
              JZ   P

              MOV  CX,SI
              SUB  CX,2

    DIVTEST:  
              MOV  BX,CX
              ADD  BX,1
              MOV  AX,SI
              MOV  DX,0

              DIV  BX

              CMP  DX,0
              JZ   NP
              LOOP DIVTEST

    P:        
              MOV  AX, SI
              MOV  BX, 10
              MOV  DX, 0

              DIV  BX
              MOV  AX,DX
              JMP  EXIT

    NP:       
              MOV  AX,0

    EXIT:     

              POP  SI
              POP  CX
              POP  BX
              POP  DX
              POP  BP

              RET
TESTPRIME ENDP

END START