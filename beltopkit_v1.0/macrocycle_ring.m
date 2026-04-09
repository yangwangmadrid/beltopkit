%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Get the macrocyclic connectivity sequence of the rings

function p = macrocycle_ring( nblist_ring )

NR = length( nblist_ring );

p = [ 1, nblist_ring{1}(1) ];
for j = 2 : NR
    p_next = setdiff( nblist_ring{p(j)}, p(end-1) );
    if ismember( p, p_next )
        error( 'ERROR: Invalid macrocycle' )
    end
    p = [ p, p_next ];
end

%assert( p(1) == p(end) )
if p(1) ~= p(end)
    p = 0;
    fprintf( 'ERROR: Wrong belt structure\n' );
    return
end

p = p(1:end-1);

end