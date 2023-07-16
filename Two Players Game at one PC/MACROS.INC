;============================================================
; ========================COMMAN MACORS======================
;============================================================
;THIS MACRO SETS THE CURSOR LOCATION TO ROW,COLUMN
    SET_CURSOR MACRO ROW,COLUMN
        MOV AH,02
        MOV BH,00
        MOV DH,ROW
        MOV DL,COLUMN 
        INT 10H
        
    ENDM
    ;============================================================

    GET_CURSOR  MACRO PAGE 
        MOV BH,PAGE
        MOV AH,3
        INT 10H
        MOV CURSOR_COL,DL
        MOV CURSOR_ROW,DH

    ENDM 
    ;============================================================


    ;THIS MACRO CLEARS THE SCREEN
    CLEAR_SCREEN MACRO 
        MOV AX,0600H
        MOV BH,07
        MOV CX,0
        MOV DX,184FH
        INT 10H
        
    ENDM
    ;============================================================

    ;THIS MACRO PRINT MESSAGE ON SPECIFIC LOCATION
    ;IF LOCATION = 0 DON'T MOVE CURSOR IF EQUAL 1 MOV IT TO ROW AND COLUMN
    DISPLAY_MESSAGE MACRO MESS,LOCATION,ROW,COLUMN 
        LOCAL SAMELOCATION
        MOV AX,LOCATION
        CMP AX,0
        JE SAMELOCATION
        SET_CURSOR ROW,COLUMN

        SAMELOCATION:
            MOV AH,9
            MOV DX,OFFSET MESS
            INT 21H    
    ENDM
    ;============================================================

    READ_MESSAGE MACRO BUFFER,LOCATION,ROW,COLUMN 
        LOCAL SAMELOCATION
        MOV AX,LOCATION
        CMP AX,0
        JE SAMELOCATION
        SET_CURSOR ROW,COLUMN

        SAMELOCATION:
            MOV AH,0AH
            MOV DX,OFFSET BUFFER
            INT 21H 

    ENDM
    ;============================================================

    COMPARE_STRINGS MACRO STR1,STR2,NUM_OF_BYTES
        LEA DI,STR1
        LEA SI,STR2
        MOV CX,NUM_OF_BYTES
        REP CMPSB    
    ENDM
    ;============================================================

    SEARCH_ON_STRING MACRO STR_TO_SHEARC,CHAR_NEED_TO_SEARCH,RANG_TO_SEARCH
    ; ZF = 1 IF CHAR IS FOUND
        LEA DI,STR_TO_SHEARC
        MOV AL,CHAR_NEED_TO_SEARCH
        MOV CX,RANG_TO_SEARCH
        REPNE SCASB

    ENDM
    ;============================================================

    MOVE_STRING MACRO STR_DEST,STR_SOURCE,RANG_TO_MOVE
    ; ZF = 1 IF CHAR IS FOUND
        LEA DI,STR_DEST
        LEA SI,STR_SOURCE
        MOV CX,RANG_TO_MOVE
        REP MOVSB

    ENDM
    ;============================================================
    STOR_WORD MACRO STR_TO_STOR_IN,STR_TO_STOR_FROM,RANG_TO_SEARCH
    ; ZF = 1 IF CHAR IS FOUND
        LEA DI,STR_TO_STOR_IN
        LEA SI,STR_TO_STOR_FROM
        STOSW
    ENDM
    ;============================================================

    SET_VIDEO_MODE MACRO MODE
    ; TEXT 80X25 ==> AL = 3
    ; GRAPHICS 320X200 ==> AL = 4
    ; GRAPHICS 640X200 ==> AL = 6

        MOV AH,00
        MOV AL,MODE
        INT 10H
        
    ENDM
    ;============================================================

    DRAW_CHAR MACRO character_to_display,page_number,attribute,number_of_times 
        MOV AL,character_to_display
        MOV BH,page_number
        MOV BL,attribute
        MOV CX,number_of_times
        MOV AH,9
        INT 10H

    ENDM
    ;============================================================

    DRAW_PIXEL MACRO COLOR,ROW,COL
        MOV AL,COLOR
        MOV CX,COL
        MOV DX,ROW
        MOV AH,0CH
        INT 10H  
        
    ENDM

    ;============================================================
    ;============================================================    

    ASCII_HEX MACRO ASCII_VALUE,SIZE_VALUE,GOTO

        MOV SI,OFFSET ASCII_VALUE
        MOV AX,0
        MOV DX,0
        MOV CX,0
        MOV CL,12
        MOV Bl,SIZE_VALUE

        AGAIN:
            MOV AX,0
            MOV AL,[SI]
            CMP AL,'a'
            JNS SUB_57
            SUB AL,30H
            JMP NEXT_V

        SUB_57:
            CMP AL,'f'
            JS GO_OUT
            SUB AL,57H
            JMP NEXT_V

        NEXT_V:
            SHL AX,CL
            OR DX,AX
            SUB CL,4
            OR DL,AL
            INC SI
            DEC Bl
            JNZ AGAIN

        MOV [GOTO],DX 
        GO_OUT:

    ENDM

;============================================================
;=========================COMMAND MACORS=====================
;============================================================



GET_DEST_ADDRESS_0 MACRO PLAYER_RAM

    LEA DI,PLAYER_RAM
    MOV AX,0
    MOV AL,DEST_CODE
    ADD DI,AX

    MOV AX,DI
    MOV DEST_ADDRESS,DI


ENDM

GET_DEST_ADDRESS_1 MACRO PLAYER_RAM
        
    LEA DI,PLAYER_RAM
    MOV AX,0
    MOV AL,DEST_CODE
    ADD DI,AX

    MOV BX,[DI]
    MOV DI,PLAYER_RAM
    ADD DI,16
    ADD DI,BX
    MOV DEST_ADDRESS,DI

ENDM 

GET_SOURCE_ADDRESS_0 MACRO PLAYER_RAM

    LEA DI,PLAYER_RAM
    MOV AX,0
    MOV AL,DEST_CODE
    ADD DI,AX
    MOV AX,DI
    MOV SOURCE_ADDRESS,DI

ENDM 


GET_SOURCE_ADDRESS_1 MACRO PLAYER_RAM

    LEA DI,PLAYER_RAM
    MOV AX,0
    MOV AL,DEST_CODE
    ADD DI,AX

    MOV AX,DI
    MOV SOURCE_ADDRESS,DI

ENDM 

GET_SOURCE_ADDRESS_2 MACRO PLAYER_RAM

    LEA DI,PLAYER_RAM
    MOV AX,0
    MOV AL,DEST_CODE
    ADD DI,AX

    MOV BX,[DI]
    MOV DI,PLAYER_RAM
    ADD DI,16
    ADD DI,BX
    MOV SOURCE_ADDRESS,DI

ENDM 

GET_SOURCE_ADDRESS_3 MACRO 

    MOV SI,SOURCE_HEX_VALUE


ENDM 

GET_CARRY_ADDRESS MACRO PLAYER_RAM

    LEA DI,PLAYER_RAM
    ADD DI,32
    MOV CARRY_ADDRESS,DI

ENDM






    ;============================================================  







