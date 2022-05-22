.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH 
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN