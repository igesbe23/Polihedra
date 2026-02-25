function PrimerasAristas_bis(V,E)
[v,n] = size(V);
p = min(v,n);
A={};
%V no ha de contener ni filas ni columnas nulas

%Primer bucle para cosas interesantes
row_nul = zeros(v);
col_nul = zeros(n);
row_start = zeros(n);
col_start = zeros(v);
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

%Por Is
for i=1:v
    for j=1:n
        
    end
end