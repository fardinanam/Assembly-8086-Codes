.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    CRLF DB CR, LF, '$' ;To print newline
    INPUT_MSG DB 'Number of elements in the array: $'
    ARRAY_INPUT_MSG DB 'Array elements:', CR, LF, '$'

    N DW ? ;Stores the number of inputs
    ARR DW 100 DUP(?) ;The array that we will sort
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        ;Print input message
        MOV AH, 9
        LEA DX, INPUT_MSG
        INT 21H
        ;Input N
        CALL INPUT_INTEGER
        MOV N, DX
        ;Print newline
        CALL PRINT_NEWLINE ;Changes DX and prints newline
        ;Print message
        MOV AH, 9
        LEA DX, ARRAY_INPUT_MSG
        INT 21H
        ;Input N integers
        MOV CX, N
        MOV SI, 0 ;Point SI to the address of ARR 
        TOP:
            CALL INPUT_INTEGER ;Saves the input in DX
            MOV WORD ARR[SI], DX ;Store the input in the array
            CALL PRINT_NEWLINE ;Changes DX and prints newline
            ADD SI, 2 ;Increase the pointer to array by 2 bytes to point to the next element of the array
        LOOP TOP
        ;return 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP

    ;Function to print newline
    ;Changes the value of register DX 
    PRINT_NEWLINE PROC
        MOV AH, 9
        LEA DX, CRLF
        INT 21H
        RET
    PRINT_NEWLINE ENDP

    ;Function that takes an integer as an input
    ;and saves it in DX
    ;Changes the value of registers AX, BX, DX 
    INPUT_INTEGER PROC   
        XOR DX, DX ;Initialize DX to 0
        INPUT_LOOP:
            ;Take character input
            MOV AH, 1
            INT 21H
            ;If AL == CR || AL == LF then jump to end of loop
            CMP AL, CR
            JE END_INPUT_LOOP
            CMP AL, LF
            JE END_INPUT_LOOP
            ;else keep taking input
            ;Fast convert character to digit, also clears AH
            AND AX, 000FH
            MOV BX, AX ;Save AX in BX
            ;DX = DX * 10 + BX
            MOV AX, 10 ;AX = 10
            MUL DX ;AX = AX * CX //// THOUGH MUL CHANGES DX, IT DOESN'T AFFECT OUT CALCULATIONS
            ADD AX, BX ;AX = AX + BX
            MOV DX, AX ;Stores the final value
            JMP INPUT_LOOP            
        END_INPUT_LOOP:
        RET
    INPUT_INTEGER ENDP
END MAIN