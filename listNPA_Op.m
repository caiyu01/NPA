function Op = listNPA_Op(scenario, level, ProjOrPauli)
% build the NPA matrix
% for given scenario and level (not local level)
% example: Op = listNPA_Op({[2 2] [2 2]}, 1)
%                Op = listNPA_Op({[2 2] [2 2]}, 1, 1) for Pauli observables

% editted: enable constructing according to Pauli observables as well, 2017-8-29
% editted: fixed the problem with observables.


% requires: simplifyProjectors; countingSpecial; uniquecell
% requires: simplifyPaulis

if nargin==2
    ProjOrPauli = 0;
elseif nargin==3
    while ProjOrPauli~=0 && ProjOrPauli~=1
        ProjOrPauli = input('Invalid input. 0 for Projector, 1 for Pauli observables: ');
    end
end


ii_op=1;
for ii_party = 1:length(scenario)
    for ii_input = 1:length(scenario{ii_party})
        % the last outcome can be inferred by normalization, so -1
        if ProjOrPauli == 0 % Projectors
            for ii_output = 1:scenario{ii_party}(ii_input)-1
                op(ii_op,:) = [ii_party ii_input ii_output];
                ii_op = ii_op+1;
            end
        else % Pauli observables
            op(ii_op,:) = [ii_party ii_input 0];
            ii_op = ii_op+1;
        end
    end
end

op = [0 0 0; op];

% higher level
% different ways of selecting n (=level) operators from the list

%%%%%%%%%%%%%%%%%%%%%
% counting or countingSpecial???? %%%%
%%%%%%%%%%%%%%%%%%%%

%ind = countingSpecial(size(op,1),level);
ind = counting(size(op,1),level);

for ii_Op = 1:size(ind,1);
    if ProjOrPauli == 0;
        Op{ii_Op} = simplifyProjectors(op(ind(ii_Op,:)',:));
    else
        Op{ii_Op} = simplifySigmas(op(ind(ii_Op,:)',:));
    end
end

% the first row of the moment matrix
Op = uniquecell([ [0 0 0], Op]);


% M = cell(length(Op));
% 
% for ii = 1:length(Op)
%     for jj = ii:length(Op)
%         if ProjOrPauli == 0
%             M{ii,jj} = simplifyProjectors([flipud(Op{ii});Op{jj}]); % flipud to conjugate
%         else
%             M{ii,jj} = simplifySigmas([flipud(Op{ii});Op{jj}]); % flipud to conjugate
%         end
%     end
% end
% 
% % symmetrize
% for ii = 2:length(Op)
%     for jj = 1:ii
%         if ProjOrPauli==0
%             M{ii,jj} = simplifyProjectors(flipud(M{jj,ii}));
%         else
%             M{ii,jj} = simplifySigmas(flipud(M{jj,ii}));
%         end
%     end
% end
% 
% end   