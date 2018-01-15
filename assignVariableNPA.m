function [ str1 nVar refVar refObs] = assignVariableNPA( M )
% take a matrix of operators from the output of buildNPA
% assigns variable v where applicable,
% and leaves probability terms as it is
% example: [str1 nVar refVar refObs] = assignVariableNPA(M);

% created by Cai Yu
% requires: toText.m

% modified: 2017-3-28; when it it probability, just keep the variable name
% modified: 2017-9-5; add option Projector or Pauli type observables
% modified: output reference, the connection between operators and variables
% modified: assign only upper half, and copy to lower half, guarantee symmetric
% modifying: remove nVar; assign the same variable to terms 
% like A0B0B1 and A0B1B0;


% symmetrize M; (as cell of n-by-3 operator matrices)
% assuming it is square;
r = size(M);
for ii = 2:r
    for jj = 1:ii-1
        M(ii,jj) = M(jj,ii);
    end
end

uniM = uniquecell(M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove some redundancy in uniM
% may be slow
idx2remove = [];
for ii = 2:length(uniM)
    opTemp = simplifyOp(flipud(uniM{ii}));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    idxTemp = [ii];
    for jj = 2:length(uniM)
        if size(uniM{jj},1)==size(opTemp,1)
            if all(all(uniM{jj}==opTemp))
                idxTemp = [idxTemp jj];
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    idxTemp = unique(idxTemp);
    if length(idxTemp)>=2 % there is redundancy
        idx2remove = [idx2remove idxTemp(2:end)];
    end
end
uniM(idx2remove) = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% generate the preliminary string output
% all in terms of #A0|0# #B1|0# #A0|0A0|1# etc...
str1 = toText(M);

% counts the number of variables assigned
nVar = 0;
% the observables
nObs = 0;

for ii = 1:length(uniM)
    opTemp = uniM{ii};
    
    % check if opTemp should be a variable
    % more operators than the number of unique parties
    % assuming the operators are already simplified; 0 and 1 are taken care of
    isVar = length(unique(opTemp(:,1))) < size(opTemp,1);
    
    % to be replaced  
    strTemp = ['#' toText1(opTemp) '#'];
    
    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%
    % replace the conjugated variable as well
    strTempConj = ['#' toText1(simplifyOp(flipud(opTemp))) '#'];
    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%
    
    if isVar == true
        nVar = nVar+1;
        strv = ['v(' num2str(nVar) ')'];
        str1 = strrep(str1,strTemp,strv);
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%
        str1 = strrep(str1,strTempConj,strv);
        %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%
        refVar{1,nVar} = strTemp;
        refVar{2,nVar} = strTempConj;
    else
    % just keeps its form
        nObs = nObs+1;
        strv = ['u(' num2str(nObs) ')'];
        str1 = strrep(str1,strTemp,strv);
        refObs{nObs} = strTemp;
%         str2 = toText1(opTemp);
%         str1 = strrep(str1,strTemp,str2);
    end
    
end

end
    

% auxiallary function;
% maybe different from the one in toText.m
function strOut = toText1(Op)
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
    strOut = [strOut party outcome '_' input];

end

    
end