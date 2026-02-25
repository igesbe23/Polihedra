



function A = find_all_balanced_paths_bis(V)
[v, n] = size(V);
A = {};
row_nul = zeros([v,1]);
col_nul = zeros([n,1]);
row_start = zeros([n,1]);
col_start = zeros([v,1]);
for i=1:v-1
    for j=1:n-1
        if V(i,j)~=0 && V(i+1,j)==0 && V(i,j+1)==0
            row_nul(i)=1;
            col_start(i)=j;
            col_nul(j)=1;
            row_start(j)=i;
        end
    end
end

for i1=1:v
    for j1=1:n
        I=[i1,j1];
        % Verifica que la entrada es válida
        if V(I(1), I(2)) ~= 0
            continue
        end   

        % No contar las columnas debajo de elementos críticos para evitar
        % duplicidades en el output
        if col_nul(I(2)) && I(1)>row_start(I(2))
            continue
        end
        
        paths = {}; % Lista de caminos activos: {[camino, última coordenada], ...}
    
        % Inicializa el primer camino con el punto inicial
        initial_path = zeros(v, n);
        initial_path(I(1), I(2)) = 1; % Marca la posición inicial con un 1
        
        paths{end + 1} = {initial_path, I, 1,zeros(v),zeros(n)}; 
        % Incluye camino, coordenadas, paridad y filas y columnas prohibidas
        
        while isempty(paths) == 0
            new_paths = {}; % Nuevos caminos generados en esta iteración
            % Procesa cada camino activo
            for p = 1:length(paths)
                current_path_data = paths{p};
                current_path = current_path_data{1};
                last_coords = current_path_data{2}; % Coordenadas del último cambio
                current_parity = current_path_data{3};
                current_nulrow = current_path_data{4};
                current_nulcol = current_path_data{5};
        
                i = last_coords(1);
                j = last_coords(2);
        
                % Expandir por fila
                if mod(current_parity, 2) == 1 % Paso impar
                    for col = 1:n
                        if i == I(1) && col == I(2) && (-2*mod(current_parity, 2)+1==1)
                            result = current_path;
                            A{end+1} = result;
                        elseif current_path(i, col) == 0
                            if V(i, col) ~= 0
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(i, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [i, col], current_parity + 1,current_nulrow,current_nulcol};
                            elseif -2*mod(current_parity, 2)+1==1 && row_nul(i) && current_nulrow(i)==0 && col>=col_start(i)
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(i, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                new_nulrow = current_nulrow;
                                new_nulrow(i) = 1;
                                new_nulcol = current_nulcol;
                                new_nulcol(col_start(i)) = 1;
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [i, col], current_parity + 1,new_nulrow,new_nulcol};
                            elseif -2*mod(current_parity, 2)+1==1 && col_nul(col) && current_nulcol(col)==0 && i>=row_start(col)
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(i, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                new_nulcol = current_nulcol;
                                new_nulcol(col) = 1;
                                new_nulrow = current_nulrow;
                                new_nulrow(row_start(col)) = 1;
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [i, col], current_parity + 1,new_nulrow,new_nulcol};
                            end
                        end
                    end
                end
        
                % Expandir por columna
                if mod(current_parity, 2) == 0 % Paso par
                    for row = 1:v
                        if row == I(1) && j == I(2) && (-2*mod(current_parity, 2)+1==1)
                            result = current_path;
                            A{end+1} = result;
                        elseif current_path(row, j) == 0
                            if V(row, j) ~= 0
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(row, j) = -2*mod(current_parity, 2)+1; % Alterna paridad
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [row, j], current_parity + 1,current_nulrow,current_nulcol};
                            elseif -2*mod(current_parity, 2)+1==1 && col_nul(j) && current_nulcol(j)==0 && row>=row_start(j)
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(row, j) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                new_nulcol = current_nulcol;
                                new_nulcol(j) = 1;
                                new_nulrow = current_nulrow;
                                new_nulrow(row_start(j)) = 1;
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [row, j], current_parity + 1,new_nulrow,new_nulcol};
                            elseif -2*mod(current_parity, 2)+1==1 && row_nul(row) && current_nulrow(row)==0 && j>=col_start(row)
                                % Crear un nuevo camino
                                new_path = current_path;
                                new_path(row, j) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                new_nulrow = current_nulrow;
                                new_nulrow(row) = 1;
                                new_nulcol = current_nulcol;
                                new_nulcol(col_start(row)) = 1;
            
                                % Agregar a la lista de nuevos caminos
                                new_paths{end + 1} = {new_path, [row, j], current_parity + 1,new_nulrow,new_nulcol};
                            end
                        end
                    end
                end
            end
        
            % Actualiza caminos
            paths = new_paths;
        end
    end
end
