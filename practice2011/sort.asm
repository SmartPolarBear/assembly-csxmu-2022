.MODEL SMALL
.STACK 500H

.DATA

    NUMS DW 15,23,54,3,56,12,45,124,1,5
    NUML DW 10

.CODE

MAIN PROC FAR
    START: 
           PUSH DS
           SUB  AX,AX
           PUSH AX

           MOV  AX,@DATA
           MOV  DS,AX
           MOV  ES,AX

           MOV  CX,NUML
           SUB  CX,1
    OUTER: 
           MOV  SI,0
           MOV  DI,0
    INNER: 
           MOV  AX,NUMS[SI]
           MOV  BX,NUMS[SI+2]
           CMP  AX,BX
           JB   NEXT
    ;    JA   NEXT
           MOV  NUMS[SI],BX
           MOV  NUMS[SI+2],AX
    NEXT:  
           ADD  SI,2
           INC  DI
           CMP  DI,CX
           JB   INNER
           LOOP OUTER

           MOV  CX,10
           MOV  SI,0
    RES:   
           MOV  DX,NUMS[SI]
           PUSH DX
           CALL DECOUT
           ADD  SP,2
           ADD  SI,2
           LOOP RES

           RET
MAIN ENDP

DECOUT PROC NEAR
           PUSH BP
           MOV  BP,SP
           PUSH AX
           PUSH BX
           PUSH CX
           PUSH DX

           MOV  AX,[BP+4]
           MOV  BX,10
           MOV  CX,0
           MOV  DX,0
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
           ADD  DL,30H
           MOV  AH,02H
           INT  21H
           LOOP OUTPUT

           MOV  DL,0AH
           MOV  AH,02H
           INT  21H

           MOV  DL,0DH
           MOV  AH,02H
           INT  21H

           POP  DX
           POP  CX
           POP  BX
           POP  AX
           POP  BP
           RET
DECOUT ENDP

END START
