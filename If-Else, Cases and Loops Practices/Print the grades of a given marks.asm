.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH 
    
    N DW ?
    APLUS DB 'A+$'
    A DB 'A$'
    AMINUS DB 'A-$'
    BPLUS DB 'B+$'
    B DB 'B$'
    BMINUS DB 'B-$'
    C DB 'C$'
    F DB 'F$'
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        ; fast BX = 0
        XOR BX, BX
        
        INPUT_LOOP:
        ; char input 
        MOV AH, 1
        INT 21H
        
        ; if \n\r, stop taking input
        CMP AL, CR    
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP
        
        ; fast char to digit
        ; also clears AH
        AND AX, 000FH
        
        ; save AX 
        MOV CX, AX
        
        ; BX = BX * 10 + AX
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        JMP INPUT_LOOP
        
        END_INPUT_LOOP:
        MOV N, BX
        
        ; printing CR and LF
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H

        ;end of input
        MOV AH, 9

        ;IF CX >= 80
        CMP N, 80
        JNGE ELIF1
        ;THEN
        LEA DX, APLUS
        JMP END_IF

        ELIF1:
        CMP N, 75
        JNGE ELIF2
        LEA DX, A
        JMP END_IF

        ELIF2:
        CMP N, 70
        JNGE ELIF3
        LEA DX, AMINUS
        JMP END_IF

        ELIF3:
        CMP N, 65
        JNGE ELIF4
        LEA DX, BPLUS
        JMP END_IF

        ELIF4:
        CMP N, 60
        JNGE ELIF5
        LEA DX, B
        JMP END_IF

        ELIF5:
        CMP N, 55
        JNGE ELIF6
        LEA DX, BMINUS
        JMP END_IF

        ELIF6:
        CMP N, 50
        JNGE ELSE
        LEA DX, C
        JMP END_IF

        ELSE:
        LEA DX, F

        END_IF:
        INT 21H

        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP        
END MAIN