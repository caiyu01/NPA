function [ out ] = conjugateOp( in )
% conjugate the operator
% [party input output]

if iscell(in)
    out = cell(size(in));
    for ii = 1:length(in)
        out{ii} = simplifyProjectors(flipud(in{ii}));
    end
else
    % different party commutes
    out = simplifyProjectors(flipud(in));
end


end

