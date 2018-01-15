function strOut = toText(M)
% translates matrix of operators to text
% Op = [party input output]
% party = A B C...
% input = 0 1 2 3...
% output = 0 1 2 3...
% example: str = toText(buildNPA({[2 2] [2 2]},1))
% written by Cai Yu, 2016-11-29

% modified, use toTextCell (which uses cellfun), 2017-10-26

% use the output of toTextCell

% converts M to a cell, cellM
cellM = toTextCell(M);

% special treatment if M is a single term
% do not add the semicolumn and tab
if numel(M)==1
    strOut = cellM{1};
    return;
end

% writes cellM to a string
strOut = [];
for ii=1:size(M,1)
    for jj = 1:size(M,2)
        
        str = cellM{ii,jj};        
        strOut = [strOut sprintf('#%s#\t', str)];
        
    end
    strOut = [strOut sprintf(';\r')];
end


end
