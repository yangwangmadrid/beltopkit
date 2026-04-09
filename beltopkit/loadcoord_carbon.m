%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function [ coord_C, elem_C ] = loadcoord_carbon( inp )

[ coord, elem ] = loadcoordx( inp );

coord_C = [];
elem_C = {};
k = 1;
for j = 1 : length( elem )
    if strcmpi( elem{j}, 'C' ) || strcmpi( elem{j}, '6' )
        coord_C = [ coord_C; coord(j,:) ];
        elem_C{k} = 'C';
        k = k + 1;
    end
end

end
