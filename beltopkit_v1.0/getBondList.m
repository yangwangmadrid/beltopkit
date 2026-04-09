%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function bondList = getBondList( coord )

MAX_CC_BONDLEN = 1.75; % Angstrom

% List of bonds:
bondList = [];
NAt = size( coord, 1 );
for j = 1 : NAt
    for k = j+1 : NAt
        d = norm( coord(j,:) - coord(k,:) );
        if d <= MAX_CC_BONDLEN
            bondList = [ bondList;  j, k ];
        end
    end
end

end