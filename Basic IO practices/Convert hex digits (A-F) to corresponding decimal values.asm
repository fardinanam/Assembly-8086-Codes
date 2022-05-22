.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A HEX DIGIT: $'
    MSG2 DB CR, LF, 'IN DECIMAL IT IS $'
        
.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
        ;PRINT MSG1
        MOV AH, 9
        LEA DX, MSG1
        INT 21H
        
        ;INPUT HEX DIGIT (A-F)
        MOV AH, 1
        INT 21H
        MOV BL, AL             
        ;CONVERT HEX A TO 0 AND SO ON
        SUB BL, 'A'
        ADD BL, '0'                  
        
        ;PRINT MSG2
        MOV AH, 9
        LEA DX, MSG2
        INT 21H     
        
        ;PRINT CORRESPONDING DECIMAL
        MOV AH, 2
        MOV DL, '1'
        INT 21H
        MOV DL, BL
        INT 21H
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN