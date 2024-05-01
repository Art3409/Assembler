;vot macrosy
anykey macro
	push ax
	mov ah,7
	int 21h
	pop ax
endm
vivod macro x
	mov dx,offset x
	mov ah,9
	int 21h
endm
curpos macro strcol
	mov dx,strcol
	mov ah,2
	mov bh,0
	int 10h
endm
stroka macro y
local m1
	mov si,offset y
m1:	mov ah,2
	mov bh,0
	int 10h
	mov ah,0ah
	mov cx,1
        mov al,byte ptr [si]
	int 10h
	inc si
	inc dx
	cmp byte ptr [si],'$'
	jne m1
endm	
;ўлў®¤ Їа®ЎҐ«®ў ў бва®Єг б®®ЎйҐ­Ё©
;Є®®а¤Ё­ вл бва®ЄЁ б®®ЎйҐ­Ё© 1401h
probel macro
local clear
	curpos koord
	mov ah,0eh
	mov cx,70
	mov bh,0
clear:	mov al,' '
	int 10h
	loop clear
endm
.model small
;************************************
p1 macro f1;ўлў®¤ б®®ЎйҐ­Ё© ­  нЄа ­
	push ax
	push dx
	mov dx,offset f1
	mov ah,9
	int 21h
	pop dx
	pop ax
endm
p2 macro f2;ўў®¤ бва®ЄЁ бЁ¬ў®«®ў
	push ax
	push dx
	mov dx,offset f2
	mov ah,0ah
	int 21h
	pop dx
	pop ax
endm
;************************************
.data
in_str label byte ;бва®Є  бЁ¬ў®«®ў (­Ґ Ў®«ҐҐ 6)
razmer db 7
kol db (?)
stroka1 db 7 dup (?); §­ Є зЁб«  (¤«п ®ваЁж вҐ«м­ле), 5 жЁда, enter
number dw 5 dup (0)   ;¬ ббЁў зЁбҐ«
siz dw 5              ;Є®«ЁзҐбвў® зЁбҐ«
PosSum dw 0        ;баҐ¤­ҐҐ Ї®«®¦ЁвҐ«м­ле
a1 dw 0         
a2 dw 0
a3 dw 0	
a4 dw 0
a5 dw 0
out_str db 6 dup (' '),'$'
flag_err equ 1
nam dw 100,100,-100
;koordinaty okon 
upleft dw 0103h,0204h,0504h,0804h,0120h,0130h,0a20h,0b21h
downri dw 0a17h,0316h,0616h,0916h,0727h,0737h,0f33h,0e32h
attr dw 2000h, 3 dup (2000h),5700h,1700h,3000h
curp dw 0204h,0604h,0904h,0120h,0130h,0a20h
x_l db 01
x_r db 0ah
x_txt_l dw (?)
x_txt_2 dw (?)
x_txt_3 dw (?)
x_txt_4 dw (?)
x_txt_5 dw (?)
x_txt_must dw (?)
minus12 dw 0230h
plus12 dw 0220h
mess0 db 'Input:5 numbers$'
mess1 db ' $'
mess2 db '$'	
mess3 db '$'
mess4 db 'Massiv+$'
mess5 db 'Massiv-$'
mess000 db 'Srednee positiv:$'
mess0000 db 'Delenie ngativ on srednee:',10,13,'$'
propusk db '....$'
text_err1 db 'Input error!$'
messovf db 'Overflow!$'
messerr db 'Error, delenie na nol$'
;ramki iz ASCII
ram1 db 201,6 dup (205),'Result',6 dup (205),187,'$'
ram2 db 186,18 dup (' '),186,'$'
ram3 db 200,18 dup (205),188,'$'
pro1 db 'Do you wish to change Result window color? Y/N$'
pro2 db 'Press any key for exit$'
pro3 db 'Press <==> to change.Enter for choice.$'
pro4 db 'Press any key to continue.$'
pro5 db 'Do you wish to change Input window plase? Y/N$'
pro6 db 'Move window  <= =>.Choice - enter.$'
var1 db 'Num:$'
koord dw 1401h
.stack 256
.code
start:	mov ax,@data
	mov ds,ax
	mov ax,0003h
	int 10h
	mov ah,6
	mov al,0
	mov cx,0120h
	mov dx,0727h
	mov bh,30
	int 10h
	mov ah,6
	mov al,0
	mov cx,0130h
	mov dx,0737h
	mov bh,30
	int 10h
	mov ah,6
	mov al,0
	mov cx,0a20h
	mov dx,0f33h
	mov bh,20
	int 10h
	mov ah,6
	mov al,0
	mov cx,0b21h
	mov dx,0e32h
	mov bh,30
	int 10h
;‚лў®¤ б®®ЎйҐ­Ё©, Є®®а¤. Єгаб®а  - curp
	xor di,di
	irp a,<mess1,mess2,mess3,mess4,mess5>
	mov dx,curp+di
	stroka a
	inc di
	inc di
	endm
;ђ ¬Є , аЁбгҐ¬ Ї®бва®з­® ram1-3
	mov dx,curp+di
	push dx
	stroka ram1
	rept 5
	pop dx
	inc dh
	push dx
	stroka ram2
	endm
	pop dx
	stroka ram3
	curpos koord
;Smena mesta
;risuem okno startovoe okno
	mov ch,x_l
	mov dh,x_r
	mov bh,20h
	call drawin2
	vivod pro5
repea1:	mov ah,0
	int 16h
	cmp al,'n'
	je noy1
	cmp al,'y'
	jne repea1
	probel
	curpos koord
;window  /\ \/
	vivod pro6
;vvod
presskey:mov ah,0
	int 16h
;if enter
	cmp ax,1c0dh
	je noy1
;if =><=
	cmp ax,4d00h
	je up
	cmp ax,4b00h
	je lov
	jmp presskey
up:	mov bh,0
	call drawin2
	inc x_l
	inc x_r
	mov ch,x_l
	mov dh,x_r
	mov bh,20h
	call drawin2
	jmp presskey
lov:	mov bh,0
	call drawin2
	dec x_l
	dec x_r
	mov ch,x_l
	mov dh,x_r
	mov bh,20h
	call drawin2
	jmp presskey
;Smena sveta
noy1:	add cx,1
	mov x_txt_l,cx
	curpos cx
	vivod mess0
	probel
	curpos koord
	vivod pro1
repeat:	mov ah,0
	int 16h
	cmp al,'n'
	je col_ok
	cmp al,'y'
	jne repeat
	probel
	curpos koord
	vivod pro3
	call wincol
	jmp tobe
col_ok: probel
	curpos koord
	vivod pro4
 
tobe:	mov bx,x_txt_l
	mov x_txt_must,bx
	add bh,1
	mov x_txt_l,bx
	add bh,1
	mov x_txt_2,bx
	add bh,1
	mov x_txt_3,bx
	add bh,1
	mov x_txt_4,bx
	add bh,1
	mov x_txt_5,bx
	xor di,di
me1:	curpos x_txt_l
	vivod var1
	p2 in_str 
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
	call diapazon
	cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
	jne nerr1        ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
	jmp err1
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
nerr1:	call dopust
	cmp bh,flag_err
	jne nerr2
	jmp err1
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
nerr2:	call AscToBin
	inc di
	inc di

me2:	mov bx,x_txt_must
	add bh,2
	curpos x_txt_2
	vivod var1
	p2 in_str 
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
	call diapazon
	cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
	jne nerr3        ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
	jmp err2
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
nerr3:	call dopust
	cmp bh,flag_err
	jne nerr4
	jmp err2
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
nerr4:	call AscToBin
	inc di
	inc di

me3:	curpos x_txt_3
	vivod var1
	p2 in_str 
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
	call diapazon
	cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
	jne nerr5        ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
	jmp err3
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
nerr5:	call dopust
	cmp bh,flag_err
	jne nerr6
	jmp err3
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
nerr6:	call AscToBin
	inc di
	inc di

me4:	curpos x_txt_4
	vivod var1
	p2 in_str 
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
	call diapazon
	cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
	jne nerr7        ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
	jmp err4
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
nerr7:	call dopust
	cmp bh,flag_err
	jne nerr8
	jmp err4
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
nerr8:	call AscToBin
	inc di
	inc di
	
me5:	curpos x_txt_5
	vivod var1
	p2 in_str 
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
	call diapazon
	cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
	jne nerr9        ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
	jmp err5
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
nerr9:	call dopust
	cmp bh,flag_err
	jne nerr10
	jmp err5
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
nerr10:	call AscToBin
	inc di
	inc di

	jmp m2
err1:   probel
	curpos koord
	vivod text_err1
	anykey
	curpos x_txt_l	
	vivod propusk
	jmp me1
err2:   probel
	curpos koord
	vivod text_err1
	anykey
	curpos x_txt_2
	vivod propusk
	jmp me2
err3:   probel
	curpos koord
	vivod text_err1
	anykey
	curpos x_txt_3
	vivod propusk	
	jmp me3
err4:   probel
	curpos koord
	vivod text_err1
	anykey
	curpos x_txt_4
	vivod propusk
	jmp me4
err5:   probel
	curpos koord
	anykey
	vivod text_err1
	curpos x_txt_5
	vivod propusk
	jmp me5
;¬Ґбв® ¤«п  аЁд¬ҐвЁзҐбЄ®© ®Ўа Ў®вЄЁ
;*******************************************************************************
;
;********************************************************************************************
m2:		mov cx,siz
		mov bx,0
		mov si,offset number
q1:		mov ax,[si]
		test ax, ax
		js q2
		add bx,1
		add PosSum, ax
		jno q2
		jmp OVR
q2:		inc si
		inc si
		loop q1
		cmp bx,0
		jnz new1
		jmp ERR404
new1:		mov ax,PosSum
		cwd
		idiv bx
		mov PosSum,ax	
	curpos 0b21h
	mov ax,PosSum	
	call BinToAsc
	p1 out_str
;®зЁбвЄ  ЎгдҐа  ўлў®¤ ?
		mov cx,6
		xor si,si
clear1:		mov [out_str+si],' '
		inc si
		loop clear1
;*******************************************************************************
	probel
	curpos koord
	vivod mess0000
		mov cx,siz
		mov di,offset number
q3:		mov ax,[di]
		test ax, ax
		jns q4
		mov bx,PosSum
		cwd
		idiv bx 
		call BinToAsc
		mov dx,minus12
		curpos dx
		add dh,1
		mov minus12,dx
		p1 out_str
		jmp q5
q4:		call BinToAsc
		mov dx,plus12
		curpos dx
		add dh,1
		mov plus12,dx
		p1 out_str
q5:		mov ax,cx
		mov cx,6
		xor si,si
clear2:		mov [out_str+si],' '
		inc si
		loop clear2
		mov cx,ax
		inc di
		inc di
		loop q3

		jmp PROGEND

	anykey
	;call activ
	probel
	curpos koord
	vivod pro2
	anykey	
	mov ax,4c00h
	int 21h
;*************CHAST S PROCEDURAMI***************
OVR:		probel
		curpos koord
		p1 messovf  ;ўлў®¤ б®®ЎйҐ­Ёп ® ЇҐаҐЇ®«­Ґ­ЁЁ
		mov ah,7
		int 21h
ERR404:		probel
		curpos koord
		p1 messerr  ;ўлў®¤ б®®ЎйҐ­Ёп ® ЇҐаҐЇ®«­Ґ­ЁЁ
		mov ah,7
		int 21h
PROGEND:	probel
		curpos koord
		mov ax,4c00h
		int 21h
drawin proc
	push bp
	mov bp,sp
	mov ax,0600h
	mov cx,[bp+8]
	mov dx,[bp+6]
	mov bx,[bp+4]
	int 10h
	pop bp
	ret
drawin endp
;****************************
wincol proc
	mov ax,upleft+14
	push ax
	mov ax,downri+14
	push ax
	mov bx,0
pressk:	mov ah,0
	int 16h
	cmp ax,1c0dh
	je fin
	cmp ax,4d00h
	je right
	cmp ax,4b00h
	je left
	jmp pressk
right:	cmp bh,0f0h
	je pressk
	add bh,10h
	push bx
	call drawin
	pop bx
	jmp pressk
left:	cmp bh,10h
	je pressk
	sub bh,10h
	push bx
	call drawin
	pop bx
	jmp pressk
fin:	probel
	curpos koord
	vivod pro4
	pop ax
	pop ax
	ret
wincol endp
;****************************
activ proc
	xor di,di
	mov si,2
	mov ax,[upleft+si]
	push ax
	mov ax,[downri+si]
	push ax
	mov ax,0b500h
	push ax
	call drawin
	pop ax
	pop ax
	pop ax
	mov dx,curp+di
	stroka mess1	
	ret
activ endp	
;****************************
drawin2 proc
	mov ax,0600h
	mov cl,03
	mov dl,19h
	int 10h
	ret
drawin2 endp


DIAPAZON PROC
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« -29999,+29999
;ЎгдҐа ўў®¤  - stroka
;зҐаҐ§ bh ў®§ўа й Ґвбп д« Ј ®иЁЎЄЁ ўў®¤ 
        xor bh,bh;
	xor si,si;      ­®¬Ґа бЁ¬ў®«  ў ўў®¤Ё¬®¬ зЁб«Ґ
;Ґб«Ё ўўҐ«Ё ¬Ґ­ҐҐ 5 бЁ¬ў®«®ў Їа®ўҐаЁ¬ Ёе ¤®ЇгбвЁ¬®бвм
	cmp kol,5
	jb dop
;Ґб«Ё ўўҐ«Ё 5 Ё«Ё Ў®«ҐҐ бЁ¬ў®«®ў Їа®ўҐаЁ¬ пў«пҐвбп «Ё ЇҐаўл© ¬Ё­гб®¬
	cmp stroka1,2dh
	jne plus ;   Ґб«Ё 1 бЁ¬ў®« ­Ґ ¬Ё­гб,Їа®ўҐаЁ¬ зЁб«® бЁ¬ў®«®ў
;Ґб«Ё ЇҐаўл© - ¬Ё­гб Ё бЁ¬ў®«®ў ¬Ґ­миҐ 6 Їа®ўҐаЁ¬ ¤®ЇгбвЁ¬®бвм бЁ¬ў®«®ў 
	cmp kol,6
	jb dop        
	inc si;         Ё­ зҐ Їа®ўҐаЁ¬ ЇҐаўго жЁдаг
	jmp first

plus:   cmp kol,6;      ўўҐ¤Ґ­® 6 бЁ¬ў®«®ў Ё ЇҐаўл© - ­Ґ ¬Ё­гб 
	je error1;       ®иЁЎЄ 
first:  cmp stroka1[si],32h;ба ў­Ё¬ ЇҐаўл© бЁ¬ў®« б 2
	jna dop;Ґб«Ё ЇҐаўл© <=2 -Їа®ўҐаЁ¬ ¤®ЇгбвЁ¬®бвм бЁ¬ў®«®ў
error1:	mov bh,flag_err;Ё­ зҐ bh=flag_err
dop:	ret
DIAPAZON ENDP
DOPUST PROC
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
;ЎгдҐа ўў®¤  - stroka
;si - ­®¬Ґа бЁ¬ў®«  ў бва®ЄҐ
;зҐаҐ§ bh ў®§ўа й Ґвбп д« Ј ®иЁЎЄЁ ўў®¤ 
	xor bh,bh
        xor si,si
	xor ah,ah
	xor ch,ch
	mov cl,kol;ў ch Є®«ЁзҐбвў® ўўҐ¤Ґ­­ле бЁ¬ў®«®ў
m11:	mov al,[stroka1+si]; ў al - ЇҐаўл© бЁ¬ў®«
	cmp al,2dh;пў«пҐвбп «Ё бЁ¬ў®« ¬Ё­гб®¬
	jne testdop;Ґб«Ё ­Ґ ¬Ё­гб - Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ
	cmp si,0;Ґб«Ё ¬Ё­гб  - пў«пҐвбп «Ё ®­ ЇҐаўл¬ бЁ¬ў®«®¬
	jne error2;Ґб«Ё ¬Ё­гб ­Ґ ЇҐаўл© -®иЁЎЄ 
	jmp m13
;пў«пҐвбп «Ё ўўҐ¤Ґ­­л© бЁ¬ў®« жЁда®©
testdop:cmp al,30h
	jb error2
	cmp al,39h
	ja error2
m13: 	inc si
	loop m11
	jmp m14
error2:	mov bh, flag_err;ЇаЁ ­Ґ¤®ЇгбвЁ¬®бвЁ бЁ¬ў®«  bh=flag_err
m14:	ret
DOPUST ENDP
AscToBin PROC
;ў cx Є®«ЁзҐбвў® ўўҐ¤Ґ­­ле бЁ¬ў®«®ў
;ў bx - ­®¬Ґа бЁ¬ў®«  ­ зЁ­ п б Ї®б«Ґ¤­ҐЈ® 
;ЎгдҐа зЁбҐ« - number, ў di - ­®¬Ґа зЁб«  ў ¬ ббЁўҐ
	xor ch,ch
	mov cl,kol
	xor bh,bh
	mov bl,cl
	dec bl
	mov si,1  ;ў si ўҐб а §ап¤ 
n1:	mov al,[stroka1+bx]
	xor ah,ah
	cmp al,2dh;Їа®ўҐаЁ¬ §­ Є зЁб« 
	je otr    ; Ґб«Ё зЁб«® ®ваЁж вҐ«м­®Ґ
	sub al,30h
	mul si
	add [number+di],ax
	mov ax,si
	mov si,10
	mul si
	mov si,ax
	dec bx
	loop n1
	jmp n2
otr:	neg [number+di];ЇаҐ¤бв ўЁ¬ ®ваЁж вҐ«м­®Ґ зЁб«® ў ¤®Ї®«­ЁвҐ«м­®¬ Є®¤Ґ
n2:	ret
AscToBin ENDP
BinToAsc PROC
;ЇаҐ®Ўа §®ў ­ЁҐ зЁб«  ў бва®Єг
;зЁб«® ЇҐаҐ¤ Ґвбп зҐаҐ§ ax
	xor si,si
	add si,5
	mov bx,10
	push ax
	cmp ax,0
	jnl mm1
	neg ax
mm1:	cwd
	idiv bx
	add dl,30h
	mov [out_str+si],dl
	dec si
	cmp ax,0
	jne mm1
	pop ax
	cmp ax,0
	jge mm2
	mov [out_str+si],2dh
mm2:	ret
BinToAsc ENDP
end start






