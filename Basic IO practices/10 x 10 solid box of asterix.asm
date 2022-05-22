.MODEL SMALL
.STACK 100H
.DATA  
    CR EQU 0DH
    LF EQU 0AH
    ASTX DB '**********', CR, LF, '$'
.CODE
    MAIN PROC 
        MOV AX, @DATA
        MOV DS, AX
        
        
        MOV AH, 9
        LEA DX, ASTX
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        
             
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN