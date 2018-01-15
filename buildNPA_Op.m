function M = buildNPA_Op(Op, ProjOrPauli)
% build the NPA matrix
% for given scenario and level (not local level)
% example: M = buildNPA({[2 2] [2 2]}, 2)
%               M = buildNPA({[2 2] [2 2]},2,1) for Pauli observables
% written by Cai Yu, last editted 2016-11-25;
% editted: enable constructing according to Pauli observables as well, 2017-8-29


% requires: simplifyProjectors; countingSpecial; uniquecell
% requires: simplifyPaulis

if nargin==1
    ProjOrPauli = 0;
elseif nargin==2
    while ProjOrPauli~=0 && ProjOrPauli~=1
        ProjOrPauli = input('Invalid input. 0 for Projector, 1 for Pauli observables: ');
    end
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

% symmetrize
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