f = randi([0,2],[4,1])
l = randi([0,2],[4,1])
if sum(f)-sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f)-sum(l)
else 
    f(length(f)) = f(length(f)) - sum(f)+sum(l)
end
[V,E] = solVerticeFL(f,l);
V
E
