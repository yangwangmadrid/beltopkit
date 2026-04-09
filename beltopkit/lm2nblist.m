%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function nblist = lm2nblist( lm )

N = length(lm);

nblist = zeros( N, 3 ); % Maximum coordination number is 3

for j = 1 : N
    inb = 1;
    for k = 1 : N
        if k == j
            continue
        end
        
        if( lm(j,k) )
            nblist(j,inb) = k;
            inb = inb + 1;
    end
end

end