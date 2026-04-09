%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Convert a RDS (ring directional sequence) to path code
 
function pathcode = rds2pathcode( rds )

% Speical case for zigzag CNB (n,0) (i.e., containing no turning-points):
if all( rds == 0 )
    pathcode = -length(rds);
    return
end


% Determine Huckel or Mobius topology:
Nnode = length( rds );
if mod( Nnode, 2 ) == 1
    ifMobius = false;
    NR = Nnode;
    %fprintf( 'Hueckel topology\n' );
else
    NR = Nnode / 2;
    ifMobius = isequal( rds(1:NR), -rds(NR+1:Nnode) );
    if ~ifMobius
        NR = Nnode;
        %fprintf( 'Hueckel topology\n' );
    else
        %fprintf( 'Moebius topology\n' );
    end
end


ix_tp = find( rds ~= 0 ); % Indices of turning-point rings
Ntp = length( ix_tp( ix_tp <= NR ) );
%fprintf( '%i turning-point rings\n', Ntp )
% Special case of zigzag type:
if Ntp == 0
    % if ~ifMobius
    %     pathcode = NR;
    % else
    %     pathcode = -NR;
    % end
    pathcode = -NR;

    %%pathcode_enc = encode_belt_code( pathcode, ifMobius );
    %fprintf( '%i-fold topological symmetry\n', NR );
    return
end

% Special case of MCNBs with ONLY ONE turning point:
% e.g., the second isomer of twisted (n,0) CNB:
if Ntp == 1
    path_code = NR;
else
    path_code = zeros( 1, Ntp );
    for j = 1 : Ntp
        if ifMobius
            j1 = j+1;
        else
            if j < Ntp
                j1 = j+1;
            else
                j1 = 1;
            end
        end
        path_code(j) = ix_tp(j1) - ix_tp(j);
        if path_code(j) < 0
            path_code(j) = path_code(j) + NR;
        end
        path_code(j) = path_code(j) * ...
            -sign( rds(ix_tp(j)) * rds(ix_tp(j1)) );
    end
end
% path_code
% % sum(path_code)
% rds

% Get canonical path code:
pathcode = pathcode_canon( path_code );

% Check NR:
assert( sum( abs(pathcode) ) == NR )


end