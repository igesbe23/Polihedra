function result = arista_PrimerasAristas(V, I,rows_nulas,cols_nulas)
% Verifica que la entrada es válida
if V(I(1), I(2)) ~= 0
    error('La posición inicial (i, j) debe contener un 0.');
end

[v, n] = size(V);
paths = {}; % Lista de caminos activos: {[camino, última coordenada], ...}
result = zeros(v, n); % Matriz de resultado final

% Inicializa el primer camino con el punto inicial
initial_path = zeros(v, n);
initial_path(I(1), I(2)) = 1; % Marca la posición inicial con un 1
paths{end + 1} = {initial_path, I, 1}; % Incluye camino, coordenadas y paridad

while isempty(paths) == 0
    new_paths = {}; % Nuevos caminos generados en esta iteración
    % Procesa cada camino activo
    for p = 1:length(paths)
        current_path_data = paths{p};
        current_path = current_path_data{1};
        last_coords = current_path_data{2}; % Coordenadas del último cambio
        current_parity = current_path_data{3};

        i = last_coords(1);
        j = last_coords(2);

        % Expandir por fila
        if mod(current_parity, 2) == 1 % Paso impar
            for col = 1:n
                if i == I(1) && col == I(2) && (-2*mod(current_parity, 2)+1==1)
                    result = current_path;
                    return
                elseif V(i, col) ~= 0 && current_path(i, col) == 0
                    % Crear un nuevo camino
                    new_path = current_path;
                    new_path(i, col) = -2*mod(current_parity, 2)+1; % Alterna paridad

                    % Agregar a la lista de nuevos caminos
                    new_paths{end + 1} = {new_path, [i, col], current_parity + 1};
                end
            end
        end

        % Expandir por columna
        if mod(current_parity, 2) == 0 % Paso par
            for row = 1:v
                if row == I(1) && j == I(2) && (-2*mod(current_parity, 2)+1==1)
                    result = current_path;
                    return
                elseif V(row, j) ~= 0 && current_path(row, j) == 0
                    % Crear un nuevo camino
                    new_path = current_path;
                    new_path(row, j) = -2*mod(current_parity, 2)+1; % Alterna paridad

                    % Agregar a la lista de nuevos caminos
                    new_paths{end + 1} = {new_path, [row, j], current_parity + 1};
                end
            end
        end
    end

    % Actualiza caminos
    paths = new_paths;
end
return