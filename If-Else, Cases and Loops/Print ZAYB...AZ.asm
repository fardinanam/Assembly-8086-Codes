.MODEL SMALL
.STACK 100H
.DATA 
    INCREMENT DB 0
.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
        
        MOV AH, 2
        
        LOOP_:
            MOV BL, 'Z'
            SUB BL, INCREMENT
            MOV DL, BL
            INT 21H
            
            MOV BL, 'A'
            ADD BL, INCREMENT
            MOV DL, BL
            INT 21H
            
            INC INCREMENT
            CMP INCREMENT, 26
            JNZ LOOP_    
    
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN    