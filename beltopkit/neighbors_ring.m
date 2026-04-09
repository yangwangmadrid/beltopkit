%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function nblist_ring = neighbors_ring( lm_ring )

NR = length( lm_ring );

nblist_ring = cell( NR, 1 );
for j = 1 : NR
    nb = find( lm_ring(j,:) ~= 0 );
    nblist_ring{j} = nb;
end

end