
#include "../tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )

void sepia_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    for (int i = 0; i < filas; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            bgra_t *p_d = (bgra_t*) &dst_matrix[i][j * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[i][j * 4];
						int sumargb = (p_s->r + p_s->g + p_s->b);
            p_d->r = MAX(MIN(0.5*sumargb, 255), -255);
						p_d->g = MAX(MIN(0.3*sumargb, 255), -255);;
						p_d->b = MAX(MIN(0.2*sumargb, 255), -255);;
        }
    }
}
