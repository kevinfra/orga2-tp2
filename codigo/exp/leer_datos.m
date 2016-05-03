function [x, y, e, c] = leer_datos(file)
    data = fopen(file);
    c = fscanf(data, '%lu', 1);
    cant = c + 1;
    A = fscanf(data, '%lu', [cant Inf]);
    A = A';
    [Y, I] = sort(A(1,:)); % ordenamos A de acuerdo a su primer columna
    A = A(:,I);

    x = A(:,1);
    d = A;
    d(:,1) = [];
    y = mean(d, 2);
    e = std(d, 1, 2);

    fclose(data);
end
