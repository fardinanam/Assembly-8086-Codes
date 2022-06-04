.MODEL SMALL
.STACK 100H
.DATA
    CR EQU 0DH
    LF EQU 0AH
    CRLF DB CR, LF, '$' ;To print newline
    INPUT_MSG DB 'Number of elements in the array: $'
    ARRAY_INPUT_MSG DB 'Array elements:', CR, LF, '$'
    SORTED_ARRAY_MSG DB 'Sorted array: $'
    FOUND_MSG DB 'Found at index $'
    NOTFOUND_MSG DB 'Not found$'
    SEARCH_INPUT_MSG DB 'Enter a number to search from the array: $'

    FLAG DB 0
    I DW ?              ;Used for indexing in insertion sort and binary search
    J DW ?              ;Used for indexing in insertion sort and binary search
    KEY DW ?            ;To store key in insertion sort
    N DW ?              ;Stores the number of inputs
    X DW ?              ;Stores search input
    ARR DW 100 DUP(?)   ;The array that we will sort
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

        ;Sort the array and print it
        CALL INSERTION_SORT
        CALL PRINT_NEWLINE
        MOV AH, 9
        LEA DX, SORTED_ARRAY_MSG
        INT 21H
        CALL PRINT_ARRAY  
        CALL PRINT_NEWLINE

        SEARCH_LOOP:
            MOV AH, 9
            LEA DX, SEARCH_INPUT_MSG
            INT 21H
            ;take input to search in the array
            CALL INPUT_INTEGER
            MOV X, DX
            CALL PRINT_NEWLINE
            CALL BINARY_SEARCH
            
            MOV AH, 9           ;Prepare to print message
            ;if (BX <= -1) then the element has not found in the array
            CMP BX, -1
            JNE FOUND_X        ;else, the element has found in the array

            LEA DX, NOTFOUND_MSG
            INT 21H
            CALL PRINT_NEWLINE
            JMP SEARCH_LOOP

            FOUND_X:
            LEA DX, FOUND_MSG
            INT 21H
            CALL PRINT_INTEGER
            CALL PRINT_NEWLINE
            JMP SEARCH_LOOP

        END_SEARCH_LOOP:

        CALL PRINT_NEWLINE
        JMP START
        END:
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

    ;Function that sorts the array ARR
    ;changes the registers BX, CX and the variables I and J
    INSERTION_SORT PROC
        ;for I = 1
        MOV I, 1 ;Initialize I to 1
        FOR:
            ;IF (I >= N) then break the loop
            MOV CX, N
            CMP I, CX
            JGE END_FOR
            ;KEY = ARR[I]
            MOV BX, I
            SHL BX, 1           ;Offset ARR index by multiplying 2 with I
            MOV CX, ARR[BX]     ;CX is used as a temporary variable
            MOV KEY, CX
            ;J = I - 1
            MOV CX, I
            DEC CX
            MOV J, CX           ;CX is used as a temporary variable

            WHILE:
                ;if(J < 0) then break the loop
                CMP J, 0
                JL END_WHILE
                ;or if(ARR[J] <= KEY) then break the loop
                MOV BX, J
                SHL BX, 1       ;Offset ARR index by multiplying 2 with I
                MOV CX, ARR[BX] ;CX is used as a temporary variable
                CMP CX, KEY
                JLE END_WHILE
                ;else continue in the loop
                ;ARR[J + 1] = ARR[J]
                MOV BX, J
                SHL BX, 1
                MOV CX, ARR[BX]
                ADD BX, 2
                MOV ARR[BX], CX
                ;J = J - 1
                DEC J
                JMP WHILE
            END_WHILE:
            ;ARR[J + 1] = KEY
            MOV BX, J
            INC BX
            SHL BX, 1
            MOV CX, KEY
            MOV ARR[BX], CX     ;CX is used as a temporary variable
            
            INC I               ;I++
            JMP FOR
        END_FOR:
        RET
    INSERTION_SORT ENDP

    PRINT_INTEGER PROC
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

    ;Checks if the value stored in X is in the ARR
    ;If found, saves the index of the element in BX
    ;else saves -1 in BX
    BINARY_SEARCH PROC
        MOV BX, -1
        ;Initializing I and J to 0 and N - 1
        MOV I, 0
        MOV CX, N
        DEC CX
        MOV J, CX               ;CX is used as a temporary variable

        SEARCH_WHILE:
            ;if(I > J) break the loop
            MOV CX, I
            CMP CX, J
            JG END_SEARCH_WHILE
            ;else continue in the loop
            ;CX(MID) = (I + J) / 2 
            MOV CX, I
            ADD CX, J
            SHR CX, 1
            ;Save ARR[MID] in SI and compare with the key
            MOV SI, CX
            SHL SI, 1
            MOV SI, ARR[SI]
            ;compare
            CMP X, SI
            JE FOUND            ;if(KEY == ARR(MID)) found
            JG GREATER          ;else if(KEY > ARR(MID)) then it is greater else, smaller
            SMALLER:
                ;if KEY < ARR(MID) then J = MID - 1
                DEC CX
                MOV J, CX       
                JMP SEARCH_WHILE
            GREATER:
                ;if KEY > ARR(MID) then I = MID + 1
                INC CX
                MOV I, CX
                JMP SEARCH_WHILE
            FOUND:
                ;if KEY == ARR(MID) then save the index in AX and return
                MOV BX, CX   
                INC BX          ;Assuming array indexing to start from 1
        END_SEARCH_WHILE:
        RET
    BINARY_SEARCH ENDP
END MAIN