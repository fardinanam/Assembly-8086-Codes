.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH  
    I DW ?
    FLAG DB 0  
    N DW ? 

    J DW ?
    MAX DW ?
          
    ARR DW 100 DUP(?)   ;The array that we will sort
    NEWLINE DB CR, LF, '$'
    INPUT_MSG DB 'Number of elements in the array: $'
    ARRAY_INPUT_MSG DB 'Array elements:', CR, LF, '$'
    SORTED_ARRAY_MSG DB 'Sorted array: $'
    
.CODE
    MAIN PROC  
        ;Initialize Data Segment
        MOV AX, @DATA
        MOV DS, AX
        
        START:
        ;Print input message
        MOV AH, 9
        LEA DX, INPUT_MSG
        INT 21H
        ;Input N
        CALL INPUT_INTEGER
        ;if(N < 0) then end the program
        CMP DX, 0
        JLE END                      
        ;else continue
        MOV N, DX
        ;Print newline
        CALL PRINT_NEWLINE          ;Changes DX and prints newline
        ;Print message
        MOV AH, 9
        LEA DX, ARRAY_INPUT_MSG
        INT 21H
        ;Input N integers
        MOV CX, N
        MOV SI, 0                   ;Point SI to the address of ARR 
        TOP:
            CALL INPUT_INTEGER      ;Saves the input in DX
            MOV WORD ARR[SI], DX    ;Store the input in the array
            CALL PRINT_NEWLINE      ;Changes DX and prints newline
            ADD SI, 2               ;Increase the pointer to array by 2 bytes to point to the next element of the array
        LOOP TOP
        
        CALL SELECTION_SORT         ;Sorts the array using selection sort
        
        MOV AH, 9
        LEA DX, SORTED_ARRAY_MSG
        INT 21H
        CALL PRINT_ARRAY            ;Prints the sorted array
        
        END:
        ;RETURN 0
        MOV AH, 4CH
        INT 21H
    MAIN ENDP 
    
    PRINT_NEWLINE PROC
        LEA DX, NEWLINE         ;Print New line
        MOV AH, 9
        INT 21H
        RET
    PRINT_NEWLINE ENDP 
    
    SELECTION_SORT PROC
        MOV I, 0                ;Initialize I to 0
        LOOP_FOR:
            ;for(i = 0; i < N; i++)
            MOV CX, I       
            MOV MAX, CX         ;Initialize MAX to I
            
            INC CX
            MOV J, CX           ;Initialize J to I + 1
            
            LOOP_J:
                ;for(j = i + 1; j < N; j++)
                MOV CX, N   
                CMP J, CX       ;Compare J with N
                JGE END_LOOP_J  ;If J is greater than or equal to N, then end the loop 
            
                MOV BX, J       
                SHL BX, 1
                MOV BX, ARR[BX] ;Get the value of the element at index J
                
                MOV SI, MAX
                SHL SI, 1
                MOV SI, ARR[SI] ;Get the value of the element at index MAX
                
                ;if(ARR[j] > ARR[max]) then MAX = J
                CMP BX, SI
                JNG NOT_GREATER ;else do nothing
                MOV CX, J
                MOV MAX, CX
                
                NOT_GREATER:
                
                INC J           ;Increment J
                JMP LOOP_J      ;Go to the next iteration of the loop
            END_LOOP_J:
            
            MOV BX, MAX
            SHL BX, 1
            MOV AX, ARR[BX]     ;Get the value of the element at index MAX
            
            MOV SI, I
            SHL SI, 1
            MOV SI, ARR[SI]     ;Get the value of the element at index I
            
            ;Swap the elements at index I and index MAX
            MOV BX, MAX
            SHL BX, 1
            MOV ARR[BX], SI     
            
            MOV BX, I
            SHL BX, 1
            MOV ARR[BX], AX
            ;Print the immediately sorted array
            CALL PRINT_ARRAY
            CALL PRINT_NEWLINE

            INC I               ;Increment I
            ;if(I < N) then continue
            MOV CX, N
            DEC CX 
            CMP I, CX
            JL LOOP_FOR              
        END_LOOP_FOR: 
        RET
    SELECTION_SORT ENDP    
    
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
            MUL DX              ;AX = AX * DX //// THOUGH MUL CHANGES DX, IT DOESN'T AFFECT OUT CALCULATIONS
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

    ;Prints the number stored in BX
    PRINT_INTEGER PROC
        ;Store already used value of I in the stack
        MOV DX, I
        PUSH DX

        ;if(BX < -1) then the number is positive
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
        ;Restore I to the value it had before the function was called
        POP DX
        MOV I, DX
        RET
    PRINT_INTEGER ENDP
    
    PRINT_ARRAY PROC
        LEA SI, ARR
        MOV CX, N
        
        TOP_PRINT_ARRAY:
            MOV BX, [SI]        
            CALL PRINT_INTEGER
            MOV DL, ','     ;print a comma
            INT 21H

            ADD SI, 2       ;Point to next element of the array
        LOOP TOP_PRINT_ARRAY
        RET
    PRINT_ARRAY ENDP
END MAIN