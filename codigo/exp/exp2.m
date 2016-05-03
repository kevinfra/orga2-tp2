% Parte A (según radio)

% Procesado de los datos
[ldr_c_x, ldr_c_y, ldr_c_e, ldr_c_cant] = leer_datos('exp2/a-data-ldr-c.txt');
[ldr_asm_x, ldr_asm_y, ldr_asm_e, ldr_asm_cant] = leer_datos('exp2/a-data-ldr-asm.txt');

% Impresión de los datos
mkdir('resultados');
file = fopen('resultados/exp2-a.txt', 'w');
formato = '  %8u    %16.2f    %16.2f\n';
encabezado= '     Radio     Tiempo empleado     Desvío estándar\n';
fprintf(file, 'Experimento 2\n');
fprintf(file, '\n  Implementación: C   Imagen: bastachicos1   Sigma: 5   Cant. muestras: %u\n', ldr_c_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_c_x'; ldr_c_y'; ldr_c_e']);
fprintf(file, '\n  Implementación: ASM   Imagen: bastachicos1   Sigma: 5   Cant. muestras: %u\n', ldr_asm_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_asm_x'; ldr_asm_y'; ldr_asm_e']);
fclose(file);

% Creación de los gráficos
filetype='-dpdf';
mkdir('graficos');
figure;
set(gca,'FontName', 'FreeSans');

hold on;
errorbar(ldr_c_x, ldr_c_y, ldr_c_e, 'r');
errorbar(ldr_asm_x, ldr_asm_y, ldr_asm_e);
xlabel('Radio','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador');
hold off;
print('graficos/exp2-tiempo_segun_radio', filetype);

A = ldr_c_y ./ (ldr_c_x.^2);
B = ldr_asm_y ./ (ldr_asm_x.^2);
hold on;
plot(A, ldr_c_y, 'r');
plot(B, ldr_asm_y);
xlabel('Radio','FontSize',12);
ylabel('Tiempo de ejecucion / r^2','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador');
hold off;
print('graficos/exp2-relacion_tiempo_con_radio_cuadrado', filetype);

% Parte B (según sigma)

% Procesado de los datos
[ldr_c_x, ldr_c_y, ldr_c_e, ldr_c_cant] = leer_datos_float('exp2/b-data-ldr-c.txt');
[ldr_asm_x, ldr_asm_y, ldr_asm_e, ldr_asm_cant] = leer_datos_float('exp2/b-data-ldr-asm.txt');

% Impresión de los datos
mkdir('resultados');
file = fopen('resultados/exp2-b.txt', 'w');
formato = '  %8u    %16.2f    %16.2f\n';
encabezado= '     Sigma     Tiempo empleado     Desvío estándar\n';
fprintf(file, 'Experimento 3\n');
fprintf(file, '\n  Implementación: C   Imagen: bastachicos1   Radio: 50   Cant. muestras: %u\n', ldr_c_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_c_x'; ldr_c_y'; ldr_c_e']);
fprintf(file, '\n  Implementación: ASM   Imagen: bastachicos1   Radio: 50   Cant. muestras: %u\n', ldr_asm_cant);
fprintf(file, encabezado);
fprintf(file, formato, [ldr_asm_x'; ldr_asm_y'; ldr_asm_e']);
fclose(file);

% Creación de los gráficos
clf;
set(gca,'FontName', 'FreeSans');

hold on;
errorbar(ldr_c_x, ldr_c_y, ldr_c_e, 'r');
errorbar(ldr_asm_x, ldr_asm_y, ldr_asm_e);
xlabel('Sigma','FontSize',12);
ylabel('Tiempo de ejecucion en ciclos de clock','FontSize',12);
legend('Implementacion en C','Implementacion en ensamblador');
hold off;
print('graficos/exp2-tiempo_segun_sigma', filetype);
