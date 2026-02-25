CODIGO RECHAZADO 
Malla: 
elseif E(i,col) ~= 0 && current_path(i, col) == 0 && 1 == -2*mod(current_parity, 2)+1
                        % Crear un nuevo camino
                        new_path = current_path;
                        new_path(i, col) = -2*mod(current_parity, 2)+1; % Alterna paridad
    
                        % Agregar a la lista de nuevos caminos
                        new_paths{end + 1} = {new_path, [i, col], current_parity + 1};



                        if V(i,j) == 0
            xmax = i;
            while V(xmax,j) ~= 0
                xmax = xmax+1;
            end
            ymin = j;
            while V(i,ymin) ~= 0
                ymin = ymin-1;
            end
            if p==n
                
                for k = ymin:j-1
                    if col_nul(k)
                        Cond
                    end
                end
            else
                for k = i:xmax
                    if row_nulas_indeces(k)==1
                        count = count+1;
                    end
                end
            end
            if Cond
                Z = zeros([v,n]);
                Z(i:xmax,ymin:j) = find_balanced_paths(V(i:xmax,ymin:j),[1,j-ymin]);
                A{end+1} = Z;
                continue
            else
                
            end
        end