%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% centerize.m
% move the coordinates in order to make center of molecule coincide with
% the origin (0,0,0)
function newcoord = centerize( coord )

sz = size(coord);
N = sz(1);

cc = center( coord );

for j = 1 : N
    newcoord(j,:) =  coord(j,:) - cc;
end

