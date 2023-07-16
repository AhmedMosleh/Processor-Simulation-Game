include Macros.inc
;;=============================================================================;;
;;                                                                             ;;
;;                       2 PLAYER Balloon Game                                 ;;
;;                                                                             ;;
;;=============================================================================;;

.model COMPACT
.stack 1024
.data

exit db 0
player1_pos dw 1760d                         ;position of player

arrow1_pos dw 0d                             ;position of arrow
arrow1_status db 0d                          ;0 = arrow ready to go else not 
arrow1_limit dw  22d     ;150d

loon1_pos dw 3860d       
loon1_status db 1d

player2_pos dw 1710d                         ;position of player

arrow2_pos dw 0d                             ;position of arrow
arrow2_status db 0d                          ;0 = arrow ready to go else not 
arrow2_limit dw  22d     ;150d

loon2_pos dw 3810d       
loon2_status db 1d
         
                                            ;direction of player1 
                                            ;up=8, down=2
direction1 db 0d

                                            ;direction of player1 
                                            ;up=8, down=2
direction2 db 0d

state_buf db '00:0:0:0:0:0:00:00$'          ;score variable
hit_num db 0d
hits1 dw 0d
miss1 dw 0d
hits2 dw 0d
miss2 dw 0d   

game_over_str dw '  ',0ah,0dh
db '                             |               |',0ah,0dh
db '                             |---------------|',0ah,0dh
db '                             | ^   Score   ^ |',0ah,0dh
db '                             |_______________|',0ah,0dh
dw ' ',0ah,0dh 
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
db '                                Game Over',0ah,0dh
db '                        Press Enter to start again$',0ah,0dh 


username1               db  16,?,17 dup('$')
username2               db  16,?,17 dup('$')
	cleanmsg                db  '                                                                            $'
	waiting                 db  'waiting','$'
	responsetochat          db  'response to chat','$'
	responsetoplay          db  'response to play','$'
initial_msg_warning     db  "*The username shouldn't exceed 15 characters and should start with a letter.$"
	initial_msg_1           db  'please enter your username : $'
	initial_msg_2           db  'please enter the username of the second player: $'
    dashedline              db  80 dup('-'),'$'
    current_video_mode      db  ?


game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
db '                ====================================================',0ah,0dh
db '               ||                                                  ||',0ah,0dh                                        
db '               ||       *    Balloon Shooting Game      *          ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh
db '               ||--------------------------------------------------||',0ah,0dh
db '               ||                                                  ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh          
db '               ||     Use up and down key to move player           ||',0ah,0dh
db '               ||          and space button to shoot               ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh 
db '               ||                                                  ||',0ah,0dh
db '               ||                                                  ||',0ah,0dh
db '                ====================================================',0ah,0dh
db '$',0ah,0dh

up equ 48h
down equ 50h
space equ 39h
Char_Sent db ?
Char_Received db ?
F2 equ 3ch
.code
main proc
mov ax,@data
mov ds,ax

mov ax, 0B800h
mov es,ax 
CALL                  ConfigureCommunication


jmp game_menu                              ;display main menu

                                                                   
main_loop:                                 ;update logic and display everything
                                           ;check any key is pressed
    
    mov al,-1
    mov Char_Sent,al
    mov Char_Received,al
    call Receive_Char
    cmp Char_Received, 0
    jg key_pressed
    mov ah,1h
    int 16h                                ;go if pressed
    jnz key_pressed
    jmp inside_loop                        ;or just continue
    
    inside_loop:                           ;checking every thing
        
        ;cmp miss1,12                          ;if baloon miss 3 times.go to game over section
        ;jge game_over

        ;cmp miss2,12
        ;jge game_over
        
        mov dx,arrow1_pos                   ;checking collitions
        cmp dx, loon1_pos
        je hit1

        mov dx,arrow2_pos                   ;checking collitions
        cmp dx, loon2_pos
        je hit2
        
        cmp direction1,8d                   ;update player position
        je player1_up
        cmp direction1,2d                   ;up or down based on direction1 veriable
        je player1_down
        cmp direction2,8d
        je player2_up
        cmp direction2,2d
        je player2_down
        
        mov dx,arrow2_limit                 ;hide arrow 
        cmp arrow2_pos, dx
        jge hide_arrow2
        
        mov dx,arrow1_limit                 ;hide arrow 
        cmp arrow1_pos, dx
        jge hide_arrow1

        
        
        cmp loon1_pos, 0d                   ;check missed loon
        jle miss_loons
        cmp loon2_pos, 0d
        jle miss_loons
        jne render_loons
    
        hit1:                               ;play sound if hit
            mov loon1_status, 0d
            mov ah,2
            mov dx, 7d
            int 21h 
            
            inc hits1                       ;update score
            
            lea bx,state_buf               ;display score
            call show_score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                       ;new line
            mov dl, 0dh
            int 21h    
            
            cmp loon2_status, 0d
            je fire_loons                  ;new loon pops up
            jmp render_loons

        hit2:                               ;play sound if hit
            mov loon2_status, 0d
            mov ah,2
            mov dx, 7d
            int 21h 
            
            inc hits2                       ;update score
            
            lea bx,state_buf               ;display score
            call show_score 
            lea dx,state_buf
            mov ah,09h
            int 21h
            
            mov ah,2                       ;new line
            mov dl, 0dh
            int 21h    
            
            cmp loon1_status, 0d
            je fire_loons                  ;new loon pops up
            jmp render_loons

        render_loons:                       ;draw loons
            mov cl, ' '                    ;hide old loon
            mov ch, 1111b

            
            MOV     CX, 1H
            MOV     DX, 140H
            MOV     AH, 86H         
            INT     15H                 ;wait 1 sec
            
            cmp loon1_status, 0d
            je render_loon2

            mov bx,loon1_pos 
            mov es:[bx], cx
                
            sub loon1_pos,160d              ;and draw new one in new position
            mov cl, 15d
            mov ch, 1101b

            mov bx,loon1_pos 
            mov es:[bx], cx

            render_loon2:
                mov cl, ' '                     ;hide old loon
                mov ch, 1111b
                
                cmp loon2_status, 0d
                je firing_check


                mov bx,loon2_pos 
                mov es:[bx], cx
                    
                sub loon2_pos,160d              ;and draw new one in new position
                mov cl, 15d
                mov ch, 1101b

                mov bx,loon2_pos 
                mov es:[bx], cx
                
            firing_check:
                cmp loon1_status, 0d
                jne continue
                cmp loon2_status, 0d
                jne continue
                jmp fire_loons

            continue:
                cmp arrow1_status,1d    
                je render_arrows
                cmp arrow2_status,1d
                je render_arrow2

                jmp inside_loop2 

        render_arrows:                      ;render arrow
        
            mov cl, ' '
            mov ch, 1111b
        
            cmp arrow1_status, 0d
            je render_arrow2
            
            mov bx,arrow1_pos               ;hide old position
            mov es:[bx], cx
                
            add arrow1_pos,4d               ;draw new position
            mov cl, 26d
            mov ch, 1001b
        
            mov bx,arrow1_pos 
            mov es:[bx], cx

            render_arrow2:
                mov cl, ' '
                mov ch, 1111b
            
                cmp arrow2_status, 0d
                je inside_loop2
                
                mov bx,arrow2_pos               ;hide old position
                mov es:[bx], cx
                    
                add arrow2_pos,4d               ;draw new position
                mov cl, 26d
                mov ch, 1001b
            
                mov bx,arrow2_pos 
                mov es:[bx], cx

        
        inside_loop2:
            
            mov cl, 125d                  ;draw player char
            mov ch, 1100b                 ;color red
            
            mov bx,player1_pos 
            mov es:[bx], cx

            mov cl, 125d
            mov ch,1010b

            mov bx,player2_pos
            mov es:[bx], cx
            
             
                       
    cmp exit,0
    je main_loop                          ;end main loop
    jmp exit_game
 
jmp inside_loop2
    
player1_up:                                ;hide player old position
    mov cl, ' '
    mov ch, 1111b
        
    mov bx,player1_pos 
    mov es:[bx], cx
    
    sub player1_pos, 160d                  ;set new postion of player
    mov direction1, 0    

    jmp inside_loop2                      ;it will draw in main loop
    
player1_down:
    mov cl, ' '                           ;same as player up
    mov ch, 1111b                         ;hide old one and set new postion
                                          
    mov bx,player1_pos 
    mov es:[bx], cx
    
    add player1_pos,160d                   ;and main loop draw that
    mov direction1, 0
    
    jmp inside_loop2

player2_up:                                ;hide player old position
    mov cl, ' '
    mov ch, 1111b
        
    mov bx,player2_pos 
    mov es:[bx], cx
    
    sub player2_pos, 160d                  ;set new postion of player
    mov direction2, 0    

    jmp inside_loop2                      ;it will draw in main loop
    
player2_down:
    mov cl, ' '                           ;same as player up
    mov ch, 1111b                         ;hide old one and set new postion
                                          
    mov bx,player2_pos 
    mov es:[bx], cx
    
    add player2_pos,160d                   ;and main loop draw that
    mov direction2, 0
    
    jmp inside_loop2
key_pressed:                              ;input hanaling section
    cmp Char_Received,up
    je hisUpKey
    cmp Char_Received,down
    je hisDownKey
    cmp Char_Received,space
    je hisSpaceKey 


    contd:
    mov ah,0
    int 16h

    cmp ah,48h                            ;go upKey if up button is pressed
    je upKey
    cmp ah, 50h
    je downKey
    
    cmp ah,39h                            ;go spaceKey if up button is pressed
    je spaceKey
     
                                          ;if no key is pressed go to inside of loop
    jmp inside_loop

leftKey:                                  ;for debuging 
    ;jmp game_over
    inc miss1
            
    lea bx,state_buf
    call show_score 
    lea dx,state_buf
    mov ah,09h
    int 21h
    
    mov ah,2
    mov dl, 0dh
    int 21h
jmp inside_loop
    
upKey:                                    ;set player1 direction to up
    mov direction1, 8d
    mov Char_Sent, up
    call Send_Char
    jmp inside_loop

downKey:
    mov direction1, 2d                     ;set player1 direction to down
    mov Char_Sent, down
    call Send_Char
    jmp inside_loop
    
spaceKey:                                 ;shoot an arrow
    cmp arrow1_status,0
    je  fire_arrow1
    jmp inside_loop

hisUpKey:                                    ;set player2 direction to up
    mov direction2, 8d
    mov ah,1h
    int 16h                                ;go if pressed
    jnz contd
    jmp inside_loop

hisDownKey:
    mov direction2, 2d                     ;set player2 direction to down
    mov ah,1h
    int 16h                                ;go if pressed
    jnz contd
    jmp inside_loop
    
hisSpaceKey:                                 ;shoot an arrow
    cmp arrow2_status,0
    je  fire_arrow2
    mov ah,1h
    int 16h                                ;go if pressed
    jnz contd
    jmp inside_loop


fire_arrow1:                               ;set arrow postion in player position
    
    mov Char_Sent, space
    call Send_Char

    
    mov dx, player1_pos                    ;so arrow fire from player postion
    mov arrow1_pos, dx
    
    mov dx,player1_pos                     ;when fire an arrow it also set limit
    mov arrow1_limit, dx                   ;of arrow. where it should be hide
    add arrow1_limit, 22d  ;150
    
    mov arrow1_status, 1d                  ;set arrow status.It prevents multiple 


    jmp inside_loop                       ;shooting 

fire_arrow2:                               ;set arrow postion in player position
    mov dx, player2_pos                    ;so arrow fire from player postion
    mov arrow2_pos, dx
    
    mov dx,player2_pos                     ;when fire an arrow it also set limit
    mov arrow2_limit, dx                   ;of arrow. where it should be hide
    add arrow2_limit, 22d  ;150
    
    mov arrow2_status, 1d                  ;set arrow status.It prevents multiple 
    mov ah,1h
    int 16h                                ;go if pressed
    jnz contd
    jmp inside_loop

miss_loons:
    
    cmp loon1_pos, 0d                   ;check missed loon
    jg miss_loon2

    miss_loon1:
        mov loon1_status, 0d
        inc miss1
        ;lea bx,state_buf                      ;display score
        ;call show_score 
        ;lea dx,state_buf
        ;mov ah,09h
        ;int 21h
                                            ;new line
        ;mov ah,2
        ;mov dl, 0dh
        ;int 21h
        
    
    miss_loon2:
        cmp loon2_pos, 0d
        jg render_loons

        mov loon2_status, 0d
        inc miss2
        lea bx,state_buf                      ;display score
        call show_score 
        lea dx,state_buf
        mov ah,09h
        int 21h
                                            ;new line
        mov ah,2
        mov dl, 0dh
        int 21h 

    jmp render_loons
    
fire_loons:                                ;fire new balloons

    fire1:
        mov loon1_status, 1d
        mov loon1_pos, 3860d     ;3860d    

    fire2:
        mov loon2_status, 1d
        mov loon2_pos, 3810d     ;3810d

    jmp render_loons
    
hide_arrow1:
    mov arrow1_status, 0                   ;hide arrow
    
    mov cl, ' '
    mov ch, 1111b
    
    mov bx,arrow1_pos 
    mov es:[bx], cx
    
    cmp loon1_pos, 0d 
    jle miss_loons
    jne render_loons 
    
    jmp inside_loop2
    
                                          ;print game over screen

hide_arrow2:
    mov arrow2_status, 0                   ;hide arrow
    
    mov cl, ' '
    mov ch, 1111b
    
    mov bx,arrow2_pos 
    mov es:[bx], cx
    
    cmp loon2_pos, 0d 
    jle miss_loons
    jne render_loons 
    
    jmp inside_loop2

                                          ;print game over screen
game_over:
    mov ah,09h
    ;mov dh,0
    mov dx, offset game_over_str
    int 21h
    
    
    
    mov cl, ' '                           ;hide last of screen balloon
    mov ch, 1111b 
    mov bx,arrow1_pos                      
    
    mov cl, ' '                           ;hide player
    mov ch, 1111b 
    mov bx,player1_pos  
 
    
    ;reset value                          ;update variable for start again
    mov miss1, 0d
    mov hits1,0d
    
    mov player1_pos, 1760d

    mov arrow1_pos, 0d
    mov arrow1_status, 0d 
    mov arrow1_limit, 22d      

    mov loon1_pos, 3860d       
    mov loon1_status, 1d
         
    mov direction1, 0d

    mov miss2, 0d
    mov hits2,0d
    
    mov player2_pos, 1710d

    mov arrow2_pos, 0d
    mov arrow2_status, 0d 
    mov arrow2_limit, 22d      

    mov loon2_pos, 3810d       
    mov loon2_status, 1d
         
    mov direction2, 0d
    
                                           ;wait for input
    input:
        mov ah,1
        int 21h
        cmp al,13d
        jne input
        call clearr_screen
        jmp main_loop
    

game_menu:
                                           ;game menu screen
    mov ah,09h
    mov dh,0
    mov dx, offset game_start_str
    int 21h

    Call USERNAMES

    MOV     CX, 015H
    MOV     DX, 8240H
    MOV     AH, 86H         
    INT     15H        ;wait 1 sec

    call clearr_screen
    
    lea bx,state_buf                   ;display score
    call show_score 
    lea dx,state_buf
    mov ah,09h
    int 21h

    mov ah,2
    mov dl, 0dh
    int 21h
    
    jmp main_loop

exit_game:                                  ;end of our sweet game :)
mov exit,10d

main endp



;;--------------------------------------------------------------------;;
;;                                                                    ;;
;;  show score in same postion on screen                              ;;
;;  using base pointer to get segment of variable                     ;;
;;                                                                    ;;
;;____________________________________________________________________;;

show_score proc far
    lea bx,state_buf
    
    mov dx, hits1
    add dx,48d 
    
    mov [bx], 9d
    mov [bx+1], 9d
    mov [bx+2], 9d
    mov [bx+3], 9d
    mov [bx+4], 'H'
    mov [bx+5], 'i'                                        
    mov [bx+6], 't'
    mov [bx+7], 's'
    mov [bx+8], ':'
    mov [bx+9], dx
    
    mov dx, miss2
    add dx,48d
    mov [bx+10], ' '
    mov [bx+11], 'M'
    mov [bx+12], 'i'
    mov [bx+13], 's'
    mov [bx+14], 's'
    mov [bx+15], ':'
    mov [bx+16], dx
ret    
show_score endp 

clearr_screen proc near
        mov ah,0
        mov al,3
        int 10h        
        ret
clearr_screen endp

Send_Char PROC NEAR

	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	redo:                            In                    al , dx                                                                  	;Read Line Status
	                                  test                  al , 00100000b
	                                  JZ                    redo                                                                    	;Not empty
	;If empty put the VALUE in Transmit data register
	                                  mov                   dx , 3F8H                                                                	; Transmit data register
	                                  mov                   al,Char_Sent
	                                  out                   dx , al

	return22:                         
	                                  RET
Send_Char ENDP

Receive_Char PROC NEAR
	                                  mov                   Char_Received , -1
	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	                                  in                    al , dx
	                                  test                  al , 1
	                                  JZ                    RETURN11                                                                 	;Not Ready
	;If Ready read the VALUE in Receive data register
	                                  mov                   dx , 03F8H
	                                  in                    al , dx
	                                  mov                   Char_Received , al
	RETURN11:                         
	                                  RET
Receive_Char ENDP

;try_proc_Check_For_Key_Pressed proc near
;	                                  Check_For_Key_Pressed
;	                                  ret
;try_proc_Check_For_Key_Pressed endp

ConfigureCommunication PROC NEAR
	                                  mov                   dx,3fbh                                                                  	; Line Control Register
	                                  mov                   al,10000000b                                                             	;Set Divisor Latch Access Bit
	                                  out                   dx,al                                                                    	;Out it

	                                  mov                   dx,3f8h
	                                  mov                   al,01h
	                                  out                   dx,al

	                                  mov                   dx,3f9h
	                                  mov                   al,00h
	                                  out                   dx,al

	                                  mov                   dx,3fbh
	                                  mov                   al,00011011b
	                                  out                   dx,al

                                    
	                                  RET
ConfigureCommunication ENDP

USERNAMES PROC NEAR
	                                  mov                   si,offset username1+1
	                                  mov                   di,offset username2+1
	                                  mov                   cx,18
	USERNAMELOOP:                     
	                                  mov                   al,[si]
	                                  mov                   Char_Sent,al
	                                  CALL                  Send_Char

	                                  mov                   al,-1
	                                  mov                   Char_Received,al
	; forcereceive:
	;                                   CALL                  Receive_Char
	;                                   cmp                   Char_Received,-1
	;                                   jz                    forcereceive
	                                  call                  Force_Receive_Char
	                                  mov                   al , Char_Received
	                                  mov                   [di],al
	                                  inc                   si
	                                  inc                   di
	                                  dec                   cx
	                                  jnz                   USERNAMELOOP
	;remove enter at the end of uusernames
	                                  FixUserName           username1
	                                  FixUserName           username2
	                                  print_status_3_mesg   waiting,username1+2,responsetoplay
	                                  RET
USERNAMES ENDP

initial_screen proc NEAR
	; clear
	                                  MOV                   AH, 06h                                                                  	; Scroll up function
	                                  XOR                   AL, AL                                                                   	; Clear entire screen
	                                  mov                   CX,  0                                                                   	; Upper left corner CH=row, CL=column
	                                  MOV                   DX, 184FH                                                                	; lower right corner DH=row, DL=column
	                                  MOV                   BH, 07fh
	                                  INT                   10H


	                                  print_mesg            0,24,1,initial_msg_warning
	                                  print_mesg            0,23,1,dashedline
	write_username1:                  
	                                  print_mesg            5,10,1,initial_msg_1
	                                  read_string           0,0,0,username1
	                                  validate              username1+2
	                                  pop                   ax
	                                  cmp                   ax,0
	                                  jz                    write_username1
	intitial_return:                  

	                                  ret
initial_screen endp

Force_Receive_Char PROC NEAR
	                                  mov                   Char_Received , -1
	                                  mov                   dx , 3FDH                                                                	; Line Status Register
	RETURN112:                        in                    al , dx
	                                  test                  al , 1
	                                  JZ                    RETURN112                                                                	;Not Ready
	;If Ready read the VALUE in Receive data register
	                                  mov                   dx , 03F8H
	                                  in                    al , dx
	                                  mov                   Char_Received , al

	                                  RET
Force_Receive_Char ENDP

end main

