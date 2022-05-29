.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    HP DB ? 
.CODE
    MAIN PROC  
        MOV AX, @DATA
        MOV DS, AX
        
        ;INPUT (A TO H)
        MOV AH, 1
        INT 21H
        MOV HP, AL  ;(LET HP = 'B')
        
        ;CONVERT HP TO DECIMAL (7 TO 0)
        SUB HP, 'A' ;HP=HP-'A' (66-65=1)
        MOV BL, 7   
        SUB BL, HP  ;7-HP (7-1)
        ADD BL, '0' ;7-HP+'0' (6+30 = 36('6'))
        
        ;OUPUT
        MOV AH, 2
        MOV DL, '1' ;WILL PRINT 1
        INT 21H  
        MOV DL, BL  ;WILL PRINT 6
        INT 21H     ;B == 16 IN REVERSE OCTADECIMAL
        
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN