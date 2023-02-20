.MODEL SMALL
.STACK 500H
.DATA
    GRADES DW 16 DUP(?)
    NUM    DW 0
    BUF    DB 3,0,3 DUP(?)
.CODE

MAIN PROC FAR
    START:     
               PUSH DS
               SUB  AX,AX
               PUSH AX

               MOV  AX,@DATA
               MOV  DS,AX
               MOV  ES,AX

               MOV  SI,0
    INPUT:     
               LEA  DX,BUF
               MOV  AH,0AH
               INT  21H

               MOV  DL,0AH
               MOV  AH,02H
               INT  21H

               MOV  DL,0DH
               MOV  AH,02H
               INT  21H

               LEA  BX,BUF
               MOV  AL,BYTE PTR [BX+1]
               CMP  AL,0
               JZ  NEXT
               MOV  CH,BYTE PTR [BX+2]
               MOV  CL,BYTE PTR [BX+3]
               SUB  CX,3030H

               MOV  AH,0
               MOV  AL,CH
               MOV  BX,10
               MUL  BX
               MOV  BH,0
               MOV  BL,CL
               ADD  AX,BX

               MOV  GRADES[SI],AX
               ADD  SI,2
               INC  NUM

               JMP  INPUT
    NEXT:      

               MOV  CX,NUM
               SUB  CX,1
    OUTER:     
               MOV  SI,0
               MOV  DI,0
    INNER:     
               MOV  AX, GRADES[SI]
               MOV  BX, GRADES[SI+2]
               CMP  AX,BX
               JG   AFTER                 ;L=从小到大，G=从大到小
               MOV  GRADES[SI],BX
               MOV  GRADES[SI+2],AX
    AFTER:     
               ADD  SI,2
               INC  DI
               CMP  DI,CX
               JL   INNER
               LOOP OUTER

               MOV  CX,NUM
               MOV  SI,0
    O:         
               MOV  DX, GRADES[SI]
               PUSH DX
               CALL DECOUT
               ADD  SP,2
               ADD  SI,2
               LOOP O

               MOV DX,NUM
               PUSH DX
               CALL HEXOUT
               ADD SP,2

               RET
MAIN ENDP

DECOUT PROC NEAR
               PUSH BP
               MOV  BP,SP
               PUSH DX
               PUSH CX
               PUSH BX
               PUSH AX

               MOV  AX,[BP+4]
               MOV  BX,10
               MOV  CX,0
               MOV  DX,0

    DIVISION:  
               MOV  BX,10
               MOV  DX,0
               DIV  BX

               PUSH DX
               INC  CX

               CMP  AX,0
               JZ   OUTPUT

               JMP  DIVISION

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

               POP  AX
               POP  BX
               POP  CX
               POP  DX
               POP  BP
               RET
DECOUT ENDP


HEXOUT PROC
               PUSH BP
               MOV  BP,SP

               PUSH DX
               PUSH CX
               PUSH BX
               PUSH AX

               MOV  BX,[BP+4]

               MOV  CH,04H
    SWITCHLAST:
               MOV  CL,4H
               ROL  BX,CL
               MOV  AL,BL
               AND  AL,0FH
               ADD  AL,30H
               CMP  AL,3AH
               JL   LAST
               ADD  AL,07H
    LAST:      
               MOV  DX,00H
               MOV  DL,AL
               MOV  AH,02H
               INT  21H
               DEC  CH
               JNZ  SWITCHLAST
    
               POP  AX
               POP  BX
               POP  CX
               POP  DX
               POP  BP
               RET
HEXOUT ENDP



END START