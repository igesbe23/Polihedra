clear
n = 8;
m = 5;
f = [8,4,4,4,4,4,4,8];
l = [4,4,4,4,24];
if sum(f) - sum(l) >= 0
    l(length(l)) = l(length(l)) + sum(f) - sum(l);
else
    f(length(f)) = f(length(f)) - sum(f) + sum(l);
end
[V,E] = solVerticeFL(f,l);
V

A = find_aristas(V)
A{1,1}
B=zeros(n*m,length(A));
for i=1:length(A)
    B(:,i)=A{1,i}(:)';
end
b=rank(B)