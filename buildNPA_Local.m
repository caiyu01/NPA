function M = buildNPA_Local(scenario, level, ProjOrPauli)
% build the NPA matrix
% for given scenario and local level
% example: M = buildNPA_Local({[2 2] [2 2]}, 2)
% written by Cai Yu, last editted 2016-12-12;
% obsolete. See buildNPA.m

% requires: simplifyProjectors, simplifySigmas; countingSpecial; uniquecell

if nargin==2
    ProjOrPauli = 0;
elseif nargin==3
    while ProjOrPauli~=0 && ProjOrPauli~=1
        ProjOrPauli = input('Invalid input. 0 for Projector, 1 for Pauli observables: ');
    end
end
    

Op{1} = [0 0 0];

for ii_party = 1:length(scenario)
    % for a party ii
    opTemp = []; % single level
    ii_op=1;
    for ii_input = 1:length(scenario{ii_party})
        % the last outcome can be inferred by normalization, so -1
        for ii_output = 1:scenario{ii_party}(ii_input)-1
            % all the operator of party ii
            opTemp(ii_op,:) = [ii_party ii_input ii_output];
            ii_op = ii_op+1;
        end
    end
    ind = countingSpecial(size(opTemp,1),level);
    OpTemp = cell(1,size(ind,1)); % raised to the desired local level
    for ii_Op = 1:size(ind,1);
        if ProjOrPauli == 0
            OpTemp{ii_Op} = simplifyProjectors(opTemp(ind(ii_Op,:)',:));
        else
            OpTemp{ii_Op} = simplifySigmas(opTemp(ind(ii_Op,:)',:));
        end
    end
    OpTemp = [ [0 0 0], uniquecell(OpTemp)];
    % kron the different parties together;
    Op = kronOp(Op,OpTemp,ProjOrPauli);
end


M = cell(length(Op));

for ii = 1:length(Op)
    for jj = ii:length(Op)
        if ProjOrPauli == 0
            M{ii,jj} = simplifyProjectors([flipud(Op{ii});Op{jj}]); % flipud to conjugate
        else
            M{ii,jj} = simplifySigmas([flipud(Op{ii});Op{jj}]); % flipud to conjugate
        end        
    end
end

for ii = 2:length(Op)
    for jj = 1:ii
        if ProjOrPauli==0
            M{ii,jj} = simplifyProjectors(flipud(M{jj,ii}));
        else
            M{ii,jj} = simplifySigmas(flipud(M{jj,ii}));
        end
    end
end

end   

function opOut = kronOp(opIn1, opIn2, ProjOrPauli)
% kronecker product of two sets of operators
[ind1 ind2] = meshgrid(1:length(opIn1),1:length(opIn2));

opOut = cell(1,numel(ind1));

for ii = 1:numel(ind1);
    if ProjOrPauli == 0
        opOut{ii} = simplifyProjectors([opIn1{ind1(ii)};opIn2{ind2(ii)}]);
    else
        opOut{ii} = simplifySigmas([opIn1{ind1(ii)};opIn2{ind2(ii)}]);
    end
end

end
