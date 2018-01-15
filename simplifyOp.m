function out = simplifyOp(in)
% auxillary function to generate the NPA matrix
% "in" is a n-by-3 matrix
% each row: [party input output]
% Then it is simplified according to the following rules:
% --- operator belong to different parties commute
% --- assume projectors: Ai_0Aj_0 = delta_ij Ai_0
% identity is denoted as [0 0 0]
% and zero is denoted as [-1 -1 -1];
% combines simplifyProjectors and simplifySigmas

% to do: combine the two functions into this file;


if all(in(:,3)==0)
    out = simplifySigmas(in);
else
    out = simplifyProjectors(in);
end

    
    