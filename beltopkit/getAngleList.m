%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function angleList = getAngleList( NAt, bondList )

angleList = [];         
% NOTE: j is the center atom, i.e., k--j--l:
for j = 1 : NAt
    % Get bonding neighbors of j:
    j_nb = [];
    for iBond = 1 : length( bondList )
        if ismember( j, bondList(iBond,:) )
            j_nb = [ j_nb; setdiff( bondList(iBond,:), j ) ];
        end
    end
    Nnb_j = length( j_nb );
    for k1 = 1 : Nnb_j
        for k2 = k1+1 : Nnb_j
            nb1 = j_nb(k1);
            nb2 = j_nb(k2);
            angleList = [ angleList;  nb1, j, nb2 ];
        end
    end
end

end