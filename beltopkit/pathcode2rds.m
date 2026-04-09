%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Convert a path code to segment direction code

function rds = pathcode2rds( pathcode )

% Speical case for zigzag CNB (n,0) (i.e., containing no turning-points):
if length( pathcode ) == 1
    if pathcode < 0
        rds = zeros( 1, -pathcode );
        return
    end
end

rds = [ 1 ];
seg_last = 1;
for j = 1 : length( pathcode )
    %[j, pathcode(j), seg_last]
    for k = 1 : abs(pathcode(j))-1
        rds = [ rds, 0 ];
    end
    if j == length( pathcode ) % Terminated
        break
    end
    if pathcode(j) > 0
        rds = [ rds, -seg_last ];
    else
        rds = [ rds, seg_last ];
    end
    seg_last = rds(end);
end


end