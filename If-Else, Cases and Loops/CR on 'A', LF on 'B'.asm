.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH 
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        ;INPUT
        MOV AH, 1
        INT 21H

        MOV AH, 2
        ;IF
        CMP AL, 'A'
        JNZ ELIF
        ;THEN
        MOV DL, CR
        JMP END_IF
        ELIF:
        CMP AL, 'B'
        JNZ END_IF
        ;THEN 
        MOV DL, LF
        END_IF: 
        INT 21H
        
        MOV DL, 'F'
        INT 21H
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN