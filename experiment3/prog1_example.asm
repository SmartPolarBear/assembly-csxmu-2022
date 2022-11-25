NewLine macro
            mov dl,0dh    ;0D=CR renturn
            mov ah,02h
            int 21h       ;call int 21
            mov dl,0ah    ;0A=LF new line
            mov ah,02h
            int 21h       ;call int 21
endm

dseg segment
    maxlenk  db 8                            ;max keyword length
    factlenk db ?                            ;keyword length to enter
    key_word db 8 dup(?)
    maxlens  db 32                           ;max sentence length
    factlens db ?                            ;sentence length to enter
    sentence db 32 dup(?)                    ;sentence here
    
    ;Messages to display
    info1    db 'Enter Keyword:$'
    info2    db 'Enter Sentence:$'
    mess0    db 'Match At Location:$'
    mess1    db 'No Match!$'
    mess2    db ?,?,'H Of The Sentence.$'
dseg ends
;empty stack segment avoid warning
sseg segment stack
sseg ends
cseg segment
main proc far
           assume  cs:cseg,ds:dseg,es:dseg,ss:sseg
    start:                                            ;start address of the program
    ;display msg and get input
           push    ds                                 ;save ds
           sub     ax,ax                              ;set ax to zero
           push    ax                                 ;save ax
           mov     ax,dseg
           mov     ds,ax
           mov     es,ax
           mov     ah,09h
           lea     dx,info1
           int     21h                                ;display info1 let user enter keyword
           mov     ah,0ah
           lea     dx,maxlenk
           int     21h                                ;read the keyword from user’s input
    begin: 
           NewLine
           mov     ah,09h
           lea     dx,info2
           int     21h                                ;display info2 let user enter sentence
           mov     ah,0ah
           lea     dx,maxlens
           int     21h                                ;read the sentence
           NewLine
           lea     si,key_word                        ;get address of key_word
           lea     bx,sentence
           lea     di,sentence                        ;get address of sent
           mov     dl,00h
           cld                                        ;clear
    again: 
           mov     cl,factlenk
           repz    cmpsb
           jz      match
           mov     al,factlens
           sub     al,factlenk
           js      next1
           inc     al
           lea     si,key_word
           inc     bx
           mov     di,bx
           inc     dx
           cmp     dl,al
           jl      again
    ;No Match!
    next1: 
           lea     dx,mess1
           mov     ah,09h
           int     21h
           jmp     begin                              ;return to begin and wait for input sent
    ;Match
    match: 
           lea     dx,mess0
           mov     ah,09h
           int     21h                                ;display match at loc…
           mov     ax,bx
           lea     bx,sentence
           sub     ax,bx
           mov     bx,0001h
           add     ax,bx
           and     ax,00ffh
           xchg    ax,bx
           mov     ch,2
    ;display acsii
    rotate:
           mov     cl,4h
           rol     bl,cl
           mov     al,bl
           and     al,0fh
           add     al,30h
           cmp     al,3ah
           jl      print
           add     al,7h
    print: 
           mov     ah,02h
           mov     dl,al
           int     21h
           dec     ch
           jnz     rotate
    
           mov     ah,09h
           lea     dx,mess2
           int     21h                                ; H of the sent…
           jmp     begin                              ;back to begin
           ret
main endp
cseg ends
end start
