
#include "../tp2.h"

void cropflip_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size,
	int tamx,
	int tamy,
	int offsetx,
	int offsety)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	// ejemplo de uso de src_matrix y dst_matrix (copia una parte de la imagen)

	int finy = tamy+offsety-1;
	int finx = tamx + offsetx;

	int itDstY = 0;
	for (int i = tamy+offsety+tamy-2; i >= finy; i--) {
		int itDstX = 0;
		for (int j = offsetx; j < finx+offsetx; j++) {
			bgra_t *p_d = (bgra_t*) &dst_matrix[itDstY][itDstX * 4];
			bgra_t *p_s = (bgra_t*) &src_matrix[i][j * 4];
			*p_d = *p_s;
			itDstX++;
		}
		itDstY++;
	}
}
