function A = find_tree(V,I)
A = {};
[v,n]=size(V);
queue = {I};
while isempty(queue)==0
    newqueue = {};
    for p=1:length(queue)
        current_coord = queue{p};
        A{end+1} = current_coord;
        for i=1:v
            if V(i,current_coord(2))~=0 && ~any(cellfun(@(x) isequal(x, [i,current_coord(2)]), A))
                newqueue{end+1}=[i,current_coord(2)];
            end
        end
        for j=1:n
            if V(current_coord(1),j)~=0 && ~any(cellfun(@(x) isequal(x, [current_coord(1),j]), A))
                newqueue{end+1}=[current_coord(1),j];
            end
        end
    end
    queue = newqueue;
end