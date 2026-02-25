f = randi([2, 10], [2, 1]);
l = randi([4, 20], [4, 1]);
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
V = [3,1,0,0,0;0,3,1,3,4]
[pos_row, pos_col] = find(V == 0);
% Generar un índice aleatorio
if ~isempty(pos_row)
    idx_aleatorio = randi(length(pos_row));
    posicion_aleatoria = [pos_row(idx_aleatorio), pos_col(idx_aleatorio)];
end
I = posicion_aleatoria
find_balanced_paths(V,I)
G = MalladeVertices(V)
plot(G)