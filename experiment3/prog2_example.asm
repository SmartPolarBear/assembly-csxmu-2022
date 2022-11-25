;Count_Char Program By K-Res 2004-12-19
;Macro used to begin a new line
Newline macro
    ;CR return
            mov dl,0dh
            mov ah,02h
            int 21h
    ;LF new line
            mov dl,0ah
            mov ah,02h
            int 21h
endm
;Data segment
dseg segment
    maxlen  db 80                  ;max string length
    factlen db ?                   ;real string length
    string  db 80 dup(?)           ;Input string
    ;counters needed
    letter  dw ?
    digit   dw ?
    others  dw ?
    ;Messages
    inf0    db 'Input String:$'
    inf1    db 'Letters:$'
    inf2    db 'Digits:$'
    inf3    db 'Others:$'
dseg ends
;Stack segment avoid warning
sseg segment stack
sseg ends
;Code segment
cseg segment
    ;Main Proc
main proc far
             assume  cs:cseg,ds:dseg,ss:sseg
    start:                                      ;start address
    ;setup stack for return
             push    ds                         ;save old data segment on stack
             xor     ax,ax                      ;zero in ax
             push    ax                         ;save ax on stack
    ;set DS reg to current data segment
             mov     ax,dseg                    ;dseg segment addr
             mov     ds,ax                      ;into ds reg
    ;display inf0
             mov     ah,09h
             lea     dx,inf0
             int     21h
    ;get input string
             mov     ah,0ah
             lea     dx,maxlen
             int     21h
    ;begin a new line
             Newline
             mov     dl,00h                     ;clear dl reg
             cld                                ;clear direction
    ;ready to count chars
    ;reset counters
             mov     letter,0
             mov     digit,0
             mov     others,0
    ;put zero in si
             xor     si,si
    next:    
    ;get one char
             mov     al,string[si]
             and     ax,00ffh                   ;clear high bits
             cmp     ax,0dh                     ;if it is CR meaning end
             jz      exit
    ; category
             cmp     ax,30h
             jc      IsOthers
             cmp     ax,3ah
             jc      IsDigit
             cmp     ax,41h
             jc      IsOthers
             cmp     ax,5bh
             jc      IsLetter
             cmp     ax,61h
             jc      IsOthers
             cmp     ax,7bh
             jc      IsLetter
    ; count
    IsLetter:
             inc     letter
             jmp     GoNext
    IsOthers:
             inc     others
             jmp     GoNext
    IsDigit: 
             inc     digit
             jmp     GoNext
    GoNext:  
    ; move to next char
             inc     si
             jmp     next
    ; counting ends here display result
    exit:    
             lea     dx,inf1
             mov     ah,09h
             int     21h
             mov     bx,letter
             call    binihex
             Newline
             lea     dx,inf2
             mov     ah,09h
             int     21h
             mov     bx,digit
             call    binihex
             Newline
             lea     dx,inf3
             mov     ah,09h
             int     21h
             mov     bx,others
             call    binihex
             Newline
             jmp     start
             ret
main endp
    ;display the number
binihex proc near
             mov     ch,4
    rotate:  
             mov     cl,4
             rol     bx,cl
             mov     al,bl
             and     al,0fh
             add     al,30h
             cmp     al,3ah
             jl      printit
             add     al,7h
    printit: 
             mov     dl,al
             mov     ah,2
             int     21h
             dec     ch
             jnz     rotate
             ret
binihex endp
cseg ends
end start