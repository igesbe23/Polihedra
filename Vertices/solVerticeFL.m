function [VerticeMat,EstelaMat] = solVerticeFL(f,l)
EstelaMat = zeros(length(f),length(l));
if f(1)~=0
    for j=1:length(l)
        if l(j)~=0
            EstelaMat(1,j) = 1;
        end
    end
end
if l(end)~=0
    for i=1:length(f)
        if f(i)~=0
            EstelaMat(i,end) = 1;
        end
    end
end
VerticeMat = zeros(length(f),length(l));
VerticeMat(1,:) = l;
VerticeMat(:,length(l)) = f;
VerticeMat(1,length(l)) = f(1)+l(length(l))-sum(f);
i = 1;
j = length(l);
while true
    if VerticeMat(i,j) >= 0
        break
    end
    VerticeMat(i+1,j) = VerticeMat(i+1,j)+VerticeMat(i,j);
    VerticeMat(i,j-1) = VerticeMat(i,j-1)+VerticeMat(i,j);
    VerticeMat(i+1,j-1) = VerticeMat(i+1,j-1)-VerticeMat(i,j);
    VerticeMat(i,j) = 0;

    EstelaMat(i,j) = 0;
    if f(i+1)~=0 && l(j-1)~=0
        EstelaMat(i+1,j-1) = 1;
    end
    % Coordenada i
    itemp = i+1;
    while VerticeMat(itemp,j)<0
        itemp = itemp + 1;
        VerticeMat(itemp,j) = VerticeMat(itemp,j)+VerticeMat(itemp-1,j);
        VerticeMat(itemp,j-1) = VerticeMat(itemp,j-1)-VerticeMat(itemp-1,j);
        VerticeMat(itemp-1,j-1) = VerticeMat(itemp-1,j-1)+VerticeMat(itemp-1,j);
        VerticeMat(itemp-1,j) = 0;
        
        EstelaMat(itemp-1,j) = 0;
        if f(itemp)~=0 && l(j-1)~=0
            EstelaMat(itemp,j-1) = 1;
        end
    end
    % Coordenada j
    jtemp = j-1;
    while VerticeMat(i,jtemp)<0
        jtemp = jtemp - 1;
        VerticeMat(i,jtemp) = VerticeMat(i,jtemp)+VerticeMat(i,jtemp+1);
        VerticeMat(i+1,jtemp+1) = VerticeMat(i+1,jtemp+1)+VerticeMat(i,jtemp+1);
        VerticeMat(i+1,jtemp) = VerticeMat(i+1,jtemp)-VerticeMat(i,jtemp+1);
        VerticeMat(i,jtemp+1) = 0;

        EstelaMat(i,jtemp+1) = 0;
        if f(i+1)~=0 && l(jtemp)~=0
            EstelaMat(i+1,jtemp) = 1;
        end
    end
    if itemp == i && jtemp == j
        break
    end
    i = i+1;
    j = j-1;
end
