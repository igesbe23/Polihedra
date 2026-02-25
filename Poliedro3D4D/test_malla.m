clear
n = 8;
m = 2;
f = randi([0,4], [n, 1]);
l = [4,4,24];
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
l
f
[V,E1] = solVerticeFL(f,l)
G=MalladeVertices(V);
plot(G, 'Layout', 'force');