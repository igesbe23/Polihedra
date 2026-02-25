clear
n = 2;
m = 5;
f = randi([104, 138], [n, 1]);
l = randi([15, 45], [m, 1]);
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
f=[122;115]
l=[20;21;43;35;118]
[V,E1] = solVerticeFL(f,l)
[pos_row, pos_col] = find(V == 0);
% Generar un índice aleatorio
if ~isempty(pos_row)
    idx_aleatorio = randi(length(pos_row));
    posicion_aleatoria = [pos_row(idx_aleatorio), pos_col(idx_aleatorio)];
end
I = posicion_aleatoria
find_balanced_paths(V,I)
G = MalladeVertices(V); %Devuelve un grafo con las matrices en Node.Data

%Ejes
Ejes = [1,1;1,2;1,3;1,4];

% Crear los vectores unitarios
Unit = [1, -1; -1, 1];

% Crear un array de celdas para almacenar las matrices
Array = cell(n-1, m-1);

% Generar y almacenar cada matriz E en el array de celdas
for i = 1:(n-1)
    for j = 1:(m-1)
        % Crear una matriz E llena de ceros de tamaño (n x m) para cada posición (i, j)
        E = zeros(n, m);
        
        % Insertar Unit en las posiciones (i,j), (i+1,j), (i,j+1), (i+1,j+1) de E
        E(i:i+1, j:j+1) = Unit;
        
        % Guardar la matriz E en el array de celdas
        Array{i, j} = E;
    end
end

mat_x = Array{Ejes(1,1), Ejes(1,2)};
mat_y = Array{Ejes(2,1), Ejes(2,2)};
mat_z = Array{Ejes(3,1), Ejes(3,2)};
mat_w = Array{Ejes(4,1), Ejes(4,2)};
% Inicializar listas para almacenar puntos y colores
X = [];
Y = [];
Z = [];
W = [];
results = {};

for k = 1:length(G.Nodes.Data)
    NodesDatak = G.Nodes.Data{k};
    NodesDatak{1}
    R = NodesDatak{1}-V;
    X = [X,producto_escalar(R,mat_x)];
    Y = [Y,producto_escalar(R,mat_y)];
    Z = [Z,producto_escalar(R,mat_z)];
    W = [W,producto_escalar(R,mat_w)];
    results{end+1} = {NodesDatak{1}};
end
% Verifica el contenido de W
if ~isnumeric(W) || isempty(W)
    error('El vector W debe ser numérico y no vacío.');
end

% Elimina valores NaN de W si existen
W = W(~isnan(W));

% Verifica si W está vacío después de eliminar NaN
if isempty(W)
    error('W está vacío después de eliminar valores NaN.');
end

% Normaliza los valores al rango [0, 1]
min_W = min(W);
max_W = max(W);

if min_W == max_W
    % Si todos los valores son iguales
    W_normalizados = zeros(size(W)); % Normaliza a cero
else
    W_normalizados = (W - min_W) / (max_W - min_W);
end

% Escoge un colormap (por ejemplo, jet)
colormap_escala = colormap(gray);

% Asigna colores basados en los valores normalizados
n_colores = size(colormap_escala, 1); % Número de colores en el colormap
indices_colores = round(W_normalizados * (n_colores - 1)) + 1;

% Ajusta los índices para que sean válidos (enteros positivos)
indices_colores = max(min(indices_colores, n_colores), 1);

% Vector de colores (RGB)
colores = colormap_escala(indices_colores, :);
% Crear la gráfica de dispersión 3D
fig = scatter3(X, Y, Z, 100, colores, 'filled');
sensibilidad_color = 0.03;
g=0;

while true
    g = g+sensibilidad_color;
    if g>1
        g=0;
    end
    cla
    x_convex = [];
    y_convex = [];
    z_convex = [];
    color_convex = {};

    % Configurar la gráfica
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Gráfica de Dispersión 4D con Colores Dependientes de los Vértices');
    grid on;
    hold on;
    % Add text labels for each vertex
    for k = 1:length(G.Nodes.Data)
        % Get the matrix for this vertex
        mat = G.Nodes.Data{k}{1};
        
        % Format the matrix as a string
        mat_str = '[';
        for i = 1:size(mat,1)
            row_str = sprintf('%d ', mat(i,:));
            mat_str = [mat_str(1:end-1) row_str(1:end-1) '; '];
        end
        mat_str = [mat_str(1:end-2) ']'];
        
        % Add text slightly offset from the vertex
        text(X(k), Y(k), Z(k)+0.1, mat_str, ...
            'FontSize', 8, 'Color', 'k', ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    end
    % Obtener las aristas del grafo G
    edges = G.Edges.EndNodes; % Aristas como pares [source, target]
    %Dibujar los solidos sucesivos
   

    % Trazar las aristas con gradiente de colores
    for k = 1:height(edges)
        % Obtener los índices de los vértices conectados
        v1 = edges(k, 1);
        v2 = edges(k, 2);
        
        % Coordenadas de los vértices conectados
        x1 = X(v1); y1 = Y(v1); z1 = Z(v1);
        x2 = X(v2); y2 = Y(v2); z2 = Z(v2);
        
        % Colores de los vértices conectados
        c1 = colores(v1, :); % RGB del vértice v1
        c2 = colores(v2, :); % RGB del vértice v2
        
        % Crear interpolación de colores
        num_points = 20; % Número de puntos para suavizar el gradiente
        t = linspace(0, 1, num_points)';
        interpolated_colors = c1 .* (1 - t) + c2 .* t;
        
        % Coordenadas interpoladas para la arista
        x_interp = linspace(x1, x2, num_points);
        y_interp = linspace(y1, y2, num_points);
        z_interp = linspace(z1, z2, num_points);
        
        % Dibujar la arista como una línea con colores gradientes
        for i = 1:num_points - 1
            plot3(x_interp(i:i+1), y_interp(i:i+1), z_interp(i:i+1), '-', ...
                'Color', interpolated_colors(i, :), 'LineWidth', 2);
        end
        
        for i = 1:num_points - 1
            if abs(abs(interpolated_colors(i, :))/(sqrt(3))-g) < sensibilidad_color
                x_convex(end+1) = x_interp(i);
                y_convex(end+1) = y_interp(i);
                z_convex(end+1) = z_interp(i);
                color_convex{end+1} = interpolated_colors(i,:);
            end
        end
    end
    if length(x_convex)>3
        K = convhull(x_convex,y_convex,z_convex,'simplify',true);
        % Convertir el cell array de colores en una matriz numérica Nx3
        color_convex_matrix = cell2mat(color_convex');
        % Dibujar la superficie
        trisurf(K, x_convex, y_convex, z_convex, 'FaceVertexCData', color_convex_matrix, 'FaceColor', 'interp');
    end
    % Habilitar el modo interactivo de cursor
    dcm = datacursormode(gcf);  % Cambiar fig por gcf, que obtiene la figura activa
    datacursormode on;
    
    % Definir el callback para mostrar la matriz 'result' cuando se selecciona un punto
    set(dcm, 'UpdateFcn', @(src, event) displayResult(src, event, X, Y, Z, results));
    
    hold off; % Finalizar la superposición de gráficos
    pause(0.5); % Pausa para la animación
end

% Función callback para mostrar la matriz result cuando el cursor se posa sobre un punto
function txt = displayResult(~, event, X, Y, Z, results)
    % Obtener las coordenadas del punto seleccionado
    idx = event.DataIndex;  % Usamos el índice de datos del evento

    % Obtener la matriz result correspondiente a ese índice
    result = results{idx};

    % Convertir la matriz result a texto para mostrar
    txt = sprintf('Matriz Resultante:\n');
    txt = [txt, mat2str(result{1}, 3)];  % Mostrar la matriz con 3 decimales
end

%Podemos sacar unas coordenadas rotadas y estiradas respecto del sistema de referencia
%estándar con un producto escalar rudimentario 
function result = producto_escalar(M,N)
    result = 0;
    for i=1:size(M,1)
        for j=1:size(M,2)
            result = result + M(i,j)*N(i,j);
        end
    end
end