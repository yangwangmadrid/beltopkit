%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function lm_ring = linkage_ring( ringcell )

NR = length( ringcell );

lm_ring = zeros( NR, NR );
for j = 1 : NR
    rg1 = ringcell{j};
    for k = j+1 : NR
        rg2 = ringcell{k};

        if ~isempty( intersect( rg1, rg2 ) )
            lm_ring( j,k ) = 1;
            lm_ring( k,j ) = 1;
        end
    end
end

end