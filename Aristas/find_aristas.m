function A = find_aristas(V)
[RelM,coldict,rowdict,k] = matriz_relaciones(V);
[v,n] = size(V);
Visited = zeros([v,n]);
nullgrup = containers.Map('KeyType','double','ValueType','any');
A={};
for i=1:v
    for j=1:n
        if V(i,j) == 0 && isKey(coldict,j) && isKey(rowdict,i)
            if coldict(j)==rowdict(i)
                A{end+1}=find_balanced_paths(V,[i,j]);
            else
                %Tenemos ahora que recorrer todas las POSIBLES formas de
                %llegar a ij partiendo de ij, en particular partimos por la
                %columna
                paths = {}; % Lista de caminos activos: {[camino, última coordenada], ...}
    
                % Inicializa el primer camino con el punto inicial
                initial_path = zeros(v, n);
                initial_path(i,j) = 1; % Marca la posición inicial con un 1
                I = [i,j];
    
                for l=1:k
                    nullgrup(l)=true;
                end
    
                paths{end + 1} = {initial_path, I, 1,nullgrup}; 
                % Incluye camino, coordenadas, paridad y grupos prohibidos
                
                while isempty(paths) == 0
                    new_paths = {}; % Nuevos caminos generados en esta 
                    % iteración
                    % Procesa cada camino activo
                    for p = 1:length(paths)
                        current_path_data = paths{p};
                        current_path = current_path_data{1};
                        last_coords = current_path_data{2}; % Coordenadas del último cambio
                        current_parity = current_path_data{3};
                        current_nullgrup = current_path_data{4};
                
                        ii = last_coords(1);
                        jj = last_coords(2);
                
                        % Expandir por fila
                        if mod(current_parity, 2) == 1 % Paso impar
                            for col = 1:n
                                if ii == I(1) && col == I(2) && (-2*mod(current_parity, 2)+1==1)
                                    result = current_path;
                                    A{end+1} = result;
                                elseif current_path(ii, col) == 0 
                                    if V(ii, col) ~= 0
                                        % Crear un nuevo camino
                                        new_path = current_path;
                                        new_path(ii, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                        new_nullgroup = copyMap(current_nullgrup);
                                        new_nullgroup(coldict(col))=false;
    
                                        % Agregar a la lista de nuevos caminos
                                        new_paths{end + 1} = {new_path, [ii, col], current_parity + 1,new_nullgroup};
                                    elseif -2*mod(current_parity, 2)+1==1 && current_nullgrup(coldict(col)) && ~Visited(ii,col)
                                        % Crear un nuevo camino
                                        new_path = current_path;
                                        new_path(ii, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                        new_nullgroup = copyMap(current_nullgrup);
                                        new_nullgroup(coldict(col))=false;
                    
                                        % Agregar a la lista de nuevos caminos
                                        new_paths{end + 1} = {new_path, [ii, col], current_parity + 1,new_nullgroup};
                                    end
                                end
                            end
                        end
                
                        % Expandir por columna
                        if mod(current_parity, 2) == 0 % Paso par
                            for row = 1:v
                                if row == I(1) && jj == I(2) && (-2*mod(current_parity, 2)+1==1)
                                    result = current_path;
                                    A{end+1} = result;
                                elseif current_path(row, jj) == 0
                                    if V(row, jj) ~= 0
                                        % Crear un nuevo camino
                                        new_path = current_path;
                                        new_path(row, jj) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                        new_nullgroup = copyMap(current_nullgrup);
                                        new_nullgroup(rowdict(row))=false;
                    
                                        % Agregar a la lista de nuevos caminos
                                        new_paths{end + 1} = {new_path, [row, jj], current_parity + 1,new_nullgroup};
                                    elseif -2*mod(current_parity, 2)+1==1 && current_nullgrup(rowdict(row)) && ~Visited(row,jj)
                                        % Crear un nuevo camino
                                        new_path = current_path;
                                        new_path(row, jj) = -2*mod(current_parity, 2)+1; % Alterna paridad
                                        new_nullgroup = copyMap(current_nullgrup);
                                        new_nullgroup(rowdict(row))=false;
                    
                                        % Agregar a la lista de nuevos caminos
                                        new_paths{end + 1} = {new_path, [row, jj], current_parity + 1,new_nullgroup};
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
        Visited(i,j) = 1;
    end
end
            
            



