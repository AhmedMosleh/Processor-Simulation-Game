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




;============================================================
; ========================MAIN CODE==========================
;============================================================

.MODEL HUGE
.STACK 64

;================================
;============DATA================
;================================
.DATA

	;-------------------DrawImage/Clear Area Data----------
	HorizontalOffset        dw  ?
	VerticalOffset          dw  ?
	AreaWidth               dw  ?
	AreaHeight              dw  ?
	IP_Pointer_Temp         dw  ?
    BallSize                EQU 12
    Ball_X                  dw  5555
	Ball_Y                  dw  5555



MESS DB "ASDFASDFA","$"

;================================
;============CODE================
;================================
.CODE 
MAIN PROC FAR
    ;DEFINE DATA SEGMENT
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX

    ;CLEAR SCREEN
    CLEAR_SCREEN

    SET_VIDEO_MODE 4

     DrawImg BallImg, Ballsize, Ballsize, Ball_Y, Ball_X

     

    
    


    



    

    





    

    ;STOP PROGRAMM
    MOV  AH,4CH
    INT  21H

MAIN ENDP
    END MAIN


Draw Proc  Near
	 pop                   IP_Pointer_Temp                                                          	;store ip pointer for return
	;   pop       HorizontalOffset                                           	;popping data from stack
	;   pop       VerticalOffset
	;   pop       AreaWidth
	;   pop       AreaHeight
	;   pop       bx                                                         	;Carry Img data pointer

	;setting interrupt configurations
	                                  MOV                   CX, 0                                                                    	;AreaWidth ;0
	                                  MOV                   DX, 0                                                                    	; AreaHeight ;0
	                                  add                   cx,HorizontalOffset
	                                  add                   dx,VerticalOffset
	                                  mov                   di,bx
	                                  jmp                   StartDrawing

	Drawit:                           
	                                  MOV                   AH,0Ch                                                                   	;draw pixel
	                                  mov                   al, [DI]                                                                 	;color of current pixel
	                                  cmp                   al,0                                                                     	;if pixel is empty
	                                  jz                    StartDrawing                                                             	;skip
	                                  MOV                   BH,00h                                                                   	;set page number
	                                  INT                   10h
	;call dddd
	StartDrawing:                     
	                                  inc                   DI                                                                       	;move to next pixel
	                                  INC                   Cx                                                                       	;dec
	                                  mov                   bx,HorizontalOffset
	                                  add                   bx,AreaWidth
	                                  cmp                   cx,bx                                                                    	;VerticalOffset ;+areawidth
	                                  JNZ                   Drawit
	                                  mov                   Cx, HorizontalOffset                                                     	;AreaWidth	;0
	                                  INC                   DX                                                                       	;dec
	                                  mov                   bx,VerticalOffset
	                                  add                   bx,AreaHeight
	                                  cmp                   dx,bx                                                                    	;HorizontalOffset	;+areaheight
	                                  JZ                    ENDDrawing
	                                  Jmp                   Drawit

	ENDDrawing:                       
	                                  push                  IP_Pointer_Temp
	                                  RET
draw endp


