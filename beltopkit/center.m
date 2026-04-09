%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% center.m
% Center of coordinates
function ccoord = center( coord )
% Parameters:
%   coord <N*3 matrix>: coordinates of molecule
%
% Return:
%   ccoord <1*3 vector>: coordinate of the center

sz = size(coord);
N = sz(1);

ccoord(:,1) = sum(coord(:,1))/N;
ccoord(:,2) = sum(coord(:,2))/N;
ccoord(:,3) = sum(coord(:,3))/N;
