%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Compare two numeric arrays

function v = arrcomp( A1, A2 )

N1 = length(A1);
N2 = length(A2);
for j = 1 : min( N1, N2 )
    if A1(j) < A2(j)
        v = -1;
        return
    elseif A1(j) > A2(j)
        v = 1;
        return
    end
end

if N1 < N2
    v = -1;
elseif N1 > N2
    v = 1;
else
    v = 0;
end

end