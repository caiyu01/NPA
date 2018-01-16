function [ v ] = counting(n,k,r)
% generate the matrix v
% whose rows are all possible combination of 
% length k words from alphabet 1 to n;
% optional argument (vector) r, outputs the r th element of v
% written by Cai Yu, credit to Ernest Tan for tips 2016-9-7

if n^k>1e6
    error('not very efficient for large number, sorry')
end

if k>1
    temp = counting(n,k-1);
    v = [kron((1:n)',ones(size(temp,1),1)) kron(ones(n,1),temp)];
else
    v = (1:n)';
end

if nargin == 3
    
    v = v(r,:);
    
end

