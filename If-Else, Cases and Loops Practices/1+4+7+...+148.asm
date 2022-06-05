.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH 
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        MOV BX, 1
        MOV CX, 0
        LOOP_:
            ADD CX, BX
            ADD BX, 3

            CMP BX, 151
            JNE LOOP_
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN