% Dimensiones de las matrices
n = 2;
m = 5;
frontera_i = randi([1, n-1]);
frontera_j = randi([1, m-1]);
max_val = 10; % Valor máximo en la matriz
Ejes = [1,1;1,2;1,3;1,4];
f = randi([15, 30], [n, 1]);
l = randi([15, 30], [m, 1]);
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
M = [1,3,3,1,0;0,0,0,2,7]

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

% Definir el rango para las coordenadas y t4
t_range = -2*max_val:2*max_val;
x_vals = -2*max_val:2*max_val;
y_vals = -2*max_val:2*max_val;
z_vals = -2*max_val:2*max_val;

vertices = {}; % Lista para almacenar los vértices del trapezoide hiperdimensional
% Bucle infinito para la animación
while true
    % Bucle sobre los valores de t4
    for t4 = t_range
        % Limpiar la gráfica
        cla;

        % Inicializar listas para almacenar puntos y colores
        X = [];
        Y = [];
        Z = [];
        colors = [];
        results = {};  % Lista para almacenar las matrices resultantes de cada punto

        % Iterar sobre todos los posibles valores de x, y, z
        for x = x_vals
            for y = y_vals
                for z = z_vals
                    % Calcular la matriz resultante al sumar
                    mat_x = Array{Ejes(1,1), Ejes(1,2)};
                    mat_y = Array{Ejes(2,1), Ejes(2,2)};
                    mat_z = Array{Ejes(3,1), Ejes(3,2)};
                    mat_w = Array{Ejes(4,1), Ejes(4,2)};
                    
                    % Calcular la matriz resultante
                    result = M + x*mat_x + y*mat_y + z*mat_z + t4*mat_w;

                    % Determinar la condición de la matriz resultante
                    Neg = 0;
                    esvertice = 1;
                    if all(result(:) > 0) && all(mod(result(:), 1) == 0)  % Naturales (sin 0 ni negativos)
                        color = [1, 1, 0];  % Amarillo
                    elseif any(result(:) < 0)  % Contiene negativos
                        if all(result(:) ~= 0)
                            Neg = 1;
                        else
                            if result(frontera_i+1, frontera_j) == 0
                                color = [0, 0.5, 0.5];  % Azul claro
                                Neg = 1;
                            elseif result(frontera_i, frontera_j+1) == 0
                                color = [0, 1, 0];  % Verde Lima
                                Neg = 1;
                            else
                                Neg = 1;
                                color = [0, 0, 0.5]; % Azul oscuro
                            end
                            if nnz(result) <= (n+m-1)
                                color = [0.5, 0, 0.5]; % Rosa
                            else
                                
                            end
                            if result(1,1) == 0 
                                color = [0, 1, 1]; % Cian
                            elseif result(n, m) == 0
                                color = [1, 0.5, 0]; % Naranja
                            end
                        end
                    else  % Naturales incluyendo 0
                        color = [1, 0, 0];  % Rojo
                        if nnz(result) <= (n+m-1)
                            esvertice = 0;
                            color = [0.5, 0, 0.5]; % Rosa
                        end
                    end
                    
                    % Agregar el punto y su color a las listas si no es negativo
                    if Neg == 0
                        X = [X, x];
                        Y = [Y, y];
                        Z = [Z, z];
                        colors = [colors; color];
                        results{end+1} = result;  % Guardar la matriz result
                        if esvertice == 0
                            esvertice = 1;
                            % Verificar si el vértice ya está en la lista
                            ya_existe = any(cellfun(@(v) isequal(v, result), vertices));
                            if ~ya_existe
                                vertices{end+1} = result;  % Añadir a la lista si no existe
                            end
                        end
                    end
                end
            end
        end

        % Crear la gráfica de dispersión 3D
        scatter3(X, Y, Z, 100, colors, 'filled');

        % Configurar la gráfica
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title(['Gráfica de Dispersión 3D - t4 = ', num2str(t4)]);
        grid on;
        view(3);
        pause(0.5); % Pausa para la animación
    end
end