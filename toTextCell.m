function cellOut = toTextCell(M)
% translates matrix of operators to text cell
% Op = [party input output]
% party = A B C...
% input = 0 1 2 3...
% output = 0 1 2 3...
% example: 
% by Cai Yu, 2017-10-25

cellOut = cellfun(@(m) toText1(m),M,'UniformOutput',false);
    
end


function strOut = toText1(Op)
% take n-by-3 matrix as input
% outputs a string denoting the party output_input
% special case: "Id" = [0 0 0], "0" = [-1 -1 -1];
if size(Op,1)==1
    if Op==[0 0 0]
        strOut = '1';
        return;
    elseif Op==[-1 -1 -1]
        strOut = '0';
        return;
    end
end
    
strOut = [];
for ii = 1:size(Op,1)

    party = char(Op(ii,1)+64);
    input = num2str(Op(ii,2)-1);
    if Op(ii,3)==0
        % the Pauli observables
        outcome = [];
    else
        % projectors
        outcome = num2str(Op(ii,3)-1);
    end
    % concatenates
    strOut = [strOut party outcome '_' input];

end
end
