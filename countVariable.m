function [ n_var listOfVar] = countVariable( M )
% count how many sdp varible is needed
% given the Matrix of operators M
% example: [n listOfVar] = countVariable(M);

% require uniquecell

% first find the set of unique operators
uniqueM = uniquecell(M);

% variable
% first column for sdpvar; second column for prob
listOfVar = zeros(length(uniqueM),2);

i_var = 1;
% in the list of operators find which are variables
for ii = 1:length(uniqueM)
    temp1 = uniqueM{ii};
    parties = unique(temp1(:,1));
    % it will be a variable if it involves different measurement on the same party

    for i_party = 1:length(parties)
        ind = temp1(:,1)==parties(i_party);
        if (unique(temp1(ind,2)))>1; % more than one measurement 
            listOfVar(ii) = i_var;
            i_var = i_var+1;
            break;
        end
    end

end

n_var = max(listOfVar(:,1));

end