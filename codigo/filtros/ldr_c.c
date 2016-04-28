
#include "../tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )

#define P 2

void ldrMath(bgra_t *source, bgra_t *destiny, int alpha, int i, int j, unsigned char *src_matrix, int cols, int filas, int src_row_size);
char sumagb(int i, int j, unsigned char *src_matrix, int src_row_size);

void ldr_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size,
	int alpha)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    for (int i = 0; i < filas; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            bgra_t *p_d = (bgra_t*) &dst_matrix[i][j * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[i][j * 4];
            if((i >= 2) && (j >= 2) && ((i+2) < filas) && ((j+2) < cols)){
              	int suma = 0;
              	for(int contadorI = -2; contadorI < 3; contadorI++){
                	for(int contadorJ = -2; contadorJ < 3; contadorJ++){
                  	suma += ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->r;
                  	suma += ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->g;
                  	suma += ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->b;
                	}
              	}

              	int valorMax = 5*5*255*3*255;
								float sumaPorAlpha = alpha*suma;
								float sumaXalphaXb = sumaPorAlpha*(p_s->b);
								float sumaXalphaXg = sumaPorAlpha*(p_s->g);
								float sumaXalphaXr = sumaPorAlpha*(p_s->r);
              	float b = ((p_s->b) + sumaXalphaXb / valorMax);
              	float g = ((p_s->g) + sumaXalphaXg / valorMax);
              	float r = ((p_s->r) + sumaXalphaXr / valorMax);

              	p_d->b = MIN(MAX((int) b, 0), 255);
              	p_d->g = MIN(MAX((int) g, 0), 255);
              	p_d->r = MIN(MAX((int) r, 0), 255);
								p_d->a = p_s->a;
          	}else{
							*p_d = *p_s;
						}
        }
    }
}
