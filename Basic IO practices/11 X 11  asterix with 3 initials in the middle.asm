.MODEL SMALL
.STACK 100H
.DATA  
    CR EQU 0DH
    LF EQU 0AH
    ASTX11 DB '***********', CR, LF, '$'
    ASTX4 DB '****$'
    NEWLINE DB CR, LF, '$'
    FIRST DB ?
    MIDDLE DB ?
    LAST DB ?
.CODE
    MAIN PROC 
        MOV AX, @DATA
        MOV DS, AX
        
        MOV AH, 2
        MOV DL, '?'
        INT 21H
        
        MOV AH, 1
        INT 21H
        MOV FIRST, AL
        
        MOV AH, 1
        INT 21H
        MOV MIDDLE, AL
        
        MOV AH, 1
        INT 21H
        MOV LAST, AL
        
        MOV AH, 9
        LEA DX, NEWLINE
        INT 21H
        
        LEA DX, ASTX11
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        INT 21H
        
        LEA DX, ASTX4
        INT 21H
        
        MOV AH, 2
        MOV DL, FIRST
        INT 21H
        MOV DL, MIDDLE
        INT 21H
        MOV DL, LAST
        INT 21H 
        
        MOV AH, 9
        LEA DX, ASTX4
        INT 21H
        
        LEA DX, NEWLINE
        INT 21H
        
        LEA DX, ASTX11
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