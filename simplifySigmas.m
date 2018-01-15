function out = simplifySigmas(in)

% auxillary function to generate the NPA matrix
% "in" is a n-by-3 matrix
% each row: [party input 0]
% Then it is simplified according to the following rules:
% --- operator belong to different parties commute
% --- assume Pauli type operators: A^2 = 1
% identity is denoted as [0 0 0]
% and zero is denoted as [-1 -1 -1];
% written by Cai Yu 2017-08-29

% different parties commute
out = [];
in = sortrows(in,1);

% find parties
party = unique(in(:,1));

%
myFlag=0; % myFlag = 1 if the operator correspond to 0, see below
for iParty = 1:length(party)
    tmpParty = party(iParty);
    
    if tmpParty == -1;
        out = [-1 -1 -1];
        return;
    end
    
    % pick out operators from one party
    tmp1 = in(in(:,1) == tmpParty,:);
    
    while true
        tmp2 = tmp1;
        for ii = 1:size(tmp2,1)-1
            if tmp2(ii,2)==tmp2(ii+1,2)
                % A^2 = 1;
                tmp2(ii:ii+1,:) = [];
                break;
            end
        end
        
        % if size does not decrease anymore, break the loop
        if size(tmp2,1)==size(tmp1,1)
            break;
        end
        
        tmp1 = tmp2;
        
    end
    
    if myFlag==1
       out = [-1 -1 -1]; 
       break
    end
    
    out = [out; tmp2];
end

out = sortrows(out,1);

% remove the identity [0 0 0]
tmpOut = out;
tmpOut(sum(tmpOut,2)==0,:) = [];
if isempty(tmpOut)
    out = [0 0 0];
else
    out = tmpOut;

end

end

    
    