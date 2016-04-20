
#include "../tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )

#define P 2

#define valorMax 5*5*255*3*255

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
            //ldrMath(p_s, p_d, alpha, i, j, src, cols, filas, src_row_size);
            if((i > 2) && (j > 2) && ((i+2) < filas) && ((j+2) < cols)){
              float sumaRGB = sumargb(i, j, src, src_row_size);
              int suma = 0;
              int contadorI = -2;
              for(contadorI = -2; contadorI < 3; contadorI++){
                int contadorJ = -2;
                for(contadorJ = -2; contadorJ < 3; contadorJ++){
                  suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->r;
                  suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->g;
                  suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->b;
                }
              }


              float b = ((source->b) + ((alpha*sumaRGB / valorMax)*(source->b)));
              float g = ((source->g) + ((alpha*sumaRGB / valorMax)*(source->g)));
              float r = ((source->r) + ((alpha*sumaRGB / valorMax)*(source->r)));

              destiny->b = MIN(MAX(b, 0), 255);
              destiny->g = MIN(MAX(g, 0), 255);
              destiny->r = MIN(MAX(r, 0), 255);
            }


        }
    }
}



/*
void ldrMath(bgra_t *source, bgra_t *destiny, int alpha, int i, int j, unsigned char *src, int cols, int filas, int src_row_size){
  if((i > 2) && (j > 2) && ((i+2) < filas) && ((j+2) < cols)){
    float sumaRGB = sumargb(i, j, src, src_row_size);
    float b = ((source->b) + ((alpha*sumaRGB / valorMax)*(source->b)));
    float g = ((source->g) + ((alpha*sumaRGB / valorMax)*(source->g)));
    float r = ((source->r) + ((alpha*sumaRGB / valorMax)*(source->r)));

    destiny->b = MIN(MAX(b, 0), 255);
    destiny->g = MIN(MAX(g, 0), 255);
    destiny->r = MIN(MAX(r, 0), 255);
  }
}

char sumargb(int i, int j, unsigned char *src, int src_row_size){
  unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
  int suma = 0;
  int contadorI = -2;
  for(contadorI = -2; contadorI < 3; contadorI++){
    int contadorJ = -2;
    for(contadorJ = -2; contadorJ < 3; contadorJ++){
      suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->r;
      suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->g;
      suma = suma + ((bgra_t*) (&src_matrix[i + contadorI][(j + contadorJ)*4]))->b;
    }
  }
  return (char) suma;
}
*/
