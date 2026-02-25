function G = MalladeVertices(V)
G = graph();
G = addnode(G,1);
G.Nodes.Data{1} = {V};
%V es un vértice
[rows,cols]=size(V);
result = {};
result{end+1}={V,1};

% Bucle principal
p = 1;  % Comenzamos con el primer índice de result
while p <= length(result)
    result_data = result{p};
    W = result_data{1};
    Aristas_W = find_aristas(W);
    for k=1:length(Aristas_W)
        vector_arista = Aristas_W{k};
        min_value = Inf;
        
        % Buscar el valor mínimo entre los elementos no nulos
        for i1 = 1:rows
            for j1 = 1:cols
                if vector_arista(i1, j1) == -1
                    if W(i1, j1) < min_value
                        min_value = W(i1, j1);
                    end
                end
            end
        end
        if min_value == Inf
            continue
        end
        % Crear el nuevo vector V actualizado
        new_V = W + vector_arista * min_value;
       
        % Comprobar si el nuevo vector ya está en result
        if ~any(cellfun(@(x) isequal(x{1}, new_V), result))
            % Si no está presente, añádelo 
            result{end + 1} = {new_V};
            G = addnode(G, 1);  % Añadir un nuevo nodo al grafo
            G.Nodes.Data{end} = {new_V};

            % Conectar el nuevo nodo con el nodo anterior
            G = addedge(G,p,numnodes(G));
        else
            % Si ya está presente, encuentra el índice del nodo correspondiente
            q = find(cellfun(@(x) isequal(x{1}, new_V), G.Nodes.Data));
            % Verificar si la arista ya existe
            edgeIndex = findedge(G,p,q);
            
            if edgeIndex == 0
                % La arista no existe, añadirla
                G = addedge(G,p,q);
            % Conectar el nodo p con el nodo q
            end
        end
    end
    p=p+1;
end
