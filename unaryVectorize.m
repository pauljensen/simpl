function Y = unaryVectorize(f,A,constructor)

if nargin < 3
    constructor = @zeros;
end

[m,n] = size(A);
Y = constructor(m,n);
for j = 1:n
    for i = 1:m
        Y(i,j) = f(A(i,j));
    end
end
