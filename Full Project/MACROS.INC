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
DrawImg Macro _ImgData,_ImgHeight,_ImgWidth,_ImgVerticalOffset,_ImgHOrizontalOffset
	        mov  bx,_ImgHOrizontalOffset
	        mov  HorizontalOffset,bx
	        mov  bx,_ImgVerticalOffset
	        mov  VerticalOffset,bx
	        mov  AreaWidth,_ImgWidth
	        mov  AreaHeight,_ImgHeight
	        mov  bx,offset _ImgData
	        Call draw
endm

ClearArea Macro _ClearAreaHeight,_ClearAreaWidth,__ClerAreaVerticalOffset,__ClearAreaHorizontalOffset



	          mov    bx,__ClearAreaHorizontalOffset
	          mov    cx,__ClerAreaVerticalOffset

	          mov    ax,BackgroundData
	          mov    ds,ax
	          Assume ds:BackgroundData

	          mov    ClearHorizontalOffset,bx
	          mov    ClearVerticalOffset,cx
	          mov    ClearAreaWidth,_ClearAreaWidth
	          mov    ClearAreaHeight,_ClearAreaHeight
	          Call   Clear

	          mov    ax,@data
	          mov    ds,ax
	          assume ds: @data
endm 

Delay Macro A,B
	      MOV CX, A
	      MOV DX, B
	      MOV AH, 86H
	      INT 15H
ENDM 

ClearBuffer Macro
	            mov ah,0ch
	            mov al,0
	            int 21h
ENDM

move_cursor MACRO x_axis,y_axis
	; place cursor on row=11 col=25
	            mov ah,2
	            mov bh,0
	            mov dl,x_axis	;x-axis
	            mov dh,y_axis	;y-axis
	            int 10h
ENDM
print_mesg MACRO x_axis,y_axis,defining_byte,localmsg  		;defining_byte=1 to reallocating the cursor and 0 to let it in its place
	                      LOCAL       dont_change_thecursor
	                      mov         ah,defining_byte
	                      cmp         ah,0
	                      jz          dont_change_thecursor
	                      move_cursor x_axis,y_axis
	dont_change_thecursor:
	                      mov         ah,9
	                      lea         dx,localmsg
	                      int         21h
ENDM
print_status_mesg MACRO localmsg
	                  print_mesg 0,24,1,cleanmsg
	                  print_mesg 0,24,1,localmsg
ENDM
print_status_2_mesg MACRO localmsg1,localmsg2
	                    Clear_status_bar
	                    print_mesg       0,24,1,localmsg1
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg2
ENDM
print_status_3_mesg MACRO localmsg1,localmsg2,localmsg3
	                    Clear_status_bar
	                    print_mesg       0,24,1,localmsg1
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg2
	                    mov              ah,2
	                    mov              dl,' '
	                    int              21h
	                    print_mesg       0,24,0,localmsg3
ENDM
Clear_status_bar MACRO
	                 print_status_mesg cleanmsg
ENDM
read_string MACRO x_axis,y_axis,defining_byte,wanted_string		;defining_byte=1 to reallocating the cursor and 0 to let it in its place
	                      LOCAL       dont_change_thecursor
	                      mov         ah,defining_byte
	                      cmp         ah,0
	                      jz          dont_change_thecursor
	                      move_cursor x_axis,y_axis
	dont_change_thecursor:
	                      mov         ah,0ah
	                      lea         dx,wanted_string
	                      int         21h
ENDM
convert_num_to_ascii MACRO num,ascii_num
	                     LOCAL no_tens,gobCK
	                     mov   al,num
	                     mov   dl,10
	                     div   dl           	;al=tens   ah=ones
	                     cmp   al,0
	                     je    no_tens
	                     add   al,30h
	                     add   ah,30h
	                     lea   si,ascii_num
	                     mov   [si],ax
	                     jmp   gobCK
	no_tens:             
	                     add   ah,30h
	                     xchg  al,ah
	                     mov   ah,'$'
	                     lea   si,ascii_num
	                     mov   [si],ax
	gobCK:               
ENDM
validate Macro charachter
	         LOCAL okok,notgood,goodone
	         mov   al,41h
	         mov   ah,5bh

	         mov   bl,61h
	         mov   bh,7ah

	         cmp   charachter,al
	         jb    notgood
	         cmp   charachter,ah
	         jb    goodone

	         cmp   charachter,bl
	         jb    notgood
	         cmp   charachter,bh
	         ja    notgood
	goodone: 
	         mov   ax,1
	         push  ax
	         jmp   okok
	notgood: 
	         mov   ax,0
	         push  ax
	okok:    
ENDM
Check_For_Key_Pressed MACRO
	                      LOCAL NoKeyPressed,EndMacro
	                      mov   ah,1
	                      int   16h
	                      jz    NoKeyPressed
	;if found letter, eat buffer
	                      mov   ah,0
	                      int   16h
	                      JMP   EndMacro
	NoKeyPressed:         
	                      mov   ah,-1
	                      mov   al,-1
	EndMacro:             
ENDM	
FixUserName MACRO usrnm
	            local fixloop1,compare13,ENDFIXLOOP
	            mov   si, offset usrnm
	            add   si,2
	            mov   al,'$'
	            mov   bl,10
	            mov   bh,13
	            mov   cx,17
	fixloop1:   
	            cmp   [si],bl
	            jne   compare13
	            mov   [si],al
	compare13:  cmp   [si],bh
	            jne   ENDFIXLOOP
	            mov   [si],al
	ENDFIXLOOP: 
	            inc   si
	            dec   cx
	            jnz   fixloop1
ENDM


    ;============================================================  







