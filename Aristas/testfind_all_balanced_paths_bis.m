clear
n = 15;
m = 10;
f = randi([1, 4], [n, 1]);
l = randi([2, 4], [m, 1]);
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
[V,E] = solVerticeFL(f,l);
V

A = find_all_balanced_paths_bis(V);
%for r=1:length(A)
 %   A{r}
%end