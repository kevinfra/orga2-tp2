% Procesado de los datos
[sepia_c_x, sepia_c_y, sepia_c_e, sepia_c_cant] = leer_datos('exp3/data-sepia-c.txt');
[sepia_c2_x, sepia_c2_y, sepia_c2_e, sepia_c2_cant] = leer_datos('exp3/data-sepia-c2.txt');
[ldr_asm_x, ldr_asm_y, ldr_asm_e, ldr_asm_cant] = leer_datos('exp3/data-ldr-asm.txt');
[ldr_asm2_x, ldr_asm2_y, ldr_asm2_e, ldr_asm2_cant] = leer_datos('exp3/data-ldr-asm2.txt');

% Impresión de los datos
mkdir('resultados');
file = fopen('resultados/exp3.txt', 'w');
formato = '  %18u    %16.2f    %16.2f\n';
encabezado= '    Tamaño de imagen     Tiempo empleado     Desvío estándar\n';
fprintf(file, 'Experimento 1\n');
fprintf(file, '\n  Filtro: sepia   Implementación: C    Imágenes: bastachicos1, bastachicos2   Cant. muestras: %u\n', sepia_c_cant);
fprintf(file, encabezado);
fprintf(file, formato, [sepia_c_x'; sepia_c_y'; sepia_c_e']);
fprintf(file, '\n  Filtro: sepia   Implementación: C2    Imágenes: bastachicos1, bastachicos2   Cant. muestras: %u\n', sepia_c2_cant);
fprintf(file, encabezado);
fprintf(file, formato, [sepia_c2_x'; sepia_c2_y'; sepia_c2_e']);
fprintf(file, '\n  Filtro: ldr   Implementación: ASM    Imagen: bastachicos1   Cant. muestras: %u\n', ldr_asm_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_asm_x'; ldr_asm_y'; ldr_asm_e']);
fprintf(file, '\n  Filtro: ldr   Implementación: ASM2    Imagen: bastachicos1   Cant. muestras: %u\n', ldr_asm2_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_asm2_x'; ldr_asm2_y'; ldr_asm2_e']);
fclose(file);

% Creación de los gráficos
filetype='-dpdf';
mkdir('graficos');
figure;
set(gca,'FontName', 'FreeSans');

hold on;
h = errorbar(sepia_c_x, sepia_c_y, sepia_c_e);
errorbar(sepia_c2_x, sepia_c2_y, sepia_c2_e, 'r');
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Sin llamados a funcion','Con llamados a funcion','Location','northwest');
hold off;
set(get(h, 'Parent'), 'YScale', 'log');
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp3-sepia-c_vs_c2', filetype);

clf;
set(gca,'FontName', 'FreeSans');

hold on;
h = errorbar(ldr_asm2_x, ldr_asm2_y, ldr_asm2_e);
errorbar(ldr_asm_x, ldr_asm_y, ldr_asm_e, 'r');
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Sin llamados a funcion','Con llamados a funcion','Location','northwest');
hold off;
set(get(h, 'Parent'), 'YScale', 'log');
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp3-ldr-asm_vs_asm2', filetype);
