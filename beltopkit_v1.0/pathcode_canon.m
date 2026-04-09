%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Get canonical path code of a given path code
%
%  Rule for canonical path code:
%    Make a CIRCULAR rearrangement of a code so that the numbers are in
%    descending order as much as possible. That is, the first number should
%    be largest, and if this cannot decide a unique ordering, then let the
%    second number be the next largest one, and so on.

function maxcode = pathcode_canon( pathcode )

[ ~, ix ] = find( pathcode == max( pathcode ) );

maxcode = circshift( pathcode, length(pathcode) - ix(1) + 1 );
% Reversed code candidate:
code = [ maxcode(1), fliplr( maxcode(2:end) ) ];
if arrcomp( code, maxcode ) > 0
    maxcode = code;
end
if length(ix) == 1
    return
end
for j = ix(2:end)
    code = circshift( pathcode, length(pathcode) - j + 1 );
    if arrcomp( code, maxcode ) > 0
        maxcode = code;
    end
    % Reversed code candidate:
    code = [ code(1), fliplr( code(2:end) ) ];
    if arrcomp( code, maxcode ) > 0
        maxcode = code;
    end
end


end