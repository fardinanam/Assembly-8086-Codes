.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH   
    X DB ?
    Y DB ?
    Z DB ?
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        ;INPUT X
        MOV AH, 1
        INT 21H
        MOV X, AL
        SUB X, '0'
        
        ;INPUT Y
        INT 21H
        MOV Y, AL
        SUB Y, '0'
        
        ;Z = X-2Y
        MOV BL, X
        SUB BL, Y
        SUB BL, Y
        MOV Z, BL
        ADD Z, '0'  
        
        ;PRINT OUTPUT
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        MOV DL, Z
        INT 21H
        
        ;Z = 25-(X+Y)
        MOV BL, 25
        SUB BL, X
        SUB BL, Y
        MOV Z, BL
        ADD Z, '0'
        
        ;PRINT OUTPUT
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        MOV DL, Z
        INT 21H
        
        ;Z = 2X-3Y
        MOV BL, X
        ADD BL, X
        SUB BL, Y
        SUB BL, Y
        SUB BL, Y
        MOV Z, BL
        ADD Z, '0'
        
        ;PRINT OUTPUT
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        MOV DL, Z
        INT 21H
        
        ;Z = Y-X+1
        MOV BL, Y
        SUB BL, X
        ADD BL, 1
        MOV Z, BL
        ADD Z, '0'
        
        ;PRINT OUTPUT
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        MOV DL, Z
        INT 21H 
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN