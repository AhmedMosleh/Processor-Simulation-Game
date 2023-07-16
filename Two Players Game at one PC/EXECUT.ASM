;INCLUDE MACROS1.INC
;INCLUDE MACROS.INC

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
    ;============================================================  


    HEX_ASCII MACRO _2BYTE_REG

        LEA DI,PRINT_REG
        ADD DI,3
        
        LEA SI,_2BYTE_REG
        MOV AX,[SI]
        MOV REG_BUFFER,AX
        MOV CX,4
        CALL HEX_ASCII_PROC

    ENDM


    DRAW_IMG    MACRO   IMG_DATA, _IMG_HIGHT, _IMG_WIDTH, IMG_VERTICAL_OFFSET,IMG_HORIZONTAL_OFFSET

        MOV BX,IMG_VERTICAL_OFFSET
        MOV VERTICAL_OFFSET,BX

        MOV BX,IMG_HORIZONTAL_OFFSET
        MOV HORIZONTAL_OFFSET,BX

        MOV BX,_IMG_WIDTH
        MOV IMG_WIDTH,BX

        MOV BX,_IMG_HIGHT
        MOV IMG_HIGHT,BX

        LEA BX,IMG_DATA

        CALL DRAW

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
        MOV AL,SOURCE_CODE
        ADD DI,AX
        MOV AX,DI
        MOV SOURCE_ADDRESS,DI

    ENDM 


    GET_SOURCE_ADDRESS_1 MACRO PLAYER_RAM

        LEA DI,PLAYER_RAM
        MOV AX,0
        MOV AL,SOURCE_CODE
        ADD DI,AX

        MOV AX,DI
        MOV SOURCE_ADDRESS,DI

    ENDM 

    GET_SOURCE_ADDRESS_2 MACRO PLAYER_RAM

        LEA DI,PLAYER_RAM
        MOV AX,0
        MOV AL,SOURCE_CODE
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

    UDATE_REG MACRO DEST_ADD

        MOV SI,DEST_ADD
        MOV AX,[SI]
        CALL UPDATE_REG_PROC

    ENDM






;============================================================
; ========================MAIN CODE==========================
;============================================================
.MODEL COMPACT
.STACK 4096
.386

;================================
;============DATA================
;================================
.DATA

    ;============Common data================

        MESS1 DB "Please enter command",10,13,"$"
        USEPOWERUPS DB "TO USE POWER UPS WRITE 1, TO EXECUTE COMMAND WRITE 2",'$'
        SELECT_POWER_UP DB '1- EXECUTING A COMMAND ON YOUR OWN PROCESSOR [-5 points]',10,13
                        DB '2- Executing a command on your processor and your opponent processor [-3 points]',10,13
                        DB '3- Changing the forbidden character (USED ONCE) [-8 points]',10,13
                        DB '4- Clearing all registers (USED ONCE) [-30 points]','$'
        
        POWER_UPS_BUFFER DB ?
        COMMAND_BUFFER LABEL BYTE
        COMMAND_BUFFER_SIZE DB 20
        COMMAND_BUFFER_ACTUAL_SIZE DB ?
        COMMAND_BUFFER_INSTRUCTION DB 20 DUP("$")

        PLAYER_ROUND DB 1

        ALI_SCORE DB ?
        AHMED_SCORE DB ?

        ALI_FORBIDDEN DB ?
        AHMED_FORBIDDEN DB ?

        DEST DB 7 DUP("$")
        DEST_SIZE DB ?
        SOURCE DB 7 DUP("$")
        SOURCE_SIZE DB ?
        GO DW ?
        SOURCE_HEX_VALUE DW ?

        INSTRUCTION_CODE DB ?
        DEST_CODE DB ?
        SOURCE_CODE DB ?

        ;FLAG        
        DEST_BYTES DB 0
        SOURCE_BYTES DB 0

        ADDRESSING_MODE_DEST_TYPE DB ?
        ADDRESSING_MODE_SOURCE_TYPE DB ?

        DEST_ADDRESS   DW ?
        SOURCE_ADDRESS DW ?
        CARRY_ADDRESS  DW ?


    ;============PRINT REG================

    ASCII_TABLE DB '0','1','2','3','4','5','6','7','8','9'
                DB 'A','B','C','D','E','F'
    PRINT_REG DB 6 DUP('$')
    REG_BUFFER DW ? ; VAR. USED IN PRINTING
    PRINT_REG_BUFFER DB 6 DUP('$') ; VAR. FOR CRAZY DOSBOX
    
    ;============COMMANDS================

        IS_ADD  DB "add ",'$' 
        IS_ADC  DB "adc "
        IS_SUB  DB 'sub ','$'
        IS_SBB  DB 'sbb '
        IS_MOV  DB 'mov ','$'
        IS_XOR  DB 'xor '
        IS_AND  DB 'and '
        IS_OR   DB 'or  '
        IS_NOP  DB 'nop '
        IS_SHR  DB 'shr '
        IS_SHL  DB 'shl '
        IS_SAR  DB 'sar '
        IS_CLC  DB 'clc '
        IS_ROR  DB 'ror ' 
        IS_ROL  DB 'rol '
        IS_RCL  DB 'rcl '
        IS_RCR  DB 'rcr '
        IS_INC  DB 'inc '
        IS_DEC  DB 'dec '


    ;============REGISTERS===========
        IS_AX   DB 'ax'
        IS_AL   DB 'al'
        IS_AH   DB 'ah'
        IS_BX   DB 'bx'
        IS_BL   DB 'bl'
        IS_BH   DB 'bh'
        IS_CX   DB 'cx'
        IS_CL   DB 'cl'
        IS_CH   DB 'ch'
        IS_DX   DB 'dx'
        IS_DL   DB 'dl'
        IS_DH   DB 'dh'
        IS_SI   DB 'si'
        IS_DI   DB 'di'
        IS_SP   DB 'sp'
        IS_BP   DB 'bp'

    ;============REGISTER INDIRECT===========
        _IS_NOT_REG DB '['
        _IS_BX_ DB '[bx]'
        _IS_SI_ DB '[si]'
        _IS_DI_ DB '[di]'


    ;============IMMEDIATE===========

        _IS_0_ DB '[0]'
        _IS_1_ DB '[1]'
        _IS_2_ DB '[2]'
        _IS_3_ DB '[3]'
        _IS_4_ DB '[4]'
        _IS_5_ DB '[5]'   
        _IS_6_ DB '[6]'
        _IS_7_ DB '[7]'
        _IS_8_ DB '[8]'
        _IS_9_ DB '[9]'
        _IS_A_ DB '[a]'
        _IS_B_ DB '[b]'
        _IS_C_ DB '[c]'
        _IS_D_ DB '[d]'
        _IS_E_ DB '[e]'
        _IS_F_ DB '[f]'



    ;============BASED RELATIVE===========
        ;; NEED TO COMPLETE ANTHER COMPINATIONS
        PLUS DB '+'
        _BX_DISP DB '[bx]+'
        _BP_DISP DB '[bp]+'

    ;============INDEXED RELATIVE===========
        ;; NEED TO COMPLETE ANTHER COMPINATIONS
        _SI_DISP DB '[si]+'
        _DI_DISP DB '[di]+'
        DISP DB ?

    ;============INDEXED RELATIVE===========
        ;; NEED TO COMPLETE ANTHER COMPINATIONS
        _BX_SI_ DB '[bx][si]'
        _BX_DI_ DB '[bx][di]'
        _BP_SI_ DB '[bp][si]'
        _BP_DI_ DB '[bp][di]'
        IS_1_POWER_UP DB '1'

    ;============PLAYER 1 ALI'S_REGISTERS===========
        ALI_AX   LABEL WORD
        ALI_AL   DB 78H
        ALI_AH   DB 78H
        ALI_BX   LABEL WORD
        ALI_BL   DB 48H
        ALI_BH   DB 12H
        ALI_CX   LABEL WORD
        ALI_CL   DB 00H
        ALI_CH   DB 00H
        ALI_DX   LABEL WORD
        ALI_DL   DB 00H
        ALI_DH   DB 00H
        ALI_SI   DW 0000H
        ALI_DI   DW 0000H
        ALI_SP   DW 0000H
        ALI_BP   DW 0000H
       

    ;============ALI'S_MEMMORY===========
        ALI_PYTE_0 DB 00H
        ALI_PYTE_1 DB 00H
        ALI_PYTE_2 DB 00H
        ALI_PYTE_3 DB 00H
        ALI_PYTE_4 DB 00H
        ALI_PYTE_5 DB 00H
        ALI_PYTE_6 DB 00H
        ALI_PYTE_7 DB 00H
        ALI_PYTE_8 DB 00H
        ALI_PYTE_9 DB 00H
        ALI_PYTE_A DB 00H
        ALI_PYTE_B DB 00H
        ALI_PYTE_C DB 00H
        ALI_PYTE_D DB 00H
        ALI_PYTE_E DB 00H
        ALI_PYTE_F DB 00H
        ALI_CF     DB 00H

    ;============AHMED'S_REGISTERS===========
        AHMED_AX   LABEL WORD
        AHMED_AL   DB 00H
        AHMED_AH   DB 00H
        AHMED_BX   LABEL WORD
        AHMED_BL   DB 00H
        AHMED_BH   DB 00H
        AHMED_CX   LABEL WORD
        AHMED_CL   DB 00H
        AHMED_CH   DB 00H
        AHMED_DX   LABEL WORD
        AHMED_DL   DB 00H
        AHMED_DH   DB 00H
        AHMED_SI   DW 0000H
        AHMED_DI   DW 0000H
        AHMED_SP   DW 0000H
        AHMED_BP   DW 0000H
        

    ;============AHMED'S_MEMMORY===========
        AHMED_PYTE_0 DB 00H
        AHMED_PYTE_1 DB 00H
        AHMED_PYTE_2 DB 00H
        AHMED_PYTE_3 DB 00H
        AHMED_PYTE_4 DB 00H
        AHMED_PYTE_5 DB 00H
        AHMED_PYTE_6 DB 00H
        AHMED_PYTE_7 DB 00H
        AHMED_PYTE_8 DB 00H
        AHMED_PYTE_9 DB 00
        AHMED_PYTE_A DB 00H
        AHMED_PYTE_B DB 00H
        AHMED_PYTE_C DB 00H
        AHMED_PYTE_D DB 00H
        AHMED_PYTE_E DB 00H
        AHMED_PYTE_F DB 00H
        AHMED_CF     DB 00H

    


;================================================================
;==============================CODE==============================
;================================================================
.CODE 
MAIN PROC FAR
    ;DEFINE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX

    SET_VIDEO_MODE 3  

    CALL INITIALIZATION

    READ_MESSAGE COMMAND_BUFFER,1,2,0
    CALL ALI_EXE


    CALL INITIALIZATION

 

    ;STOP PROGRAMM
    MOV  AH,4CH
    INT  21H

MAIN ENDP

INITIALIZATION PROC NEAR






    DISPLAY_MESSAGE MESS1,1,0,0
    ;DISPLAY_MESSAGE MESS1,1,4,25
    
    HEX_ASCII ALI_AL
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,4,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_BX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,6,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_CX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,8,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_DX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,10,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_SI
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,12,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_DI
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,14,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_SP
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,16,4

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII ALI_BP
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,18,4




    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_AX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,4,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_BX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,6,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_CX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,8,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_DX
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,10,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_SI
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,12,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_DI
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,14,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_SP
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,16,20

    DISPLAY_MESSAGE MESS1,1,0,0 
    HEX_ASCII AHMED_BP
    MOVE_STRING PRINT_REG_BUFFER, PRINT_REG,6
    DISPLAY_MESSAGE PRINT_REG_BUFFER,1,18,20
    RET
INITIALIZATION ENDP




HEX_ASCII_PROC PROC NEAR

    MOV CX,4
    LOOP_HEX_ASCII:
        MOV AX,REG_BUFFER
        MOV BX,16

        DIV BX

        MOV REG_BUFFER,AX

        MOV AL,DL
        LEA BX,ASCII_TABLE
        XLAT

        MOV [DI],AL
        DEC DI
        DEC CX
    JNZ LOOP_HEX_ASCII
    MOV REG_BUFFER,0
    RET

HEX_ASCII_PROC ENDP

EXECUT_INSTRUCTION PROC NEAR

    ; 1-IS IT ADD?
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_ADD,4
    JE IT_ADD
    ; IS IT ADC
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_ADC,4
    JE IT_ADC
    ; 3-IS IT SUB 
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_SUB,4
    JE IT_SUB
    ; 4-IS IT SBB
    ;; NOT NEEDED
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_SBB,4
    JE IT_SBB
    ; 4-IS IT MOV
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_MOV,4
    JE IT_MOV
    ; 5-IS IT XOR
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_XOR,4
    JE IT_XOR
    ; 6-IS IT AND 
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_AND,4
    JE IT_AND
    ; 7-IS IT OR 
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_OR,4
    JE IT_OR
    ; 8-IS IT NOP
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_NOP,4
    JE IT_NOP
    ; 9-IS IT SHR
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_SHR,4
    JE IT_SHR
    ; 10-IS IT SHR
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_SHL,4
    JE IT_SHL
    ; 11-IS IT SAR
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_SAR,4
    JE IT_ADD
    ; 12-IS IT CLC
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_CLC,4
    JE IT_CLC
    ; 13-IS IT ROR
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_ROR,4
    JE IT_ROR
    ; 18-IS IT INC
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_INC,4
    JE IT_INC
    ; 19-IS IT DEC
    COMPARE_STRINGS COMMAND_BUFFER_INSTRUCTION,IS_DEC,4
    JE IT_DEC

    IT_ADD:
        CALL ADD_OP
        JMP EXIT_GET_INSTRUCTION
    IT_ADC:
        CALL ADC_OP
        JMP EXIT_GET_INSTRUCTION
    IT_SUB:
        CALL SUB_OP
        JMP EXIT_GET_INSTRUCTION
    IT_SBB:
        CALL SBB_OP
        JMP EXIT_GET_INSTRUCTION
    IT_MOV:
        CALL MOV_OP
        JMP EXIT_GET_INSTRUCTION
    IT_XOR:
        CALL XOR_OP
        JMP EXIT_GET_INSTRUCTION
    IT_AND:
        CALL AND_OP
        JMP EXIT_GET_INSTRUCTION
    IT_OR:
        CALL OR_OP
        JMP EXIT_GET_INSTRUCTION
    IT_NOP:
        CALL NOP_OP
        JMP EXIT_GET_INSTRUCTION
    IT_SHR:
        CALL SHR_OP
        JMP EXIT_GET_INSTRUCTION
    IT_SHL:
        CALL SHL_OP
        JMP EXIT_GET_INSTRUCTION
    IT_SAR:
        CALL SAR_OP
        JMP EXIT_GET_INSTRUCTION
    IT_CLC: 
        CALL CLC_OP
        JMP EXIT_GET_INSTRUCTION
    IT_ROR: 
        CALL ROR_OP
        JMP EXIT_GET_INSTRUCTION
    IT_INC: 
        CALL INC_OP
        JMP EXIT_GET_INSTRUCTION
    IT_DEC:
        CALL DEC_OP

    EXIT_GET_INSTRUCTION:
        RET

EXECUT_INSTRUCTION ENDP

FETCH_DEST PROC NEAR

    SEARCH_ON_STRING COMMAND_BUFFER_INSTRUCTION,',',12
    JNE SEARCH_2
    MOV AL,12
    SUB AL,CL
    SUB AL,5
    MOV DEST_SIZE,AL 
    JMP FETCH
    
    SEARCH_2:
    SEARCH_ON_STRING COMMAND_BUFFER_INSTRUCTION,'$',12
    MOV AL,12
    SUB AL,CL
    SUB AL,6
    MOV DEST_SIZE,AL
    JNE EXIT_FETCH
        
    FETCH:
    MOV SI,OFFSET COMMAND_BUFFER_INSTRUCTION+4
    MOV DI,OFFSET DEST
    MOV CX,0 
    MOV CL,DEST_SIZE
    REP MOVSB
    
    EXIT_FETCH: 
    RET

FETCH_DEST ENDP

FETCH_SOURCE PROC NEAR
    
    
    SEARCH_ON_STRING COMMAND_BUFFER_INSTRUCTION,',',12
    JNE EXIT_FETCH_SOURCE
    
    MOV DI,OFFSET COMMAND_BUFFER_INSTRUCTION
    MOV CX,19
    MOV AL,'$'
    REPNE SCASB
    INC CL
    MOV AL,19
    SUB AL,CL
    MOV DL,6
    ADD DL,DEST_SIZE
    SUB AL,DL
    MOV SOURCE_SIZE,AL
     
    MOV BL,0
    MOV BL,5
    ADD BL,DEST_SIZE
    MOV BYTE PTR GO,BL
    
    MOV SI,OFFSET COMMAND_BUFFER_INSTRUCTION
    ADD SI,GO 

    MOV DI,OFFSET SOURCE
    MOV CX,0 
    MOV CL,SOURCE_SIZE
    REP MOVSB
     
    EXIT_FETCH_SOURCE: 
    RET
    

FETCH_SOURCE ENDP


DECODE_DEST PROC NEAR

    IS_REG_ADDRESSING_MODE:

        SEARCH_ON_STRING DEST,'[',1
        JE IS_REG_INDIRECT

        ITS_2BYTE_DEST:

            MOV DEST_BYTES,2

            COMPARE_STRINGS DEST,IS_AX,2
            JE IT_AX

            COMPARE_STRINGS DEST,IS_BX,2
            JE IT_BX

            COMPARE_STRINGS DEST,IS_CX,2
            JE IT_CX

            COMPARE_STRINGS DEST,IS_DX,2
            JE IT_DX

            COMPARE_STRINGS DEST,IS_SI,2
            JE IT_SI

            COMPARE_STRINGS DEST,IS_DI,2
            JE IT_DI

            COMPARE_STRINGS DEST,IS_SP,2
            JE IT_SP

            COMPARE_STRINGS DEST,IS_BP,2
            JE IT_BP
            JMP ITS_NOT_2BYTE_DEST


            IT_AX:
                MOV DEST_CODE,0
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_BX:
                MOV DEST_CODE,2
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_CX:
                MOV DEST_CODE,4
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_DX:  
                MOV DEST_CODE,6
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_SI:  
                MOV DEST_CODE,8
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_DI:  
                MOV DEST_CODE,10
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_SP:  
                MOV DEST_CODE,12
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_BP:  
                MOV DEST_CODE,14
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
        
        ITS_NOT_2BYTE_DEST:

            MOV DEST_BYTES,1

            COMPARE_STRINGS DEST,IS_AL,2
            JE IT_AL

            COMPARE_STRINGS DEST,IS_AH,2
            JE IT_AH

            COMPARE_STRINGS DEST,IS_BL,2
            JE IT_BL

            COMPARE_STRINGS DEST,IS_BH,2
            JE IT_BH

            COMPARE_STRINGS DEST,IS_CL,2
            JE IT_CL

            COMPARE_STRINGS DEST,IS_CH,2
            JE IT_CH

            COMPARE_STRINGS DEST,IS_DL,2
            JE IT_DL

            COMPARE_STRINGS DEST,IS_DH,2
            JE IT_DH
            JMP EXIT_GET_DEST

            IT_AL:
                MOV DEST_CODE,0
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_AH:
                MOV DEST_CODE,1
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST

            IT_BL:
                MOV DEST_CODE,2
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_BH:
                MOV DEST_CODE,3
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_CL:
                MOV DEST_CODE,4
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_CH:  
                MOV DEST_CODE,5
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_DL:  
                MOV DEST_CODE,6
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST
            IT_DH:  
                MOV DEST_CODE,7
                MOV ADDRESSING_MODE_DEST_TYPE,0
                JMP EXIT_GET_DEST 
    
    IS_REG_INDIRECT:
        
        CMP SOURCE_SIZE,4
        JNE EXIT_GET_DEST

        COMPARE_STRINGS DEST,_IS_BX_,4
        JE IT_BX_

        COMPARE_STRINGS DEST,_IS_SI_,4
        JE IT_SI_

        COMPARE_STRINGS DEST,_IS_DI_,4
        JE IT_DI_
        JMP EXIT_GET_DEST

        IT_BX_: 
            MOV DEST_CODE,2
            MOV ADDRESSING_MODE_DEST_TYPE,1
            JMP EXIT_GET_DEST
        IT_SI_:  
            MOV DEST_CODE,8
            MOV ADDRESSING_MODE_DEST_TYPE,1
            JMP EXIT_GET_DEST
        IT_DI_:  
            MOV DEST_CODE,10
            MOV ADDRESSING_MODE_DEST_TYPE,1
            JMP EXIT_GET_DEST
    EXIT_GET_DEST:
        RET

DECODE_DEST ENDP

DECODE_SOURCE PROC NEAR


    IS_REG_ADDRESSING_MODE_SOURCE:

        SEARCH_ON_STRING DEST,'[',1
        JE IS_DIRECT_SOURCE


        ITS_2BYTE_SOURCE: 
        
            MOV ADDRESSING_MODE_SOURCE_TYPE,0

            MOV SOURCE_BYTES,2

            COMPARE_STRINGS SOURCE,IS_AX,2
            JE IT_AX_S

            COMPARE_STRINGS SOURCE,IS_BX,2
            JE IT_BX_S

            COMPARE_STRINGS SOURCE,IS_CX,2
            JE IT_CX_S

            COMPARE_STRINGS SOURCE,IS_DX,2
            JE IT_DX_S

            COMPARE_STRINGS SOURCE,IS_SI,2
            JE IT_SI_S

            COMPARE_STRINGS SOURCE,IS_DI,2
            JE IT_DI_S

            COMPARE_STRINGS SOURCE,IS_SP,2
            JE IT_SP_S

            COMPARE_STRINGS SOURCE,IS_BP,2
            JE IT_BP_S
            JMP ITS_NOT_2BYTE_SOURCE


            IT_AX_S:
                MOV SOURCE_CODE,0
                JMP EXIT_GET_SOURCE
            IT_BX_S:
                MOV SOURCE_CODE,2
                JMP EXIT_GET_SOURCE
            IT_CX_S:
                MOV SOURCE_CODE,4
                JMP EXIT_GET_SOURCE
            IT_DX_S:  
                MOV SOURCE_CODE,6
                JMP EXIT_GET_SOURCE
            IT_SI_S:  
                MOV SOURCE_CODE,8
                JMP EXIT_GET_SOURCE
            IT_DI_S:  
                MOV SOURCE_CODE,10
                JMP EXIT_GET_SOURCE
            IT_SP_S:  
                MOV SOURCE_CODE,12
                JMP EXIT_GET_SOURCE
            IT_BP_S:  
                MOV SOURCE_CODE,14
                JMP EXIT_GET_SOURCE
        
        ITS_NOT_2BYTE_SOURCE:

            MOV SOURCE_BYTES,1

            COMPARE_STRINGS SOURCE,IS_AL,2
            JE IT_AL_S

            COMPARE_STRINGS SOURCE,IS_AH,2
            JE IT_AH_S

            COMPARE_STRINGS SOURCE,IS_BL,2
            JE IT_BL_S

            COMPARE_STRINGS SOURCE,IS_BH,2
            JE IT_BH_S

            COMPARE_STRINGS SOURCE,IS_CL,2
            JE IT_CL_S

            COMPARE_STRINGS SOURCE,IS_CH,2
            JE IT_CH_S

            COMPARE_STRINGS SOURCE,IS_DL,2
            JE IT_DL_S

            COMPARE_STRINGS SOURCE,IS_DH,2
            JE IT_DH_S
            JMP ITS_NOT_1BYTE_SOURCE

            IT_AL_S:
                MOV SOURCE_CODE,0
                JMP EXIT_GET_SOURCE
            IT_AH_S:
                MOV SOURCE_CODE,1
                JMP EXIT_GET_SOURCE

            IT_BL_S:
                MOV SOURCE_CODE,2
                JMP EXIT_GET_SOURCE
            IT_BH_S:
                MOV SOURCE_CODE,3
                JMP EXIT_GET_SOURCE
            IT_CL_S:
                MOV SOURCE_CODE,4
                JMP EXIT_GET_SOURCE
            IT_CH_S:  
                MOV SOURCE_CODE,5
                JMP EXIT_GET_SOURCE
            IT_DL_S:  
                MOV SOURCE_CODE,6
                JMP EXIT_GET_SOURCE
            IT_DH_S:  
                MOV SOURCE_CODE,7
                JMP EXIT_GET_SOURCE

            ITS_NOT_1BYTE_SOURCE:

            ; MOV SOURCE_CODE,25
            ; ASCII_HEX SOURCE,SOURCE_SIZE,SOURCE_HEX_VALUE

    IS_DIRECT_SOURCE:
        
        MOV ADDRESSING_MODE_SOURCE_TYPE,1

        CMP SOURCE_SIZE,3
        JNZ IS_REG_INDIRECT_SOURCE

        COMPARE_STRINGS SOURCE,_IS_0_,3
        JE _IS_0__

        COMPARE_STRINGS SOURCE,_IS_1_,3
        JE _IS_1__

        COMPARE_STRINGS SOURCE,_IS_2_,3
        JE IT_2__

        COMPARE_STRINGS SOURCE,_IS_3_,3
        JE IT_3__

        COMPARE_STRINGS SOURCE,_IS_4_,3
        JE _IS_4__

        COMPARE_STRINGS SOURCE,_IS_5_,3
        JE IT_5__

        COMPARE_STRINGS SOURCE,_IS_6_,3
        JE IT_6__

        COMPARE_STRINGS SOURCE,_IS_7_,3
        JE _IS_7__

        COMPARE_STRINGS SOURCE,_IS_8_,3
        JE IT_8__

        COMPARE_STRINGS SOURCE,_IS_9_,3
        JE IT_9__

        COMPARE_STRINGS SOURCE,_IS_A_,3
        JE _IS_A__

        COMPARE_STRINGS SOURCE,_IS_B_,3
        JE IT_B__

        COMPARE_STRINGS SOURCE,_IS_C_,3
        JE IT_C__


        COMPARE_STRINGS SOURCE,_IS_D_,3
        JE _IS_D__

        COMPARE_STRINGS SOURCE,_IS_E_,3
        JE IT_E__

        COMPARE_STRINGS SOURCE,_IS_F_,3
        JE IT_F__
        JMP EXIT_GET_SOURCE

        _IS_0__: 
            MOV SOURCE_CODE,16
            JMP EXIT_GET_SOURCE

        _IS_1__: 
            MOV SOURCE_CODE,17
            JMP EXIT_GET_SOURCE
        IT_2__:  
            MOV SOURCE_CODE,18
            JMP EXIT_GET_SOURCE
        IT_3__:  
            MOV SOURCE_CODE,19
            JMP EXIT_GET_SOURCE
        _IS_4__: 
            MOV SOURCE_CODE,20
            JMP EXIT_GET_SOURCE
        IT_5__:  
            MOV SOURCE_CODE,21
            JMP EXIT_GET_SOURCE
        IT_6__:  
            MOV SOURCE_CODE,22
            JMP EXIT_GET_SOURCE
        _IS_7__: 
            MOV SOURCE_CODE,23
            JMP EXIT_GET_SOURCE
        IT_8__:  
            MOV SOURCE_CODE,24
            JMP EXIT_GET_SOURCE
        IT_9__:  
            MOV SOURCE_CODE,25
            JMP EXIT_GET_SOURCE
        _IS_A__: 
            MOV SOURCE_CODE,26
            JMP EXIT_GET_SOURCE
        IT_B__:  
            MOV SOURCE_CODE,27
            JMP EXIT_GET_SOURCE
        IT_C__:  
            MOV SOURCE_CODE,28
            JMP EXIT_GET_SOURCE
        _IS_D__: 
            MOV SOURCE_CODE,29
            JMP EXIT_GET_SOURCE
        IT_E__:  
            MOV SOURCE_CODE,30
            JMP EXIT_GET_SOURCE
        IT_F__:  
            MOV SOURCE_CODE,31
            JMP EXIT_GET_SOURCE

    IS_REG_INDIRECT_SOURCE:
        
        MOV ADDRESSING_MODE_SOURCE_TYPE,2

        ; CMP DEST_SIZE,4
        ; JNZ EXIT_GET_SOURCE

        COMPARE_STRINGS SOURCE,_IS_BX_,4
        JE IT_BX__S

        COMPARE_STRINGS SOURCE,_IS_SI_,4
        JE IT_SI__S

        COMPARE_STRINGS SOURCE,_IS_DI_,4
        JE IT_DI__S
        JMP IS_IMMEDIATE

        IT_BX__S: 
            MOV SOURCE_CODE,2
            JMP EXIT_GET_SOURCE
        IT_SI__S:  
            MOV SOURCE_CODE,8
            JMP EXIT_GET_SOURCE
        IT_DI__S:  
            MOV SOURCE_CODE,10
            JMP EXIT_GET_SOURCE

    IS_IMMEDIATE:  
        MOV ADDRESSING_MODE_SOURCE_TYPE,3

        MOV SOURCE_CODE,25
        ASCII_HEX SOURCE,SOURCE_SIZE,SOURCE_HEX_VALUE

    EXIT_GET_SOURCE:
        RET

DECODE_SOURCE ENDP


GET_ADDRESSING_MODE_ALI PROC NEAR
    
    CMP ADDRESSING_MODE_DEST_TYPE,0
    JNE IT_DEST_REG_INDIRECT

        GET_DEST_ADDRESS_0 ALI_AX

        CMP ADDRESSING_MODE_SOURCE_TYPE,0
        JNE IT_SOURCE_DIRECT

            GET_SOURCE_ADDRESS_0 ALI_AX
            JMP EXIT_GET_ADDRESSING_MODE

        IT_SOURCE_DIRECT:

            CMP ADDRESSING_MODE_SOURCE_TYPE,1
            JNE IT_SOURCE_INDIRECT

            GET_SOURCE_ADDRESS_1 ALI_AX
            JMP EXIT_GET_ADDRESSING_MODE

        IT_SOURCE_INDIRECT:

            CMP ADDRESSING_MODE_SOURCE_TYPE,2
            JNE IT_SOURCE_IMMEDIATE

            GET_SOURCE_ADDRESS_2 ALI_AX
            JMP EXIT_GET_ADDRESSING_MODE

        IT_SOURCE_IMMEDIATE:

            CMP ADDRESSING_MODE_SOURCE_TYPE,3
            
            GET_SOURCE_ADDRESS_3
            JMP EXIT_GET_ADDRESSING_MODE

 


        JMP EXIT_GET_ADDRESSING_MODE

    IT_DEST_REG_INDIRECT:

    CMP ADDRESSING_MODE_DEST_TYPE,1
    JNE EXIT_GET_ADDRESSING_MODE

        GET_DEST_ADDRESS_1 AHMED_AX

        CMP ADDRESSING_MODE_SOURCE_TYPE,0
        JNE IT_SOURCE_IMMEDIATE_2

            GET_SOURCE_ADDRESS_0 ALI_AX
            JMP EXIT_GET_ADDRESSING_MODE
        
        IT_SOURCE_IMMEDIATE_2:

            CMP ADDRESSING_MODE_SOURCE_TYPE,3
            JMP EXIT_GET_ADDRESSING_MODE

            GET_SOURCE_ADDRESS_3 
            JMP EXIT_GET_ADDRESSING_MODE

    EXIT_GET_ADDRESSING_MODE:
    GET_CARRY_ADDRESS ALI_AX

    RET
GET_ADDRESSING_MODE_ALI ENDP

GET_ADDRESSING_MODE_AHMED PROC NEAR
    
    CMP ADDRESSING_MODE_DEST_TYPE,0
    JNE IT_DEST_REG_INDIRECT_AHMED

        GET_DEST_ADDRESS_0 AHMED_AX

        CMP ADDRESSING_MODE_SOURCE_TYPE,0
        JNE IT_SOURCE_DIRECT_AHMED

            GET_SOURCE_ADDRESS_0 AHMED_AX
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

        IT_SOURCE_DIRECT_AHMED:

            CMP ADDRESSING_MODE_SOURCE_TYPE,1
            JNE IT_SOURCE_INDIRECT

            GET_SOURCE_ADDRESS_1 AHMED_AX
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

        IT_SOURCE_INDIRECT_AHMED:

            CMP ADDRESSING_MODE_SOURCE_TYPE,2
            JNE IT_SOURCE_IMMEDIATE

            GET_SOURCE_ADDRESS_2 AHMED_AX
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

        IT_SOURCE_IMMEDIATE_AHMED:

            CMP ADDRESSING_MODE_SOURCE_TYPE,3
            
            GET_SOURCE_ADDRESS_3
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

        JMP EXIT_GET_ADDRESSING_MODE_AHMED

    IT_DEST_REG_INDIRECT_AHMED:

    CMP ADDRESSING_MODE_DEST_TYPE,1
    JNE EXIT_GET_ADDRESSING_MODE_AHMED

        GET_DEST_ADDRESS_1 AHMED_AX

        CMP ADDRESSING_MODE_SOURCE_TYPE,0
        JNE IT_SOURCE_IMMEDIATE_2_AHMED

            GET_SOURCE_ADDRESS_0 AHMED_AX
            JMP EXIT_GET_ADDRESSING_MODE_AHMED
        
        IT_SOURCE_IMMEDIATE_2_AHMED:

            CMP ADDRESSING_MODE_SOURCE_TYPE,3
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

            GET_SOURCE_ADDRESS_3 
            JMP EXIT_GET_ADDRESSING_MODE_AHMED

    EXIT_GET_ADDRESSING_MODE_AHMED:
    GET_CARRY_ADDRESS AHMED_AX

    RET
GET_ADDRESSING_MODE_AHMED ENDP






ADD_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_ADD

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        ADD AX,BX
        MOV [DI],AX

        JNC CLEAR_CARRY_ADD

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ADD_OP


        CLEAR_CARRY_ADD:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_ADD_OP

    OPERATION_8BITS_ADD:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        ADD AL,BL
        MOV [DI],AL

        JNC CLEAR_CARRY_ADD_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ADD_OP


        CLEAR_CARRY_ADD_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_ADD_OP

    EXIT_ADD_OP:

    RET
ADD_OP  ENDP

 ;============================================================
 ;============================================================
 
ADC_OP  PROC NEAR



    CMP DEST_BYTES,1
    JE OPERATION_8BITS_ADC

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]

        MOV BX,CARRY_ADDRESS
        MOV CL,[BX]
        CMP CL,0
        JNE SET_CARRY_ADC
            CLC
            JMP DO_ADC
        SET_CARRY_ADC:
            STC
        DO_ADC:

        ADC AX,BX
        MOV [DI],AX

        JNC CLEAR_CARRY_ADC

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ADC_OP


        CLEAR_CARRY_ADC:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_ADC_OP

    OPERATION_8BITS_ADC:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]

        MOV BX,CARRY_ADDRESS
        MOV CL,[BX]
        CMP CL,0
        JNE SET_CARRY_ADC
            CLC
            JMP DO_ADC
        SET_CARRY_ADC_2:
            STC
        DO_ADC_2:

        ADC AL,BL
        MOV [DI],AL

        JNC CLEAR_CARRY_ADC_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ADC_OP


        CLEAR_CARRY_ADC_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_ADC_OP

    EXIT_ADC_OP:

    RET
ADC_OP  ENDP


SUB_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_SUB

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        SUB AX,BX
        MOV [DI],AX

        JNC CLEAR_CARRY_SUB

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SUB_OP


        CLEAR_CARRY_SUB:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_SUB_OP

    OPERATION_8BITS_SUB:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        SUB AL,BL
        MOV [DI],AL

        JNC CLEAR_CARRY_SUB_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SUB_OP


        CLEAR_CARRY_SUB_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_SUB_OP

    EXIT_SUB_OP:

    RET
SUB_OP  ENDP


SBB_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_SBB

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]

        MOV BX,CARRY_ADDRESS
        MOV CL,[BX]
        CMP CL,0
        JNE SET_CARRY_SBB
            CLC
            JMP DO_SBB
        SET_CARRY_SBB:
            STC
        DO_SBB:

        SBB AX,BX
        MOV [DI],AX

        JNC CLEAR_CARRY_SBB

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SBB_OP


        CLEAR_CARRY_SBB:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_SBB_OP

    OPERATION_8BITS_SBB:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]

        MOV BX,CARRY_ADDRESS
        MOV CL,[BX]
        CMP CL,0
        JNE SET_CARRY_SBB
            CLC
            JMP DO_SBB
        SET_CARRY_SBB_2:
            STC
        DO_SBB_2:

        ADC AL,BL
        MOV [DI],AL

        JNC CLEAR_CARRY_SBB_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SBB_OP


        CLEAR_CARRY_SBB_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_SBB_OP

    EXIT_SBB_OP:

    RET
SBB_OP  ENDP



XOR_OP  PROC NEAR

    MOV BX,CARRY_ADDRESS
    MOV AX,0
    MOV [BX],AL

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_XOR

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        XOR AX,BX
        MOV [DI],AX
        JMP EXIT_XOR_OP

    OPERATION_8BITS_XOR:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        XOR AL,BL
        MOV [DI],AL

    EXIT_XOR_OP:

    RET
XOR_OP  ENDP


AND_OP  PROC NEAR

    MOV BX,CARRY_ADDRESS
    MOV AX,0
    MOV [BX],AL

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_AND

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        AND AX,BX
        MOV [DI],AX
        JMP EXIT_AND_OP

    OPERATION_8BITS_AND:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        AND AL,BL
        MOV [DI],AL

    EXIT_AND_OP:

    RET
AND_OP  ENDP

OR_OP  PROC NEAR

    MOV BX,CARRY_ADDRESS
    MOV AX,0
    MOV [BX],AL

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_OR

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        OR AX,BX
        MOV [DI],AX
        JMP EXIT_OR_OP

    OPERATION_8BITS_OR:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        OR AL,BL
        MOV [DI],AL

    EXIT_OR_OP:

    RET
OR_OP  ENDP


SHR_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_SHR

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV CL,[SI]
        SHR AX,CL
        MOV [DI],AX

        JNC CLEAR_CARRY_SHR

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SHR_OP


        CLEAR_CARRY_SHR:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_SHR_OP

    OPERATION_8BITS_SHR:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV CL,[SI]
        SHR AL,CL
        MOV [DI],AL

        JNC CLEAR_CARRY_SHR_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SHR_OP


        CLEAR_CARRY_SHR_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_SHR_OP

    EXIT_SHR_OP:



    RET
SHR_OP  ENDP

SHL_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_SHL

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV CL,[SI]
        SHL AX,CL
        MOV [DI],AX

        JNC CLEAR_CARRY_SHL

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SHL_OP


        CLEAR_CARRY_SHL:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_SHL_OP

    OPERATION_8BITS_SHL:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV CL,[SI]
        SHL AL,CL
        MOV [DI],AL

        JNC CLEAR_CARRY_SHL_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SHL_OP


        CLEAR_CARRY_SHL_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_SHL_OP

    EXIT_SHL_OP:



    RET
SHL_OP  ENDP


SAR_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_SAR

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV CL,[SI]
        SAR AX,CL
        MOV [DI],AX

        JNC CLEAR_CARRY_SAR

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SAR_OP


        CLEAR_CARRY_SAR:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_SAR_OP

    OPERATION_8BITS_SAR:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV CL,[SI]
        SAR AL,CL
        MOV [DI],AL

        JNC CLEAR_CARRY_SAR_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_SAR_OP

        CLEAR_CARRY_SAR_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_SAR_OP

    EXIT_SAR_OP:

    RET
SAR_OP  ENDP


CLC_OP  PROC NEAR

    MOV DI,CARRY_ADDRESS
    MOV AX,0
    MOV [DI],AL
    RET
CLC_OP  ENDP


NOP_OP  PROC NEAR

    NOP

NOP_OP ENDP


ROR_OP  PROC NEAR

    CMP DEST_BYTES,1
    JE OPERATION_8BITS_ROR

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV CL,[SI]
        ROR AX,CL
        MOV [DI],AX

        JNC CLEAR_CARRY_ROR

            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ROR_OP


        CLEAR_CARRY_ROR:

            MOV AX,0
            MOV [BX],AL

        JMP EXIT_ROR_OP

    OPERATION_8BITS_ROR:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV CL,[SI]
        ROR AL,CL
        MOV [DI],AL

        JNC CLEAR_CARRY_ROR_2
            
            MOV AX,1
            MOV [BX],AL
            JMP EXIT_ROR_OP

        CLEAR_CARRY_ROR_2:

            MOV AX,0
            MOV [BX],AL
            
        JMP EXIT_ROR_OP

    EXIT_ROR_OP:

    RET
ROR_OP  ENDP


INC_OP PROC NEAR

    MOV DI,DEST_ADDRESS
    MOV AX,0
    INC AL
    MOV [DI],AL

INC_OP ENDP

DEC_OP PROC NEAR

    MOV DI,DEST_ADDRESS
    MOV AX,0
    DEC AL
    MOV [DI],AL

DEC_OP ENDP


MOV_OP  PROC NEAR


    CMP DEST_BYTES,1
    JE OPERATION_8BITS_MOV

        MOV BX,CARRY_ADDRESS
        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AX,[DI]
        MOV BX,[SI]
        MOV AX,BX
        MOV [DI],AX
        JMP EXIT_MOV_OP

    OPERATION_8BITS_MOV:

        MOV DI,DEST_ADDRESS
        MOV SI,SOURCE_ADDRESS
        MOV AL,[DI]
        MOV BL,[SI]
        MOV AL,BL
        MOV [DI],AL

    EXIT_MOV_OP:

    RET



MOV_OP ENDP


ALI_EXE PROC NEAR

    CALL FETCH_DEST
    CALL FETCH_SOURCE
    CALL DECODE_DEST
    CALL DECODE_SOURCE
    CALL GET_ADDRESSING_MODE_ALI
    CALL EXECUT_INSTRUCTION
    RET

ALI_EXE ENDP


AHMED_EXE PROC NEAR

    CALL FETCH_DEST
    CALL FETCH_SOURCE
    CALL DECODE_DEST
    CALL DECODE_SOURCE
    CALL GET_ADDRESSING_MODE_AHMED
    CALL EXECUT_INSTRUCTION
    RET

AHMED_EXE ENDP
    END MAIN


