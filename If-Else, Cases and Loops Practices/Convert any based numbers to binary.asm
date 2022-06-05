.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    BASE DW ?  
    I DW ?
    FLAG DB ?
    NEWLINE DB CR, LF, '$'
    BASE_MSG DB 'Input the base: $'
    INPUT_MSG DB 'Input the number: $'
    BINARY_MSG DB 'Binary value is: $' 
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        MOV AH, 9
        LEA DX, BASE_MSG
        INT 21H
 
        MOV BASE, 10
        CALL INPUT_INTEGER
        
        MOV BASE, DX
        CALL PRINT_NEWLINE
        
        LEA DX, INPUT_MSG
        INT 21H
        
        CALL INPUT_INTEGER
        MOV BX, DX      ;Saving input number
        CALL PRINT_NEWLINE
        
        MOV AH, 9
        LEA DX, BINARY_MSG
        INT 21H
        
        MOV AX, BX      ;TransferRing the input to AX
        CALL DECIMAL_BINARY
        
        END:
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP 
    
    PRINT_NEWLINE PROC
        LEA DX, NEWLINE ;Print New line
        MOV AH, 9
        INT 21H
        RET
    PRINT_NEWLINE ENDP    
    
    DECIMAL_BINARY PROC
        MOV BX, 2
        MOV CX, 0
        
        LOOP_WHILE:
        XOR DX, DX 
        DIV BX          ;Divide AX by BX
                
        PUSH DX         ;Push DX(remainder) into the stack
        INC CX

        CMP AX, 0       ;If AX <= 0, break, else continue
        JG LOOP_WHILE        
        END_WHILE: 
        
        CALL PRINT_NEWLINE
        
        TOP:
        POP DX
        ADD DL, '0'     ;1 or 0 will always be in DL
        
        MOV AH, 2
        INT 21H        
                
        LOOP TOP
        RET
    DECIMAL_BINARY ENDP
    
    ;Function that takes an integer of base BASE as an input
    ;and saves it in DX after converting it to decimal.
    ;Changes the value of registers AX, BX, DX
    INPUT_INTEGER PROC   
        XOR DX, DX  ;Initialize DX to 0
        MOV I, 0    ;Calculates number of digits
        INPUT_LOOP:
            ;Take character input
            MOV AH, 1
            INT 21H
            ;If AL == CR || AL == LF then jump to end of loop
            CMP AL, CR
            JE END_INPUT_LOOP
            CMP AL, LF
            JE END_INPUT_LOOP
            ;elif(AL == '-') then FLAG = 1
            CMP AL, '-'
            JNE DIGIT_INPUT     ;else the input is a digit
            ;else if I > 0 and AL == '-' then end the program
            CMP I, 0
            JNE END
            MOV FLAG, 1
            INC I
            JMP INPUT_LOOP
            ;Fast convert character to digit, also clears AH
            DIGIT_INPUT:
            AND AX, 000FH
            MOV BX, AX          ;Save AX in BX
            ;DX = DX * 10 + BX
            MOV AX, BASE          ;AX = BASE
            MUL DX              ;AX = AX * CX //// THOUGH MUL CHANGES DX, IT DOESN'T AFFECT OUT CALCULATIONS
            ADD AX, BX          ;AX = AX + BX
            MOV DX, AX          ;Stores the final value
            INC I
            JMP INPUT_LOOP            
        END_INPUT_LOOP:
        CMP FLAG, 1
        JNE END_INPUT
        NEG DX                  ;else make DX negative
        MOV FLAG, 0             ;make flag 0 again
        END_INPUT:
        RET
    INPUT_INTEGER ENDP
END MAIN