n=2;
m=4;
frontera_i=randi([1,n-1])
frontera_j=randi([1,m-1])
max = 40; % Valor máximo en la matriz
Ejes = [1,1;1,2;1,3];
f = randi([75,90],[n,1])
l = randi([65,80],[m,1])
if sum(f)-sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f)-sum(l)
else 
    f(length(f)) = f(length(f)) - sum(f)+sum(l)
end
M = randi([20,30],2,4)
%%Creo los vectores unitarios
Unit = [1,-1;-1,1];
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
%Hacemos el visual de 3D escogiendo unos ejes arbitrarios
% Definir el rango para x, y, z
max_val = 2*max; % Define el límite superior para x, y, z
x_vals = -max_val:max_val;
y_vals = -max_val:max_val;
z_vals = -max_val:max_val;

% Inicializar listas para almacenar puntos y colores
X = [];
Y = [];
Z = [];
colors = [];
results = {};  % Lista para almacenar las matrices resultantes de cada punto
vertices = {}; % Lista para almacenar los vértices del trapezoide hiperdimensional

% Iterar sobre todos los posibles valores de x, y, z
for x = x_vals
    for y = y_vals
        for z = z_vals
            % Calcular la matriz resultante al sumar
            % Seleccionar las matrices a sumar del Array usando Ejes
            mat_x = Array{Ejes(1,1), Ejes(1,2)};
            mat_y = Array{Ejes(2,1), Ejes(2,2)};
            mat_z = Array{Ejes(3,1), Ejes(3,2)};
            
            % Calcular la matriz resultante
            result = M + x*mat_x + y*mat_y + z*mat_z;
            % Determinar la condición de la matriz resultante
            Neg = 0;
            esvertice = 1;
            if all(result(:) > 0) && all(mod(result(:), 1) == 0)  % Naturales (sin 0 ni negativos)
                color = [1, 1, 0];  % Amarillo
            elseif any(result(:) < 0)  % Contiene negativos
                if all(result(:) ~= 0)
                    Neg = 1;
                else
                    if result(frontera_i+1,frontera_j)==0
                        color = [0, 0.5, 0.5];  % Azul claro
                    elseif result(frontera_i,frontera_j+1)==0
                        color = [0, 1, 0];  % Verde Lima
                    else
                        color = [0, 0, 0.5]; %Azul oscuro
                    end
                    if nnz(result) <= (n+m-1)
                        esvertice = 0;
                        color = [0.5,0,0.5]; %Rosa
                    end
                end
            else  % Naturales incluyendo 0
                color = [1, 0, 0];  % Rojo
                if nnz(result) <= (n+m-1)
                    esvertice = 0;
                    color = [0.5,0,0.5]; %Rosa
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
                    vertices{end+1} = result;
                end
            end
        end
    end
end

% Crear la gráfica de dispersión 3D
fig = scatter3(X, Y, Z, 100, colors, 'filled');

% Configurar la gráfica
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Gráfica de Dispersión 3D con Colores Dependientes de la Matriz Resultante');
grid on;

% Habilitar el modo interactivo de cursor
dcm = datacursormode(gcf);  % Cambiar fig por gcf, que obtiene la figura activa
datacursormode on;

% Definir el callback para mostrar la matriz 'result' cuando se selecciona un punto
set(dcm, 'UpdateFcn', @(src, event) displayResult(src, event, X, Y, Z, results));

% Función callback para mostrar la matriz result cuando el cursor se posa sobre un punto
function txt = displayResult(~, event, X, Y, Z, results)
    % Obtener las coordenadas del punto seleccionado
    idx = event.DataIndex;  % Usamos el índice de datos del evento

    % Obtener la matriz result correspondiente a ese índice
    result = results{idx};

    % Convertir la matriz result a texto para mostrar
    txt = sprintf('Matriz Resultante:\n');
    txt = [txt, mat2str(result, 3)];  % Mostrar la matriz con 3 decimales
end

