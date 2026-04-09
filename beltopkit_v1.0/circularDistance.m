%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function d_list = circularDistance( ring, i1, i2_list )

NR = length( ring );
ix1 = find( ring == i1, 1 );

d_list = [];
for i2 = i2_list
    ix2 = find( ring == i2, 1 );

    d = ix2 - ix1;
    if d < 0
        d = d + NR;
    end

    if d > NR/2
        d = d - NR;
    end

    d_list = [ d_list, d ];
end

end