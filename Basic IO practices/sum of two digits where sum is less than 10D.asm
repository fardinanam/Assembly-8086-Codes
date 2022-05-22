.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB CR, LF, 'The sum of $'
    MSG2 DB ' and $'
    MSG3 DB ' is $'    
.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
        ;PRINT ?
        MOV AH, 2
        MOV DL, '?'
        INT 21H    
        
        ;TAKE FIRST NUM AND SAVE IT TO BH
        MOV AH, 1
        INT 21H
        MOV BH, AL
        
        ;TAKE FIRST NUM AND SAVE IT TO BL
        INT 21H
        MOV BL, AL
        
        ;PRINT MSG1            
        MOV AH, 9            
        LEA DX, MSG1
        INT 21H
        
        ;PRINT FIRST NUMBER
        MOV AH, 2
        MOV DL, BH
        INT 21H
        
        ;PRINT MSG2
        MOV AH, 9            
        LEA DX, MSG2
        INT 21H
        
        ;PRINT SECOND NUM
        MOV AH, 2
        MOV DL, BL
        INT 21H
        
        ;PRINT MSG3
        MOV AH, 9            
        LEA DX, MSG3
        INT 21H
        
        ;ADD THE NUMBERS AND PRINT THE SUM
        ADD BL, BH
        SUB BL, '0'
        MOV AH, 2
        MOV DL, BL
        INT 21H
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN