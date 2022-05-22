.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH

.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
        ;DISPLAY ?
        MOV AH, 2
        MOV DL, '?'
        INT 21H
        
        ;READ A CHARACTER
        MOV AH, 1
        INT 21H
        MOV BL, AL          
        
        ;PRINT NEW LINE
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        
        ;PRINT THE INPUT VALUE
        MOV DL, BL
        INT 21H      
        
        MOV AH, 4CH
        INT 21H
    MAIN ENDP  
END MAIN