.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    L DB ? 
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        ;INPUT
        MOV AH, 1
        INT 21H
        MOV L, AL
        
        ;CONVERT TO LOWERCASE
        SUB L, 1
        ADD L, 32
                
        ;OUTPUT
        MOV AH, 2
        MOV DL, L
        INT 21H
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN