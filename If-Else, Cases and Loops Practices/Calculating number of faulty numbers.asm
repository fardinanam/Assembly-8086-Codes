.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH  
    I DW ?
    FLAG DB 0
    N DW ?
    COUNT DW 0
    SUM DW ?
    NEWLINE DB CR, LF, '$' 
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        CALL INPUT_INTEGER
        MOV N, DX           ;Take input and store in N

        CALL PRINT_NEWLINE

        MOV AX, N
        MOV COUNT, 0
        
        COUNT_FAULTY_WHILE:
            CALL IS_FAULTY
            CMP BX, 1       ;If it is not faulty, do nothing
            JNE NOT_FAULTY
            ;else, increment count
            INC COUNT
            
            NOT_FAULTY:
            DEC AX
            CMP AX, 1
            JG COUNT_FAULTY_WHILE
        END_COUNT_FAULTY_WHILE:

        MOV BX, COUNT
        CALL PRINT_INTEGER
        
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

    ;Checks if the number stored in AX is faulty or not
    ;Saves 1 or 0 in BX
    IS_FAULTY PROC
        MOV SUM, 0
        MOV BX, AX
        DEC BX
        LOOP_IS_FAULTY:
            PUSH AX

            XOR DX, DX  ;DX = 0
            DIV BX      ;Divide AX by BX
            CMP DX, 0   ;If DX is not equal to 0, then the number is not divisible by BX
            JNE NOT_DIVISIBLE
            ;else, the number is divisible by BX
            ADD SUM, BX ;Add BX to SUM

            NOT_DIVISIBLE:
            POP AX

            DEC BX
            CMP BX, 1
            JG LOOP_IS_FAULTY
        END_LOOP_IS_FAULTY:
        ;if SUM is greater than N, then the number is faulty
        CMP SUM, AX
        JG IS_FAULTY_TRUE
        ;else, the number is not faulty
        MOV BX, 0
        RET 
        
        IS_FAULTY_TRUE:
        MOV BX, 1
        RET
    IS_FAULTY ENDP
    
    ;Function that takes an integer as an input
    ;and saves it in DX
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
            MOV AX, 10          ;AX = 10
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

    PRINT_INTEGER PROC
        ;if(BX >= 0) then the number is positive
        CMP BX, 0
        JGE POSITIVE        
        ;else, the number is negative
        MOV AH, 2           
        MOV DL, '-'         ;Print a '-' sign
        INT 21H
        NEG BX              ;make BX positive

        POSITIVE:
        MOV AX, BX
        MOV I, 0        ;Initialize character count
        PUSH_WHILE:
            XOR DX, DX  ;clear DX
            MOV BX, 10  ;BX has the divisor //// AX has the dividend
            DIV BX
            ;quotient is in AX and remainder is in DX
            PUSH DX     ;Division by 10 will have a remainder less than 8 bits
            INC I       ;I++
            ;if(AX == 0) then break the loop
            CMP AX, 0
            JE END_PUSH_WHILE
            ;else continue
            JMP PUSH_WHILE
        END_PUSH_WHILE:
        MOV AH, 2
        POP_WHILE:
            POP DX      ;Division by 10 will have a remainder less than 8 bits
            ADD DL, '0'
            INT 21H     ;So DL will have the desired character

            DEC I       ;I--
            ;if(I <= 0) then end loop
            CMP I, 0
            JLE END_POP_WHILE
            ;else continue
            JMP POP_WHILE
        END_POP_WHILE:
        RET
    PRINT_INTEGER ENDP
END MAIN