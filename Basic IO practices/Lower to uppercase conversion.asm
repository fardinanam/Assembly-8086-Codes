.MODEL SMALL
.STACK 100H
.DATA      
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'Enter a lowercase letter: $'
    MSG2 DB CR, LF, 'The uppercase letter is: $'
    UC DB ?
    
.CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
                
        LEA DX, MSG1
        MOV AH, 9
        INT 21H
        
        MOV AH, 1
        INT 21H
        MOV UC, AL
        SUB UC, 20H
        
        LEA DX, MSG2
        MOV AH, 9
        INT 21H
        
        MOV AH, 2
        MOV DL, UC
        INT 21H
               
               
        MOV AH, 4CH
        INT 21H
    MAIN ENDP
END MAIN