%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function E = potentialEnergy( coord, bondList, angleList, d0, a0, k_ang )
%    coord: Initial xyz coordinates in Angstrom

E = 0;
% Harmonic bond potential:
NBnd = size( bondList, 1 );
for j = 1 : NBnd
    d = norm( coord(bondList(j,1),:) - coord(bondList(j,2),:) );
    E = E + (d/d0-1)^2; % ORIGINAL, better for for MClrs
    %E = E + (d/d0-1)^4; % NOW SEEMS power of 4 is better for MCNBs
end


% Harmonic angle potential:
NAng = size( angleList, 1 );
for j = 1 : NAng
    v1 = coord(angleList(j,1),:) - coord(angleList(j,2),:);
    v2 = coord(angleList(j,3),:) - coord(angleList(j,2),:);
    a = acos( dot( v1, v2 ) / norm( v1 ) / norm( v2 ) );    
    E = E + k_ang/2*( a - a0*pi/180 )^2; % better for for MClrs
    %E = E + k_ang/2*( a - a0*pi/180 )^4; % better for MCNBs
end

end
