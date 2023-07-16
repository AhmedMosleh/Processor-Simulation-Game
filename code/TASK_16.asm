;MAIN PRP
;AHMED MOSLEH

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

GET_CURSOR  MACRO PAGE 
    MOV BH,PAGE
    MOV AH,3
    INT 10H
    MOV CURSOR_COL,DL
    MOV CURSOR_ROW,DH

ENDM 


;THIS MACRO CLEARS THE SCREEN
CLEAR_SCREEN MACRO 
    MOV AX,0600H
    MOV BH,07
    MOV CX,0
    MOV DX,184FH
    INT 10H
    
ENDM

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

COMPARE_STRINGS MACRO STR1,STR2,NUM_OF_BYTES
    LEA DI,STR1
    LEA SI,STR2
    MOV CX,NUM_OF_BYTES
    REP CMPSB    
ENDM

SET_VIDEO_MODE MACRO MODE
; TEXT 80X25 ==> AL = 3
; GRAPHICS 320X200 ==> AL = 4
; GRAPHICS 640X200 ==> AL = 6

    MOV AH,00
    MOV AL,MODE
    INT 10H
    
ENDM

DRAW_CHAR MACRO character_to_display,page_number,attribute,number_of_times 
    MOV AL,character_to_display
    MOV BH,page_number
    MOV BL,attribute
    MOV CX,number_of_times
    MOV AH,9
    INT 10H

ENDM

DRAW_PIXEL MACRO COLOR,ROW,COL
    MOV AL,COLOR
    MOV CX,COL
    MOV DX,ROW
    MOV AH,0CH
    INT 10H  
    
ENDM



;============================================================
; ========================MAIN CODE==========================
;============================================================

.MODEL LARGE
.STACK 64
.386 ;for jmp problem

;============DATA================
.DATA
MESS DB "HELLASDF","$"
GUN DB 30
BULLET DB 33
UP     EQU 72
DOWN   EQU 80
RIGHT  EQU 77
LEFT   EQU 75
SPACE  EQU 57
ESCAPE EQU 1

CURSOR_ROW DB ?
CURSOR_COL DB ?
GUN_CURSOR_ROW DB ?
GUN_CURSOR_COL DB ?
BULLET_CURSOR_ROW DB ?
BULLET_CURSOR_COL DB ?

key  db 0
locH dw 0  ;location horizontal
locV dw 0  ;location vertical

;============CODE================
.CODE 
MAIN PROC FAR
    ;DEFINE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX

INITIALISATION:
    CLEAR_SCREEN

    SET_VIDEO_MODE 19

    SET_CURSOR 0,0


    DRAW_CHAR GUN,0,16,1
    SET_CURSOR 5,5
    DRAW_CHAR GUN,0,14,1
    GET_CURSOR 0

    ;DRAW_PIXEL 4,160,100


    LOOP1:

        MOV AH,1
        INT 16H
        JZ LOOP1
        MOV AH,0
        INT 16H

        CMP AH,SPACE 
        JNE NOT_SPACE
        GET_CURSOR 0
        
        DEC CURSOR_ROW
        SET_CURSOR CURSOR_ROW ,CURSOR_COL
        GET_CURSOR  0
        BULLET_LOOP:
                DRAW_PIXEL 4,LOCV,5

        JMP LOOP1
        NOT_SPACE:



        CMP AH,UP
        JNE  IT_NOT_UP
            ;DELETE PIXEL
            DRAW_CHAR 30,0,16,1
            INT 10h
            ;DRAW NEXT
            GET_CURSOR 0
            DEC [CURSOR_ROW]
            SET_CURSOR CURSOR_ROW,CURSOR_COL
            DRAW_CHAR 30,0,13,1
            INT 10h
        JMP LOOP1
        IT_NOT_UP:
        

        CMP AH,DOWN
        JNE  IT_DOWN
            DRAW_CHAR 30,0,16,1 
            INT 10h
            INC [CURSOR_ROW]
            SET_CURSOR CURSOR_ROW,CURSOR_COL
            DRAW_CHAR 30,0,13,1
            INT 10h 
        JMP LOOP1 
        IT_DOWN:

        CMP AH,RIGHT
        JNE  IT_RIGHT
            DRAW_CHAR 30,0,16,1 
            INT 10h
            INC [CURSOR_COL]
            SET_CURSOR CURSOR_ROW,CURSOR_COL
            DRAW_CHAR 30,0,13,1
            INT 10h
        JMP LOOP1
        IT_RIGHT:

        CMP AH,LEFT
        JNE  IT_LEFT
            DRAW_CHAR 30,0,16,1 
            INT 10h
            DEC [CURSOR_COL]
            SET_CURSOR CURSOR_ROW,CURSOR_COL
            DRAW_CHAR 30,0,13,1
            INT 10h
        JMP LOOP1
        IT_LEFT:

        CMP AH,ESCAPE
        JNE LOOP1

    IT_ESCAPE:



     

        





    

   

    


 

        
        






  


    


    

    ;STOP PROGRAMM
    MOV  AH,4CH
    INT  21H

MAIN ENDP
    END MAIN


