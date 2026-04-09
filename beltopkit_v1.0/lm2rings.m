%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Determine all rings (3, 4, 5, 6 and 7 membered) from an adjacency matrix

function ringcell = lm2rings( lm )

NAt = length(lm);

nblist = lm2nblist( lm );

tmpfile = sprintf( 'rings_%i.tmp', floor(rand*4294967296) );
fid = fopen( tmpfile, 'w' );

for at = 1 : NAt
    rings_by_atom( fid, at, nblist, at );
end

fclose(fid);

% Load and uniq rings from tmpfile:
fid = fopen( tmpfile, 'r' );
ringcell = cell(0,1);
while ~feof(fid )
    tline = fgetl( fid );
    rg = str2num( tline );
    ifUniq = true;
    for j = 1 : length(ringcell)
        if isequal( rg, ringcell{j} )
            ifUniq = false;
            break
        end
    end
    if ifUniq
        ringcell{ end+1, : } = rg;
    end
end
fclose(fid);

system( sprintf( 'rm -f %s', tmpfile ) );

% For Mobius cases:
ringcell0 = ringcell;
NR0 = length(ringcell0);
rgsz_list = zeros(1,NR0);
for j = 1 : NR0
    rgsz_list(j) = length( ringcell0{j} );
end
[ ~, ix_sort ] = sort( rgsz_list );
ringcell = cell(0,1);
for ix = ix_sort
    rg = ringcell0{ix};
    ifUniq = true;
    for j = 1 : length(ringcell)        
        if length( intersect( ringcell{j}, rg ) ) > 2
            ifUniq = false;
            break
        end
    end
    if ifUniq
        ringcell{ end+1, : } = rg;
    end
end

end