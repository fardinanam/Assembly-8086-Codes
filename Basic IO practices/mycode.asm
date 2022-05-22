.MODEL SMALL
.STACK 100H
.DATA                    
    ; WHERE ALL THE VARIABLES WILL BE DECLARED
    CR EQU 0DH  ;LIKE #DEFINE IN C
    LF EQU 0AH
    
    X DB ?
.CODE
    ; CODE SEGMENT
    ; FUNCTIONS AND MAIN PROC WILL BE HERE
                                                                     
    MAIN PROC ; INT MAIN ()
        ; DATA SEGMENT INITIALIZATOIN
        MOV AX, @DATA
        MOV DS, AX
        
        ; STATEMENTS WILL BE HERE
        MOV AH, 1 ; INPUT KEY FUNCTION
        INT 21H   ; EXECUTE THE FUNCTION
        MOV X, AH
        
        MOV AH, 2 ; DISPLAY CHARACTER FUNCTION
        MOV DL, '?' ; THE CHARACTER IS ?
        INT 21H ; EXECUTE THE FUNCTION
        
        ; RETURN 0 
        MOV AH, 4CH
        INT 21H
    MAIN ENDP 
    
    ; other procedures go here
                    
END MAIN ; EXIT (0)       