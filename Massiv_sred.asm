;font terminal!!!
.MODEL SMALL
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
.data
mess0 db 'Input:5 numbers in [-29999,29999]',10,13,'$'
mess00 db 'Press <Enter> after each number',10,13,'$'
mess000 db 'Srednee positiv:',10,13,'$'
mess2 db ' ',10,13,'$'
mess0000 db 'Delenie ngativ on srednee:',10,13,'$'
mess1 db 'Vvedite chislo:$'
in_str label byte ;бва®Є  бЁ¬ў®«®ў (­Ґ Ў®«ҐҐ 6)
razmer db 7
kol db (?)
stroka db 7 dup (?); §­ Є зЁб«  (¤«п ®ваЁж вҐ«м­ле), 5 жЁда, enter
number dw 5 dup (0)   ;¬ ббЁў зЁбҐ«
siz dw 5              ;Є®«ЁзҐбвў® зЁбҐ«
PosSum dw 0        ;баҐ¤­ҐҐ Ї®«®¦ЁвҐ«м­ле
a1 dw 0         
a2 dw 0
a3 dw 0	
a4 dw 0
a5 dw 0
perevod db 10,13,'$'
text_err1 db 'Input error!','$'
messovf db 13,10,7,'Overflow!','$'
messred db 13,10,'Average:','$'
messmax db 13,10,'Max:','$'
messerr db 13,10,'Error, delenie na nol','$'
out_str db 6 dup (' '),'$'
flag_err equ 1
nam dw 100,100,-100
.stack 256
.code
start: 		mov ax,@data
		mov ds,ax

;ўл§®ў дг­ЄжЁЁ 0 -  гбв ­®ўЄ  3 вҐЄбв®ў®Ј® ўЁ¤Ґ®аҐ¦Ё¬ , ®зЁбвЄ  нЄа ­ 
		mov ax,0003  ;ah=0 (­®¬Ґа дг­ЄжЁЁ),al=3 (­®¬Ґа аҐ¦Ё¬ )
		int 10h
		p1 mess0
		p1 mess00
;жЁЄ« ўў®¤ , di - ­®¬Ґа зЁб«  ў ¬ ббЁўҐ
       		xor di,di
       		mov cx, siz ; ў cx - а §¬Ґа ¬ ббЁў 
vvod:		push cx

m1:		p1 mess1     ;ўлў®¤ б®®ЎйҐ­Ёп ® ўў®¤Ґ бва®ЄЁ
;ўў®¤ зЁб«  ў ўЁ¤Ґ бва®ЄЁ
		p2 in_str
		p1 perevod
;Їа®ўҐаЄ  ¤Ё Ї §®­  ўў®¤Ё¬ле зЁбҐ« (-29999,+29999)
		call diapazon
		cmp bh,flag_err  ;ба ў­Ё¬ bh Ё flag_err
		je err1          ;Ґб«Ё а ўҐ­ -б®®ЎйҐ­ЁҐ ®Ў ®иЁЎЄҐ ўў®¤ 
;Їа®ўҐаЄ  ¤®ЇгбвЁ¬®бвЁ ўў®¤Ё¬ле бЁ¬ў®«®ў
		call dopust
		cmp bh,flag_err
		je err1
;ЇаҐ®Ўа §®ў ­ЁҐ бва®ЄЁ ў зЁб«®
		call AscToBin
		inc di
		inc di
		pop cx
		loop vvod
		jmp m2
err1:   		p1 text_err1	
		jmp m1
;§¤Ґбм ¬Ґбв® ¤«п  аЁд¬ҐвЁзҐбЄ®© ®Ўа Ў®вЄЁ
;*******************************************************************************
;­ ЇаЁ¬Ґа, Ї®«гзҐ­Ёп бг¬¬л Ї®«®¦ЁвҐ«м­ле, ®ваЁж вҐ«м­ле, баҐ¤­ҐЈ®, ¬ ЄбЁ¬ «м­®Ј®
;TRY!!!
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
;ўлў®¤ аҐ§г«мв в  ­  нЄа ­
		p1 mess000
		mov ax,PosSum	
		call BinToAsc
		p1 out_str
;®зЁбвЄ  ЎгдҐа  ўлў®¤ 
		mov cx,6
		xor si,si
clear1:		mov [out_str+si],' '
		inc si
		loop clear1
		p1 mess2
;*******************************************************************************
		mov cx,siz
		p1 mess0000           ;Delenie ngativ on srednee:
		mov di,offset number
q3:		mov ax,[di]
		test ax, ax
		jns q4
		mov bx,PosSum
		cwd
		idiv bx 
q4:		call BinToAsc
		p1 out_str
		mov dx,cx
		mov cx,6
		xor si,si
clear2:		mov [out_str+si],' '
		inc si
		loop clear2
		mov cx,dx
		inc di
		inc di
		loop q3

		jmp PROGEND
OVR:		p1 messovf  ;ўлў®¤ б®®ЎйҐ­Ёп ® ЇҐаҐЇ®«­Ґ­ЁЁ
		mov ah,7
		int 21h
ERR404:		p1 messerr  ;ўлў®¤ б®®ЎйҐ­Ёп ® ЇҐаҐЇ®«­Ґ­ЁЁ
		mov ah,7
		int 21h
PROGEND:	mov ax,4c00h
		int 21h
	
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
	cmp stroka,2dh
	jne plus ;   Ґб«Ё 1 бЁ¬ў®« ­Ґ ¬Ё­гб,Їа®ўҐаЁ¬ зЁб«® бЁ¬ў®«®ў
;Ґб«Ё ЇҐаўл© - ¬Ё­гб Ё бЁ¬ў®«®ў ¬Ґ­миҐ 6 Їа®ўҐаЁ¬ ¤®ЇгбвЁ¬®бвм бЁ¬ў®«®ў 
	cmp kol,6
	jb dop        
	inc si;         Ё­ зҐ Їа®ўҐаЁ¬ ЇҐаўго жЁдаг
	jmp first

plus:   cmp kol,6;      ўўҐ¤Ґ­® 6 бЁ¬ў®«®ў Ё ЇҐаўл© - ­Ґ ¬Ё­гб 
	je error1;       ®иЁЎЄ 
first:  cmp stroka[si],32h;ба ў­Ё¬ ЇҐаўл© бЁ¬ў®« б 2
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
m11:	mov al,[stroka+si]; ў al - ЇҐаўл© бЁ¬ў®«
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
n1:	mov al,[stroka+bx]
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