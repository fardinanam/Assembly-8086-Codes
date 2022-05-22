.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    N DB ? 
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        MOV AH, 1
        INT 21H
        MOV N, AL
        
        NEG N
        SUB N, 1
        
        MOV AH, 2
        MOV DL, N
        INT 21H    
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN