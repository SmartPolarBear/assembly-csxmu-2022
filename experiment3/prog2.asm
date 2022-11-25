DATA SEGMENT
    SLENMAX  DB 32
    SLEN     DB ?
    STR      DB 32 DUP(?)

    MSGINPUT DB 'Input String:$'
    MSGLET   DB 'Letters:$'
    MSGCOUNT DB 'Digits:$'
    MSGOTHER DB 'Other:$'

    LETTER   DW 0
    DIGIT    DW 0
    OTHER    DW 0
DATA ENDS

CODE SEGMENT
           ASSUME CS:CODE, DS:DATA, ES:DATA

PUTC PROC
           PUSH   BP
           MOV    BP,SP
           PUSH   DX
           PUSH   AX

           MOV    DL,[BP-2]
           MOV    AH,02H
           INT    21H

           POP    AX
           POP    DX
           POP    BP
           RET
PUTC ENDP

PUTS PROC
           PUSH   BP
           MOV    BP,SP
           PUSH   DX
           PUSH   AX

           MOV    DX,[BP-2]
           MOV    AH,09H
           INT    21H

           POP    AX
           POP    DX
           POP    BP
           RET
PUTS ENDP

GETS PROC
           PUSH   BP
           MOV    BP,SP

           PUSH   DX
           PUSH   AX

           MOV    DX, [BP-2]
           MOV    AH,0AH
           INT    21H

           POP    AX
           POP    DX
           POP    BP
           RET
GETS ENDP

PUTDB PROC
           PUSH   BP
           MOV    BP,SP

           PUSH   DX
           PUSH   CX
           PUSH   BX
           PUSH   AX

           MOV    BX,[BP-2]
           MOV    CH,04H
    SWITCH:
           MOV    CL,4H
           ROL    BX,CL
           MOV    AL,BL
           AND    AL,0FH
           ADD    AL,30H
           CMP    AL,3AH
           JL     PRINT
           ADD    AL,07H
    PRINT: 
           MOV    DX,00H
           mov    DL,AL
           PUSH   DX
           CALL   PUTC
           ADD    SP,2
           DEC    CH
           JNZ    SWITCH

           POP    AX
           POP    BX
           POP    CX
           POP    DX
           POP    BP
           RET
PUTDB ENDP

NLINE PROC
           PUSH   BP
           MOV    BP,SP
           PUSH   DX

           MOV    DX,0DH
           PUSH   DX
           CALL   PUTC
           ADD    SP,2

           MOV    DX,0AH
           PUSH   DX
           CALL   PUTC
           ADD    SP,2

           POP    DX
           POP    BP
           RET
NLINE ENDP


MAIN PROC FAR
    START: 
           MOV    AX,DATA
           MOV    DS,AX
           MOV    ES,AX

           LEA    DX,MSGINPUT
           PUSH   DX
           CALL   PUTS
           ADD    SP,2

           LEA    DX, SLENMAX
           PUSH   DX
           CALL   GETS
           ADD    SP,2

           LEA    SI,STR
           CLD
    BEGIN: 
           LODSB
           CMP    AL,0DH
           JE     NEXT

           CMP    AL,30h
           JC     OTH
           CMP    AL,3ah
           JC     NUM
           CMP    AL,41h
           JC     OTH
           CMP    AL,5bh
           JC     LET
           CMP    AL,61h
           JC     OTH
           CMP    AL,7bh
           JC     LET
    LET:   
           INC    LETTER
           JMP    BEGIN
    NUM:   
           INC    DIGIT
           JMP    BEGIN
    OTH:   
           INC    OTHER
           JMP    BEGIN
    NEXT:  
           CALL   NLINE

           LEA    DX,MSGLET
           PUSH   DX
           CALL   PUTS
           ADD    SP,2
    
           MOV    DX,LETTER
           PUSH   DX
           CALL   PUTDB
           ADD    SP,2
    
           CALL   NLINE
    
           LEA    DX,MSGCOUNT
           PUSH   DX
           CALL   PUTS
           ADD    SP,2
    
           MOV    DX,DIGIT
           PUSH   DX
           CALL   PUTDB
           ADD    SP,2
    
           CALL   NLINE
    
           LEA    DX,MSGOTHER
           PUSH   DX
           CALL   PUTS
           ADD    SP,2
    
           MOV    DX,OTHER
           PUSH   DX
           CALL   PUTDB
           ADD    SP,2
    
           CALL   NLINE

    EXIT:  
           MOV    AH,4CH
           INT    21H
MAIN ENDP
CODE ENDS
END MAIN