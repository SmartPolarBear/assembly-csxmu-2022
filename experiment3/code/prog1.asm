DATA SEGMENT
    KLENMAX     DB 8
    KLEN        DB ?
    KSTR        DB 8 DUP(?)

    SLENMAX     DB 32
    SLEN        DB ?
    SSTR        DB 32 DUP(?)

    KPROMPT     DB "Enter a keyword: $"
    SPROMPT     DB "Enter a sentence: $"

    MPROMPTPRE  DB "Match at position: $"
    MPROMPTPOST DB "H of the sentence$"

    NMPROMPTPRE DB "No match found$"
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
    
               MOV    DX,[BP-2]
               MOV    AH,0AH
               INT    21H
    
               POP    AX
               POP    DX
               POP    BP
               RET
GETS ENDP

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

PUTDB PROC
               PUSH   BP
               MOV    BP,SP

               PUSH   DX
               PUSH   CX
               PUSH   BX
               PUSH   AX

               MOV    BX,[BP-2]

               MOV    CH,04H
    SWITCHLAST:
               MOV    CL,4H
               ROL    BX,CL
               MOV    AL,BL
               AND    AL,0FH
               ADD    AL,30H
               CMP    AL,3AH
               JL     LAST
               ADD    AL,07H
    LAST:      
               MOV    DX,00H
               MOV    DL,AL
               PUSH   DX
               CALL   PUTC
               ADD    SP,2
               DEC    CH
               JNZ    SWITCHLAST
    
               POP    AX
               POP    BX
               POP    CX
               POP    DX
               POP    BP
               RET
PUTDB ENDP

MAIN PROC FAR
    START:     
               MOV    AX,DATA
               MOV    DS,AX
               MOV    ES,AX
            
            

               LEA    DX,KPROMPT
               PUSH   DX
               CALL   PUTS
               ADD    SP,2

               LEA    DX,KLENMAX
               PUSH   DX
               CALL   GETS
               ADD    SP,2

               CALL   NLINE

               LEA    DX,SPROMPT
               PUSH   DX
               CALL   PUTS
               ADD    SP,2

               LEA    DX,SLENMAX
               PUSH   DX
               CALL   GETS
               ADD    SP,2

               CALL   NLINE

               LEA    SI,KSTR
               LEA    BX,SSTR
               LEA    DI,SSTR
               MOV    DL,00H
               CLD

    TRY_MATCH: 
               MOV    CL,KLEN
               REPZ   CMPSB
               JZ     MATCH

               MOV    AL,SLEN
               SUB    AL,KLEN

               JS     NOMATCH

               INC    AL
               LEA    SI,KSTR
               INC    BX
               MOV    DI,BX
               INC    DX
               CMP    DL, AL
               JL     TRY_MATCH

    NOMATCH:   
               LEA    DX,NMPROMPTPRE
               PUSH   DX
               CALL   PUTS
               ADD    SP,2
               JMP    EXIT

    MATCH:     
               LEA    DX,MPROMPTPRE
               PUSH   DX
               CALL   PUTS
               ADD    SP,2

               MOV    AX,BX
               LEA    BX,SSTR
               SUB    AX,BX
               MOV    BX,0001H
               ADD    AX,BX
               AND    AX, 00FFH
               
               MOV    DX,   AX
               PUSH   DX
               CALL   PUTDB
               ADD    SP,2

             
               LEA    DX,MPROMPTPOST
               PUSH   DX
               CALL   PUTS
               ADD    SP,2

    EXIT:      
               MOV    AH,4CH
               INT    21H

MAIN ENDP

CODE ENDS
    END MAIN
