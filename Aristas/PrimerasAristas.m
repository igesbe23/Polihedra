function A = PrimerasAristas(V,E)
%El par V,E es obtenido por solVerticeFL, V tiene que ser zig-zag
A = {};
[v,n] = size(V);

Ceros_ld = {};

%Obtener las posiciones críticas en el zig-zag
for i=1:v
    for j=1:n
        if V(i,j) ~=0
            if V(min([i+1,v]),j)==0 && V(i,min([j+1,n]))==0
                coordenadas = zeros(2,v-i+n-j);
                coordenadas(1,1:v-i) = i+1:v;
                coordenadas(1,v-i+1:v-i+n-j) = i;
                coordenadas(2,1:v-i) = j;
                coordenadas(2,v-i+1:v-i+n-j) = j+1:n;
                Ceros_ld{end+1} = coordenadas;   
            end
        end
    end
end

if isempty(Ceros_ld)
    for i=1:v
        for j=1:n
            if V(i,j) == 0
                A{end+1} = find_balanced_paths(V,[i,j]);
            end
        end
    end
    return
end

% Comprobamos que Ceros_ld no contenga listas vacías
if any(cellfun(@isempty, Ceros_ld))
    disp('Ceros_ld contiene listas vacías.');
end

% Número de listas en Ceros_ld
num_listas = numel(Ceros_ld);

% Inicializar celda para los rangos de índices
ranges = cell(1, num_listas);

% Generar los rangos de índices para cada lista
for i = 1:num_listas
    ranges{i} = 1:size(Ceros_ld{i}, 2);  % Rango de las columnas (cada columna es una coordenada)
end

% Usar ndgrid para generar combinaciones de índices
[combinaciones{1:num_listas}] = ndgrid(ranges{:});  % Asignar la salida de ndgrid explícitamente

% Convertir las combinaciones a formato usable (convertir las celdas a una matriz)
combinaciones = cell2mat(cellfun(@(x) x(:), combinaciones, 'UniformOutput', false));

% Recorrer todas las combinaciones
for k = 1:size(combinaciones, 1)
    % Obtener las coordenadas correspondientes a la combinación actual
    eleccion = arrayfun(@(i) Ceros_ld{i}(:,combinaciones(k, i)), 1:num_listas, 'UniformOutput', false);
    V_temp = V;
    for r = 1:numel(eleccion)
        % Asignar valor 1 en las posiciones seleccionadas
        V_temp(eleccion{r}(1,:), eleccion{r}(2,:)) = 1;
    end
    for i=1:v
        for j=1:n
            if V_temp(i,j) == 0
                A{end+1} = find_balanced_paths(V_temp,[i,j]);
            end
        end
    end
end
return
