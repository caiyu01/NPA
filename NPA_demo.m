% demo 
% using the codes to build an NPA matrix

% example 1: the CHSH scenario
% the scenario
scene = {[2 2] [2 2]};

% build the NPA matrix
% buildNPA(scenario,level,projOrPauli, local);
% projOrPauli = ([0] projector| 1 Pauli type operator)
% local = ([0] the usual NPA level| 1 the Moroder local level);
M = buildNPA(scene,1,1,0);

% to view it in terms of operators
toText(M)

% or in terms of cells of operators
toTextCell(M)

% assign variables
% the same variable is assigned to the same operator string
% the variables are called v, the "dictionary" is called refVar
% the observables are called u, the "dictionary" is called refObs

[str1, nVar, refVar, refObs] = assignVariableNPA(M);

% str1 is a string that represents the NPA matrix

% lets first define v and u
% !! you will need yalmip to call sdpvar()
v = sdpvar(1,nVar);
u = sdpvar(1,length(refObs));

% now we can define the NPA matrix
str1 = ['[' str1 '];']; % put the [] around str1
M0 = eval(str1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example 1: maximal CHSH violation
A0B0 = u(ismember(refObs,'#A_0B_0#'));
A0B1 = u(ismember(refObs,'#A_0B_1#'));
A1B0 = u(ismember(refObs,'#A_1B_0#'));
A1B1 = u(ismember(refObs,'#A_1B_1#'));

% constraint
F = [M0>=0, -1<=u<=1]

% objective function
% the CHSH expression in this case
obj = -(A0B0+A0B1+A1B0-A1B1);

% here you will need some sdp solver the solve the problem
% recommend: sdpt3 or sedumi or mosek
solvesdp(F,obj)

% display the value
double(-obj)


%%%%%%%   end of example 1   %%%%%%%%%%%

% example 2: PR box is not quantum

% the PR box correlation
u(ismember(refObs,'#A_0B_0#'))=1;
u(ismember(refObs,'#A_0B_1#'))=1;
u(ismember(refObs,'#A_1B_0#'))=1;
u(ismember(refObs,'#A_1B_1#'))=-1;
u(ismember(refObs,'#A_0#'))=0;
u(ismember(refObs,'#A_1#'))=0;
u(ismember(refObs,'#B_0#'))=0;
u(ismember(refObs,'#B_1#'))=0;
u(1) = 1;

% update M0
M0 = eval(str1);

% constraint
F = [M0>=0];
% no objective
obj = 0;

solvesdp(F,obj)

% should return infeasible



