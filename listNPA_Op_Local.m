function Op = listNPA_Op_Local(scenario, level, ProjOrPauli)
% build the NPA matrix
% for given scenario and local level 
% example: Op = listNPA_Op_Local({[2 2] [2 2]}, 1)
%                Op = listNPA_Op_Local({[2 2] [2 2]}, 1, 1) for Pauli observables

% editted: enable constructing according to Pauli observables as well, 2017-8-29
% editted: fixed the problem with observables
% requires: simplifyProjectors; countingSpecial; uniquecell
% requires: simplifySigmas
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
        if ProjOrPauli==0 % projector
            % the last outcome can be inferred by normalization, so -1
            for ii_output = 1:scenario{ii_party}(ii_input)-1
                % all the operator of party ii
                opTemp(ii_op,:) = [ii_party ii_input ii_output];
                ii_op = ii_op+1;
            end
        else % observables
            opTemp(ii_op,:) = [ii_party ii_input 0];
            ii_op = ii_op+1;
        end
    end
    
    opTemp = [0 0 0; opTemp];
    ind = countingSpecial(size(opTemp,1),level);
    OpTemp = cell(1,size(ind,1)); % raised to the desired local level
    for ii_Op = 1:size(ind,1);
        if ProjOrPauli == 0
            OpTemp{ii_Op} = simplifyProjectors(opTemp(ind(ii_Op,:)',:));
        else
            OpTemp{ii_Op} = simplifySigmas(opTemp(ind(ii_Op,:)',:));
        end
    end
    OpTemp = uniquecell(OpTemp);
    % kron the different parties together;
    Op = kronOp(Op,OpTemp,ProjOrPauli);
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