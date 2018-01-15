function M = buildNPA(scenario, level, ProjOrPauli, local)
% build the NPA matrix
% for given scenario and level (not local level)
% example: M = buildNPA({[2 2] [2 2]}, 2)
%               M = buildNPA({[2 2] [2 2]},2,1) for Pauli observables
% written by Cai Yu
% requires: listNPA_Op and listNPA_Op_Local and buildNPA_Op

if nargin<=2
    ProjOrPauli = 0; % projectors by default
    local = 0; % usual NPA level by default
elseif nargin<=3
    local = 0; % usual NPA level by default
elseif (ProjOrPauli ~= 0 && ProjOrPauli ~= 1) || (local ~=0 && local~=1)
    error('Check input. ProjOrPauli = 0 or 1, local = 0 or 1.');
end

% simply call listNPA_Op or listNPA_Op_Local
if local==1
    M = buildNPA_Op(listNPA_Op_Local(scenario,level,ProjOrPauli),ProjOrPauli);
else
    M = buildNPA_Op(listNPA_Op(scenario,level,ProjOrPauli),ProjOrPauli);
end
    
    
end