function [RelM,coldict,rowdict,k] = matriz_relaciones(V)
[v,n] = size(V);
%Creamos la matriz de relaciones
RelM = zeros([v,n]);
coldict = containers.Map('KeyType', 'double', 'ValueType', 'any');
rowdict = containers.Map('KeyType', 'double', 'ValueType', 'any');
k=0;
break_cond=false;
for i = 1:v
    for j= 1:n
        if V(i,j)~=0 && RelM(i,j)==0
            arbol = find_tree(V,[i,j]);
            k=k+1;
            for idx=1:length(arbol)
                coord = arbol{idx};
                RelM(coord(1),coord(2))=k;
                coldict(coord(2))=k;
                rowdict(coord(1))=k;
            end
        end
    end
end