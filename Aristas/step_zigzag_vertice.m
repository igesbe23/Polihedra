function [Z,P,B,I] = step_zigzag_vertice(Z,P,I)
[n,m] = size(Z);
B = 0;

% Encontrar un elemento no nulo sin más elementos no nulos en su columna
found = false;
for j = I(1):m
    for i = I(2):n
        if Z(i,j) ~= 0
            if sum(Z(i:n,j) ~= 0) == 1
                % Se encontró el elemento que cumple la condición
                row = i; % Fila del elemento
                col = j; % Columna del elemento
                found = true;
                break;
            else 
                break;
            end
        end
    end
    if found
        break;
    end
end

% Si no, Encontrar un elemento no nulo sin más elementos no nulos en su
% fila
if ~found
    for i = I(2):n
        for j = I(1):m
            if Z(i,j) ~= 0
                if sum(Z(i,j:m) ~= 0) == 1
                    % Se encontró el elemento que cumple la condición
                    row = i; % Fila del elemento
                    col = j; % Columna del elemento
                    found = true;
                    I(2)=I(2)-1;
                    break;
                else 
                    break;
                end
            end
        end
        if found
            break;
        end
    end
end

% Permutar la fila y columna para llevar el elemento a la posición (1,1)
Z([I(1), row], :) = Z([row, I(1)], :); % Intercambiar filas
P([I(1), row], :) = P([row, I(1)], :);
Z(:, [I(2), col]) = Z(:, [col, I(2)]); % Intercambiar columnas
P(:, [I(2), col]) = P(:, [col, I(2)]);

if sum(Z(row,I(2):m) ~= 0) == 1
    B=1;
    I(1) = I(1)+1;
end
if sum(Z(I(1):n,col) ~= 0) == 1
    B=1;
    I(2) = I(2)+1;
end

% Mostrar la matriz resultante
disp('La matriz resultante es:');
disp(Z);
disp(P);