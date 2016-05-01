section .data
DEFAULT REL

%define fruta 0
Divisor : dd 1.0 ,0.5, 0.3 , 0.2

section .text
global sepia_asm

; void sepia_c    (
;     unsigned char *src, rdi
;     unsigned char *dst, rsi
;     int cols,						rdx
;     int filas,					rcx
;     int src_row_size,		r8
;     int dst_row_size)		r9
; {
sepia_asm:

.StackFrame:
push rbp
mov rsp , rbp
push r15 ; R15 = Contandor Filas
push r14 ; R14 = Contador Filas
push r13 ; R13 = Suma RGB
push r12 ; R12 = Suma RGB
push rbx
xor r15 , r15
xor r14 , r14
xor r13 , r13
xor r12 , r12
xor rbx , rbx
pxor xmm15, xmm15 ;Va a tener los valores para dividir
pxor xmm14, xmm14 ;Valores en byte para tirar a memoria  
pxor xmm13, xmm13
pxor xmm12, xmm12
pxor xmm11, xmm11
pxor xmm10, xmm10
pxor xmm9 , xmm9
pxor xmm8 , xmm8
pxor xmm7 , xmm7
pxor xmm6 , xmm6
pxor xmm5 , xmm5
pxor xmm4 , xmm4 ; PlaceHolder
pxor xmm3 , xmm3 ; Parte Alta
pxor xmm2 , xmm2 ; Parte Baja
pxor xmm1 , xmm1 ; XMM1 tendra los pixels originales
pxor xmm0 , xmm0 ; XMM0 solo con 0 SIEMPRE  
movdqu xmm15 , [Divisor]

		.CicloFilas:
		cmp r15 , rcx
		je .fin

		.cicloColumnas:
		cmp r14 , rdx
		je .NextFila
							; A ; R ; G ; B
		.loadPixels:
		movdqu xmm1 , [rdi] ; RDI = |p0|p1|p2|p3|
		movdqu xmm2 , xmm1
		movdqu xmm3 , xmm1
		punpcklbw xmm2 , xmm0 ; XMM2 = P2 y P3 Exten
		punpckhbw xmm3 , xmm0 ; XMM3 = P0 y P1 Ext
		;XMM4-14 LIBRES 
		.SumaLow: 
		;Hago la suma de la otra parte
		movdqu xmm4 , xmm2
		psrldq xmm4 , 2 ; Shifteo 2 Bytes a Derecha
		paddw xmm2 , xmm4
		psrldq xmm4 , 2
		paddw xmm2 , xmm4
		;XMM2 Word 0 y 4 suma RGB ; Resto fruta podrida
		pextrw r13w, xmm2 , 0 ; R13W = p3 (R+G+B)
		pextrw r12w, xmm2 , 4 ; R12W = p2 (R+G+B) 
		.SumaHigh:
		movdqu xmm4 , xmm3
		psrldq xmm4 , 2
		paddw xmm3 , xmm4
		psrldq xmm4 , 2 
		paddw xmm3 , xmm4
		pextrw ax , xmm3 , 0 ; AX = P1 (R+G+B)
		pextrw bx , xmm3 , 4 ; BX = P0 (R+G+B)

		.Extend_Double_Float_P0:
		;XMM4 Disponible
		pxor xmm4 , xmm4
		pinsrw xmm4 , bx , 0
		pinsrw xmm4 , bx , 2
		pinsrw xmm4 , bx, 4
		xor bx , bx
		pinsrb bl , xmm0 , 15
		pinsrb xmm4 , bx, 6
		cvtdq2ps xmm5 , xmm4 ; Paso a Float
		divps xmm5 , xmm4 ; Divido
		CVTPS2DQ xmm4 , xmm5 ; Paso a Dword
		PACKUSDW 					;Pack D_2_W	
		

		.Extend_Double_Float_P1:

		.Extend_Double_Float_P2:

		.Extend_Double_Float_P3:

		.NextFila:
		

.fin:
pop r15
pop r14
pop rbp
ret
