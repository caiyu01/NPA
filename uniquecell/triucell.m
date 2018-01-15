function [ M1 ] = triucell( M1 )
% TRIUCELL(M) keeps the upper triangular part of M
% Fills the rest with empty cell
% by Cai Yu, 2017-10-25

% check if M is cell
if iscell(M1)~=1
    error('Not a cell. Use triu() for matrices');
end
    
   
[r c] = size(M1);

if c>=r
    for ii = 2:r
        for jj = 1:ii-1
            M1{ii,jj} = [];
        end
    end
else
    for ii = c-1:r
        for jj = 1:ii-1
            M1{ii,jj} = [];
        end
    end
end

end