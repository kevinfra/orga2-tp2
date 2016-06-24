section .data
DEFAULT REL

%define null 0
%define tam4pixels 16
canalRojo: dd 0.5, 0, 0, 1.0
canalVerde: dd 0.3, 0, 0, 0
canalAzul: dd 0.2, 0, 0, 0

;ESTE ES SEPIA_ASM V1!!

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
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	xor rbx, rbx
	xor r12, r12
	movdqu xmm10, [canalRojo]
	movdqu xmm11, [canalVerde]
	movdqu xmm12, [canalAzul]

	.forFilas:
		cmp rbx, rcx
		je .fin

		.forCols:
			cmp r12, rdx
			jge .avanzarFila

			.cargar4pixelsEnXmm1:
				pxor xmm3, xmm3
				movups xmm2, [rdi] ;ahora guardo una copia de lo que voy a modificar. xmm0 = |p0a|p0r|p0g|p0b|···|p3a|p3r|p3g|p3b| byte
				movdqu xmm5, xmm2
				punpcklbw xmm2, xmm3 ;expando el byte de cada canal a word en parte baja (2 a 3 pixel)xmm2 = |0 p2a | 0 p2r | 0 p2g | 0 p2b | 0 p3a | 0 p3r | 0 p3g | 0 p3b |
				punpckhbw xmm5, xmm3 ;expando el byte de cada canal a word de la parte alta (pixels 0 y 1)

				;suma rgb parte baja
				movdqu xmm3, xmm2
				psrlq xmm3, 00001000b
				psrlq xmm3, 00001000b; ; xmm3= |0 | 0-P2a | 0-p2r | 0-p2g | 0 | 0-p3a | 0-p3r | 0-p3g |
				paddw xmm2, xmm3 ; xmm2=|p2a|p2a+p2r|p2r+p2g|p2g+p2b|p3a|p3a+p3r|p3r+p3g|p3g+p3b|
				psrlq xmm3, 00001000b
				psrlq xmm3, 00001000b ; xmm3=| 0 |	0	| 0-p2a | 0-p2r | 0 |	0	| 0-p3a | 0-p3r |
				paddw xmm2, xmm3 ; xmm2=|p2a|p2a+p2r|p2r+g+a|p2g+b+r|p3a|p3a+p3r|p3r+g+a|p3g+b+r| --libero xmm3 y xmm4

				;suma rgb parte alta
				movdqu xmm3, xmm5
				psrlq xmm3, 00001000b
				psrlq xmm3, 00001000b
				paddw xmm5, xmm3
				psrlq xmm3, 00001000b
				psrlq xmm3, 00001000b
				paddw xmm5, xmm3 ;queda en la parte baja de cada parte baja de cada dword en xmm5 la sumaRGB de los pixels 0 y 1
									; --libero xmm3, xmm4
									; tengo en xmm2 y xmm5 la sumaRGB de cada pixel en tamano word en la parte baja de cada dword

				;laburo con pixel3 (Parte baja de xmm2)
				.pixel3:
				pxor xmm4, xmm4
				movdqu xmm3, xmm2
				punpcklwd xmm3, xmm4 ;expando el word de cada canal a dword de la parte baja de xmm2 (pixel 3)
				movdqu xmm4, xmm3
				movdqu xmm6, xmm3
						;dejo copiado xmm3 en xmm4 y xmm6, para hacer la multiplicacion por 5, 3 y 2 y luego

				cvtdq2ps xmm7, xmm6
				cvtdq2ps xmm8, xmm4
				cvtdq2ps xmm9, xmm3

				mulps xmm7, xmm10
				mulps xmm8, xmm11
				mulps xmm9, xmm12

				shufps xmm9, xmm8, 01000100b ; xmm9 = | 0 |p3g| 0 |p3b|
				shufps xmm9, xmm7, 11001000b ; xmm9 = |a|r|g|b|
				cvtps2dq xmm15, xmm9

				;tengo libres xmm3, xmm4, xmm6 ->

				;tengo en xmm2 los pixels 2 y 3. 3 está listo, así que repito lo anterior con xmm2 parte alta

				.pixel2:
				pxor xmm4, xmm4
				movdqu xmm3, xmm2
				punpckhwd xmm3, xmm4 ;expando el word de cada canal a dword de la parte alta de xmm2 (pixel 2)
				movdqu xmm4, xmm3
				movdqu xmm6, xmm3
						;dejo copiado xmm3 en xmm4 y xmm6, para hacer la multiplicacion por 5, 3 y 2 y luego

				cvtdq2ps xmm7, xmm6 ;convierto sumaRGB dword a single floating point
				cvtdq2ps xmm8, xmm4
				cvtdq2ps xmm9, xmm3

				mulps xmm7, xmm10
				mulps xmm8, xmm11
				mulps xmm9, xmm12

				shufps xmm9, xmm8, 01000100b ; xmm9 = | 0 |p2g| 0 |p2b|
				shufps xmm9, xmm7, 11001000b ; xmm9 = |a|r|g|b|

				cvtps2dq xmm14, xmm9 ;|a|r|g|b|

				.empaquetarP2P3:
				;tengo en xmm15 p3 listo y en xmm14 p2 listo empaquetado como dword. Los junto ambos para volver a tener todo listo en xmm2
				packusdw xmm15, xmm14 ; xmm14 = |p2a|p2r|p2g|p2b|p3a|p3r|p3g|p3b|
				movdqu xmm14, xmm15


				;ahora hay que repetir el paso anterior con la parte alta de xmm1

			;al principio tenia los pixeles p1 y p0 en xmm5 en word. Lo muevo a xmm2 por comodidad.
				movdqu xmm2, xmm5
				.pixel1:
				pxor xmm4, xmm4
				movdqu xmm3, xmm2
				punpcklwd xmm3, xmm4 ;expando el word de cada canal a dword de la parte baja de xmm2 (pixel 1)
				movdqu xmm4, xmm3
				movdqu xmm6, xmm3
						;dejo copiado xmm3 en xmm4 y xmm6, para hacer la multiplicacion por 5, 3 y 2 y luego

				cvtdq2ps xmm7, xmm6 ;convierto sumaRGB dword a single floating point
				cvtdq2ps xmm8, xmm4
				cvtdq2ps xmm9, xmm3

				mulps xmm7, xmm10
				mulps xmm8, xmm11
				mulps xmm9, xmm12

				shufps xmm9, xmm8, 01000100b ; xmm9 = | 0 |p1g| 0 |p1b|
				shufps xmm9, xmm7, 11001000b ; xmm9 = |a|r|g|b|
				cvtps2dq xmm3, xmm9

				movdqu xmm15, xmm3 ;muevo xmm3 a xmm15 para dejar libre xmm3
				;tengo en xmm15 |a|r|g|b| de pixel1
				;tengo libres xmm3, xmm4, xmm6 ->

				;tengo en xmm2 los pixels 2 y 3. 3 está listo, así que repito lo anterior con xmm2 parte alta

				.pixel0:
				pxor xmm4, xmm4
				movdqu xmm3, xmm2
				punpckhwd xmm3, xmm4 ;expando el word de cada canal a dword de la parte alta de xmm2 (pixel 0)
				movdqu xmm4, xmm3
				movdqu xmm6, xmm3
						;dejo copiado xmm3 en xmm4 y xmm6, para hacer la multiplicacion por 5, 3 y 2 y luego

				cvtdq2ps xmm7, xmm6 ;convierto sumaRGB dword a single floating point
				cvtdq2ps xmm8, xmm4
				cvtdq2ps xmm9, xmm3

				mulps xmm7, xmm10
				mulps xmm8, xmm11
				mulps xmm9, xmm12

				shufps xmm9, xmm8, 01000100b ; xmm9 = | 0 |p0g| 0 |p0b|
				shufps xmm9, xmm7, 11001000b ; xmm9 = |a|r|g|b|

				cvtps2dq xmm3, xmm9 ;|a|r|g|b|
				movdqu xmm13, xmm3

				.empaquetarP0P1:
				;tengo en xmm15 p1 listo y en xmm13 p0 listo empaquetado como dword. Los junto ambos para volver a tener todo listo en xmm2
				packusdw xmm15, xmm13 ; xmm15 = |p0a|p0r|p0g|p0b|p1a|p1r|p1g|p1b|

				.empaquetarAByte:
				packuswb xmm14, xmm15 ; xmm13 = |p0a|p0r|p0g|p0b|p1a|p1r|p1g|p1b|p2a|p2r|p2g|p2b|p3a|p3r|p3g|p3b|
				movdqu [rsi], xmm14

				.avanzarIteradores:
				add r12, 4 ;la cantidad de pixeles que veo por iteracion
				add rdi, tam4pixels
				add rsi, tam4pixels
				jmp .forCols

				;empaqueto de WORD a Byte

		.avanzarFila:
		xor r12, r12
		add rbx, 1
		jmp .forFilas

	.fin:
	pop r12
	pop rbx
	pop rbp
	ret
