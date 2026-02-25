% Dado un p.s.c. de dimension 4 devuelve la constelacion de poliedros
C = input('Dimensiones del arreglo : ');
dimension=1;
r=length(C);
for i=1:r
    dimension=(C(i)-1)*dimension;
end
if dimension ~= 4
    disp('No resulta en un p.s.c. con constelacion 3D, son necesarias 4 dimensiones');
    return;
end
F = input('Intoduce los vectores de suma constante : ');
if length(F)~=r
    disp('El numero de vectores de suma constante no coincide con el arreglo');
    return;
end
%Compruebo que los vectores de suma nula son compatibles
for i=1:r-1
    for j=(i+1):r
        suma=0;
        for i_1=1:C(i)
            indices = [j; ones(i_1-1,1); i_1; ones(r-i_1,1)];
            suma = suma + F(indices{:});
        end
        for i_2=1:C(j)
            indices = [i; ones(i_2,1); i_2; ones(r-i_2-1,1)];
            suma = suma - F(indices{:});
        end
        if suma~=0
            disp('Vectores suma no compatibles')
            return;
        end
    end
end
%Construyo la matriz de coeficientes, para ello debo ordenar los índices
%del arreglo
%Podemos utilizar el orden lexicografico
dimension_entorno = prod(C);
A=zeros(dimension_entorno);

for i=1:r
    
end
vertices = encontrar_soluciones_basicas(A,b);
return;