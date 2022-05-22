.MODEL SMALL
.STACK 100H
.DATA  
    CR EQU 0DH
    LF EQU 0AH
    A DB ?
    B DB ?
.CODE
    MAIN PROC 
        MOV AX, @DATA
        MOV DS, AX
        
        ;TAKE INPUT, MOV TO A, STORE IT IN B
        ;B = A
        MOV AH, 1
        INT 21H
        MOV A, AL
       
        MOV BL, A
        MOV B, BL
        
        MOV AH, 2
        MOV DL, B
        INT 21H
        ;END B = A 
        
        ;NEW LINE
        MOV AH, 2
        MOV DL, CR
        INT 21H
        
        MOV AH, 2
        MOV DL, LF
        INT 21H
        ;END NEW LINE
        
        ;A = 5 - A
        MOV AH, 1
        INT 21H
        MOV A, AL
        
        MOV BL, 5
        SUB BL, A
        MOV A, BL
        
        MOV AH, 2
        MOV DL, A
        INT 21H 
        
        ;ANOTHER APPROACH 
        MOV AH, 1
        INT 21H
        MOV A, AL
        
        NEG A
        ADD A, 5
        
        MOV AH, 2
        MOV DL, A
        INT 21H         
        ;END A = 5 - A
        
        ;A = B - 2A
        MOV AH, 1
        INT 21H
        MOV A, AL
        
        MOV AH, 1
        INT 21H
        MOV B, AL
        
        MOV BL, B
        SUB BL, A
        SUB BL, A
        MOV A, BL
        
        MOV AH, 2
        MOV DL, A
        INT 21H
        ;END A = B - 2A
             
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN