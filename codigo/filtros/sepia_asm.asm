section .data
DEFAULT REL

;;%define NULL 0
;;%define tam8Pixels 16
; 4 bytes * 4 pixels
;;%define 4cols 4
canalRojo: dd 0, 0.5, 0, 0.5
canalVerde: dd 0, 0.3, 0, 0.3
canalAzul: dd 0, 0.2, 0, 0.2

anularImpares: db 0xFF, 0x06, 0xFF, 0x04, 0xFF, 0x02, 0xFF, 0x00


section .text
global sepia_asm
; void sepia_c    (
;     unsigned char *src, 	rdi
;     unsigned char *dst,  	rsi
;     int cols,							rdx
;     int filas,						rcx
;     int src_row_size,			r8
;     int dst_row_size)			r9
; {
sepia_asm:
	push rbp
	mov rbp, rsp
	push r8
	push rbx
	push rax
	pxor xmm6, xmm6
	xor rbx, rbx
	xor rax, rax

.loopFilas:
	cmp rax, rcx
;	je .fin

.loopCols:
	cmp rbx, rdx
;	jge .avanzarFila

.cargar4pixelsEnXmm1:
; en xmm0 voy a guardar los datos para mandar a [rdi]
	movups xmm0, [rdi] ;ahora cuardo una copia de lo que voy a modificar. xmm0 = |p3r|p3g|p3b|p3a|···|p0r|p0g|p0b|p0a| byte
	movups xmm1, [rdi] ; carga los primeros 4 pixels en xmm1
;;	add rdi, tam8Pixels ;avanzo de a 4 pixeles
;;	add rbx, 4cols ;avanzo 4 columnas en la fila
	movdqu xmm2, xmm1 ;copio el contenido de xmm1 en xmm2
	punpcklbw xmm1, xmm6 ;expando el byte de cada canal a word en parte baja (0 a 1 pixel) = |0 p1r | 0 p1g | 0 p1b | 0 p1a | 0 p0r | 0 p0g | 0 p0b | 0 p0a|
	punpcklbw xmm2, xmm6 ;expando el byte de cada canal a word en parte alta (2 a 3 pixel)
	phaddw xmm1, xmm2 ;sumo de a dos canales y guardo las sumas en xmm1 = | p3r + p3g | p3b + p3a | p2r + p2g | p2b + p2a | p1r + p1g | p1b + p1a | p0r + p0g | p0b + p0a |
	phaddw xmm1, xmm1 ; sumo los canales restantes y guardo todas en xmm1. Me queda la suma de todos los canales de cada pixel en xmm1, repetido desde la mitad
														;|p3 | p2| p1| p0| p3| p2| p1| p0
	pxor xmm2, xmm2 ;limpio xmm2..5 para tener registros para convertir xmm1 a qword
	pxor xmm3, xmm3
	pxor xmm4, xmm4
	pxor xmm5, xmm5
	movdqu xmm1, xmm2 ;copio xmm1 a xmm2 para convertir de word a dword
	punpckhwd xmm1, xmm6 ;guardo la parte alta de word xmm1 como dw en xmm1				 = | 0 | sumaP3 | 0 | sumaP2 |
	punpcklwd xmm2, xmm6 ;guardo la parte baja de word xmm1 (xmm2) como dw en xmm2 = | 0 | sumaP1 | 0 | sumaP0 |
	;ahora tengo que multiplicar xmm1, xmm2, xmm3, xmm4 por 0.5, 0,3 y 0,2 y luego guardar como pixel
	cvtdq2ps xmm1, xmm1 ; deberia convertir los sumaP3 y sumaP2 a float
	cvtdq2ps xmm2, xmm2 ; deberia convertir los sumaP1 y sumaP0 a float
;;	movups xmm3, [canalRojo]
;;	movups xmm4, [canalVerde]
;;	movups xmm5, [canalAzul]
	movdqu xmm6, xmm1
	movdqu xmm7, xmm1 ;copio xmm1 a xmm6 y 7 para poder obtener la multiplicacion de cada canal
;;	movdqu xmm8, xmm2
;;	movdqu,xmm9, xmm2 ;copio xmm2 a xmm8 y 9 por la misma razon que arriba

	pmuludq xmm1, [canalRojo] ; xmm1 = |0| 0,5*sumaP3| 0 | 0,5*sumaP2
	pmuludq xmm6, [canalVerde] ;xmm6 = |0| 0,3*sumaP3| 0 | 0,3*sumaP2
	pmuludq xmm7, [canalAzul] ; xmm7 = |0| 0,2*sumaP3| 0 | 0,2*sumaP2
	;tengo suma*porcentajeCanal de p3 y p2

	pmuludq xmm2, [canalRojo]
	pmuludq xmm8, [canalVerde]
	pmuludq xmm9, [canalAzul] ;tengo la suma*porcentajeCanal de p1 y p0

	;ahora hay que volver a convertir a integer y empaquetar como byte


	cvtps2dq xmm1, xmm1 ;convierto a double word
	cvtps2dq xmm2, xmm2
	cvtps2dq xmm6, xmm6
	cvtps2dq xmm7, xmm7
	cvtps2dq xmm8, xmm8
	cvtps2dq xmm9, xmm9

	packusdw xmm6, xmm7 ;xmm6 = |P3G|P3B|P2G|P2B| WORD
	packusdw xmm8, xmm9 ;xmm8 = |P1G|P1B|P0G|P0B| WORD
	packusdw xmm1, xmm2 ;xmm1 = |P3R|P2R|P1R|P0R| WORD
	;XMM1 = | 0 |P3R| 0 |P2R|
	;XMM2 = | 0 |P1R| 0 |P0R|
	movdqu xmm7, xmm6 ;copio xmm6 a xmm7
	shufps xmm6, xmm1, 11001100 ; xmm6 = |P3R|P2R|P3G|P3B|
	shufps xmm7, xmm1, 00111100 ; xmm7 = |P3R|P2R|P2G|P2B|
	movdqu xmm9, xmm8 ; copio xmm8 a xmm9
	shufps xmm8, xmm1, 11000011 ; xmm8 = |P1R|P0R|P1G|P1B|
	shufps xmm9, xmm1, 00110011 ; xmm9 = |P1R|P0R|P0G|P0B|

	pxor xmm11, xmm11
	movdqu xmm10, xmm0
	punpckhbw xmm0, xmm11 ;me queda de a word la parte alta de xmm0		xmm0 = |p3r|p3g|p3b|p3a|p2r|p2g|p2b|p2a|
	punpcklbw xmm10, xmm11 ;me queda de a word la parte baha de xmm10	xmm10= |p1r|p1g|p1b|p1a|p0r|p0g|p0b|p0a|
	shufps xmm0, xmm10, 01010101b ;guarda en xmm0 = |p1b|p1a|p0b|p0a|p3b|p3a|p2b|p2a|
	pshufb xmm0, [anularImpares] ; queda en xmm0 = | 0 |p1a| 0 |p0a| 0 |p3a| 0 |p2a|
	movdqu xmm10, xmm0
	shufps xmm0, xmm6, 00111100 ; xmm0 = |0-P3G|0-P3B|0-P3A|0-P2A|
;	shl



;	shufps xmm6, xmm1, 01010101b ; xmm6 = |P3R|P2R|P3G|P3G|
;	shufps xmm6, xmm6, 01011010b ; xmm6 = |P3R|P3G|P2R|P2G|
;	shufps xmm3, xmm6, 00001100b ; xmm3 = |P3R|P3G| 0 | 0 |
;	shufps xmm3, xmm3, 11000000b ; xmm3 = | 0 | 0 |P3R|P3G|
;	shufps xmm3, xmm7, 00110101b ; xmm3 = |P3B|P2B|P3R|P3G|
;	pxor xmm10, xmm10
;	shufps xmm10, xmm3, 00000011 ; xmm10 = |P3R|P3G| 0 | 0 |
;	pshufd xmm10, xmm3,





;	je .cambiarPixelUnico
;	mov rdx, [rsi]
;	movdqu xmm2, rdx
;	punpcklbw xmm1, xmm2 ; voy a tener en xmm1, de a pares, los 4 canales
											; en la parte baja
;	punpckhbw

;	inc rax
;	jmp .loopFilas

	ret
