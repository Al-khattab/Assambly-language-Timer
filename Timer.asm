;This is a simple Timer implemented in Assambly language
;it counts up to one hour
;
;This is a lab project for EENG410 microprocessors 1 cousre
;spring 2020
;
;By ALkhattab yaseen 

; ------------------------------------------------MACROS------------------------------------------
; ------CLEAN SCREEN-------------
CLEAR   MACRO
	MOV AX,0600H
	MOV BH,07
	MOV CX,0000
	MOV DX,184FH
	INT 10H
  ENDM

; ------TIME COUNT (SECOND)-----
TIME  MACRO
      push CX
      push DX
      push AX
      MOV CX, 0FH
      MOV DX, 4240H
      MOV AH, 86H
      INT 15H
      POP AX
      POP DX
      POP CX
      ENDM

;------PRINT A CHARCTER ON THE SCREEN-----
DIO MACRO VALUE
          PUSH AX
          PUSH DX
          MOV AH,02
          MOV DL,VALUE
          ADD DL,30H
          INT 21H
          POP DX
          POP AX
          ENDM

; ------MOUSE LOCATE SET-----------------
CURSOR  MACRO Row, Col
        PUSH AX
        PUSH BX
        PUSH DX
	MOV AH,02
	MOV BH,00
	MOV DL,Col
	MOV DH,Row
	INT 10H
        POP DX
        POP BX
        POP AX
        ENDM

; -----DISPLAY-----------------
DISP   MACRO MES
       MOV AH,09
       MOV DX,OFFSET MES
       INT 21H
       ENDM

; ----------------------------------------------------------------------------------

.MODEL HUGE
.STACK 64H
;-------------------------------------------------------------------
.DATA 
MSG1 DB '------------ TIMER SIMULATION ------------','$'
MSG2 DB '----Instructions----','$'
MSG3 DB 'Press S/s to Start Timer','$'
MSG6 DB 'THANK YOU, GOOD BYE','$'
MSG7 DB '00:00','$'
;-------------------------------------------------------------------
.CODE
MAIN:   MOV AX,@DATA
        MOV DS, AX
        CLEAR
;---------------------------------------------------DISPLAY----------------------------------------------------
;----------TITLE---------------
        CURSOR 01,19
	DISP MSG1

;----------MENU----------------       
        CURSOR 05,01
	DISP MSG2

;----------START---------------        
        CURSOR 07,01
	DISP MSG3
;----------STOP----------------        
        CURSOR 12,37
        DISP MSG7 

;-------------------------------------------------------KEY---------------------------------------------------
        MOV AH, 07H
	INT 21H
	CMP AL,'S'
	JZ START
	CMP AL,'s'
	JZ START

;-------START THE TIMER----------
START: MOV BX,00H
       MOV DX,00H
       MOV AX,00H
;------MAIN LOOP FOR COUNTING THE FIRST SECOND------------------
BACK1: ADD BL,01H
       TIME
       CURSOR 12,41
       DIO BL
       CMP BL,09H
       JE TA
G1:    JNE BACK1
TA:    CURSOR 12,41
       DIO BL
       TIME
M1:    MOV BL,0H
       CURSOR 12,41
       DIO BL
;-----COUNTING THE SECIND SECONDS LOOP-----
       ADD BH,01H
       CMP BH,6H
       JE SKIP1
       CURSOR 12,40
       DIO BH
       CMP BH,06H
BACK2: JNE G1
SKIP1: MOV BH,0H
       CURSOR 12,40
       DIO BH
;-------FIRST MINUTES LOOP COUNTER-------
       ADD DL,01H
       CURSOR 12,38
       DIO DL
       CMP DL,0aH
BACK3: JBE BACK2
       CURSOR 12,38
       DIO DL
SKIP2: MOV DL,0H
;------- SECOND MINUTES LOOP COUNTER-----
       CURSOR 12,38
       DIO DL
       ADD DH,01H
       CMP DH,6H
       JE SKIP3
       CURSOR 12,37
       DIO DH
       CMP DH,6H
       JNE BACK3
SKIP3: MOV DH,0H
       CURSOR 12,37
       DIO DH
      CLEAR
;----------EXIT--------	
        CURSOR 9,29
	DISP MSG6
        MOV AH,4CH
	INT 21H
	END MAIN
        
