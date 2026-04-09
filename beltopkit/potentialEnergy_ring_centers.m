%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function E = potentialEnergy_ring_centers( coord, bondList, angleList, angleTypeList, ...
    d0, a0_0, a0_1, k_ang )
%    coord: Initial xyz coordinates in Angstrom

E = 0;
% Harmonic bond potential:
NBnd = size( bondList, 1 );
for j = 1 : NBnd
    d = norm( coord(bondList(j,1),:) - coord(bondList(j,2),:) );
    E = E + (d/d0-1)^2;
end

% Harmonic angle potential:
NAng = size( angleList, 1 );
for j = 1 : NAng
    v1 = coord(angleList(j,1),:) - coord(angleList(j,2),:);
    v2 = coord(angleList(j,3),:) - coord(angleList(j,2),:);
    cosang = dot( v1, v2 ) / norm( v1 ) / norm( v2 );
    if abs(cosang-1) < 10*eps
        a = 0;
    elseif abs(cosang+1) < 10*eps
        a = pi;
    else
        a = acos( cosang );
    end
    if angleTypeList(j) == 0
        E = E + k_ang/2*( a - a0_0*pi/180 )^2;
    else
        E = E + k_ang/2*( a - a0_1*pi/180 )^2;
    end
end

end