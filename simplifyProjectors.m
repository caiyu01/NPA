function out = simplifyProjectors(in)

% auxillary function to generate the NPA matrix
% "in" is a n-by-3 matrix
% each row: [party input output]
% Then it is simplified according to the following rules:
% --- operator belong to different parties commute
% --- assume projectors: Ai_0Aj_0 = delta_ij Ai_0
% identity is denoted as [0 0 0]
% and zero is denoted as [-1 -1 -1];
% written by Cai Yu 2016-05-10

% modified: 2016-11-25; changed to ind2remove;
% modified: 2017-3-28; bug fix: return [-1 -1 -1] whenever [-1 -1 -1] present

% different parties commute
out = [];
in = sortrows(in,1);

% find parties
party = unique(in(:,1));

%
myFlag=0; % myFlag = 1 if the operator correspond to 0, see below
for iParty = 1:length(party)
    tmpParty = party(iParty);
    
    if tmpParty == -1
        out = [-1 -1 -1];
        return;
    end
    
    % pick out operators from one party
    tmp1 = in(in(:,1) == tmpParty,:);
    
    while true
        tmp2 = tmp1;
        ind2remove = [];
        for  ii = 1:size(tmp2,1)-1
            if tmp2(ii,2) == tmp2(ii+1,2)
                if tmp2(ii,3) == tmp2(ii+1,3)
                    % if same party same input same output
                    % A0_0A0_0 = A0;
                    % identity = [0 0 0];
                    ind2remove = [ind2remove ii];                    
                else
                    % if same party same input different output
                    % Ai_0*Aj_0 = 0 if i~=j;
                    % zero = [-1 -1 -1];
%                     tmp2 = [-1 -1 -1];
%                     myFlag = 1;
%                     break;
                    out = [-1 -1 -1];
                    return;
                end
            end            
        end
        % remove some operator: A0_0*A0_0 = A0_0
        tmp2(ind2remove,:) = [];
        
        % if size(tmp2,1) does not reduce, then it is simplified
        if size(tmp2,1) == size(tmp1,1)
            break
        end
        tmp1 = tmp2;
    end
    
    if myFlag==1
       out = [-1 -1 -1]; 
       break
    end
    
    out = [out; tmp2];
end % party

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

    
    