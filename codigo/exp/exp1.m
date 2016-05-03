% Procesado de los datos
[sepia_c_x, sepia_c_y, sepia_c_e, sepia_c_cant] = leer_datos('exp1/data-sepia-c.txt');
[sepia_asm_x, sepia_asm_y, sepia_asm_e, sepia_asm_cant] = leer_datos('exp1/data-sepia-asm.txt');
[ldr_c_x, ldr_c_y, ldr_c_e, ldr_c_cant] = leer_datos('exp1/data-ldr-c.txt');
[ldr_asm_x, ldr_asm_y, ldr_asm_e, ldr_asm_cant] = leer_datos('exp1/data-ldr-asm.txt');

sepia_c_tpp = sepia_c_y ./ sepia_c_x;
sepia_asm_tpp = sepia_asm_y ./ sepia_asm_x;
ldr_c_tpp = ldr_c_y ./ ldr_c_x;
ldr_asm_tpp = ldr_asm_y ./ ldr_asm_x;

% Impresión de los datos
mkdir('resultados');
file = fopen('resultados/exp1.txt', 'w');
formato = '  %18u    %16.2f    %16.2f    %16.2f\n';
encabezado= '    Tamaño de imagen     Tiempo empleado     Tiempo por píxel    Desvío estándar\n';
fprintf(file, 'Experimento 1\n');
fprintf(file, '\n  Filtro: sepia   Implementación: C    Imágenes: bastachicos1, bastachicos2   Cant. muestras: %u\n', sepia_c_cant);
fprintf(file, encabezado);
fprintf(file, formato, [sepia_c_x'; sepia_c_y'; sepia_c_tpp'; sepia_c_e']);
fprintf(file, '\n  Filtro: sepia   Implementación: ASM    Imágenes: bastachicos1, bastachicos2   Cant. muestras: %u\n', sepia_asm_cant);
fprintf(file, encabezado);
fprintf(file, formato, [sepia_asm_x'; sepia_asm_y'; sepia_asm_tpp'; sepia_asm_e']);
fprintf(file, '\n  Filtro: ldr   Implementación: C    Imagen: bastachicos1   Cant. muestras: %u\n', ldr_c_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_c_x'; ldr_c_y'; ldr_c_tpp'; ldr_c_e']);
fprintf(file, '\n  Filtro: ldr   Implementación: ASM    Imagen: bastachicos1   Cant. muestras: %u\n', ldr_asm_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_asm_x'; ldr_asm_y'; ldr_asm_tpp'; ldr_asm_e']);
fclose(file);

% Creación de los gráficos
filetype='-dpdf';
mkdir('graficos');
figure;
set(gca,'FontName', 'FreeSans');

hold on;
h = errorbar(sepia_c_x, sepia_c_y, sepia_c_e, 'r');
errorbar(sepia_asm_x, sepia_asm_y, sepia_asm_e);
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador','Location','northwest');
hold off;
set(get(h, 'Parent'), 'YScale', 'log');
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp1-sepia-c_vs_asm', filetype);

clf;
set(gca,'FontName', 'FreeSans');

hold on;
h = errorbar(ldr_c_x, ldr_c_y, ldr_c_e, 'r');
errorbar(ldr_asm_x, ldr_asm_y, ldr_asm_e);
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador','Location','northwest');
hold off;
set(get(h, 'Parent'), 'YScale', 'log');
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp1-ldr-c_vs_asm', filetype);

clf;
set(gca,'FontName', 'FreeSans');

hold on;
h = plot(sepia_c_x, sepia_c_tpp, 'r');
plot(sepia_asm_x, sepia_asm_tpp);
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion por pixel en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador');
hold off;
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp1-sepia-tiempo_por_pixel', filetype);

clf;
set(gca,'FontName', 'FreeSans');

hold on;
h = plot(ldr_c_x, ldr_c_tpp, 'r');
plot(ldr_asm_x, ldr_asm_tpp);
xlabel('Tamano de imagen','FontSize',12);
ylabel('Tiempo de ejecucion por pixel en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador','Location','northwest');
hold off;
set(get(h, 'Parent'), 'XScale', 'log');
print('graficos/exp1-ldr-tiempo_por_pixel', filetype);
