%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Nomenclature for GENERAILZED CNBs, including CNBs, kekulenes, clarenes, 
% and many other double-stranded, fully-fused belts, for both untwited and 
% Mobius belts
% Updated:
%   Oct 7, 2024:
%     --> Correctly treat the special cases in which the belt contains a 
%         center ring that is the macrocycle formed by the surrounding 
%         "normal" rings:
%
%   Sep 29, 2024:
%     --> Fixed a bug for the special case that the Mobius CNB (obtained
%     from zigzag (n,0) CNB) containing ONLY ONE turning point (which is 
%     impossible in the Huckel cases) had the same path code as the Mobius 
%     CNB isomer (also obtained from twisting zigzag (n,0) CNB), i.e, NR.
%     Therefore, we define that this special Mobius CNB with ONLY ONE 
%     turning point has a pathcode as -NR.
%
%   Sep 28, 2024:
%     --> Allowed adjacency matrix as input argments
%
% Created:
%   Sep 8, 2024

function [ pathcode, pathcode_enc, rds, ringcell ] = belt_code( inp )
% inp: Either coord. filename or adjacency matrix (lm) or coord matrix

if ischar( inp )
    coord = loadcoord_carbon( inp );
    lm = linkage( coord );
elseif ismatrix( inp )
    if size(inp,1) == size(inp,2)
        lm = inp;
    elseif size(inp,2) == 3
        coord = inp;
        lm = linkage( coord );
    end
else
    error( 'Input argument must be a filename or an adjacency matrix' )
end


ringcell = lm2rings( lm );
NR = length( ringcell );
fprintf( '%i rings\n', NR );

lm_ring = linkage_ring( ringcell );
% Treat the special case of the belts having a center ring that is the
% macrocycle formed by the surrounding "normal" rings:
CN_ring = sum( lm_ring );
if max(CN_ring) > 3 && sum(CN_ring==max(CN_ring)) == 1
    % Remove the central macrocyclic ring:
    ringcell0 = ringcell;
    ringcell = cell(0,1);
    for j = 1 : NR
        if CN_ring(j) == 3
            ringcell{end+1,1} = ringcell0{j};
        end
    end
    % Update related var:
    NR = length( ringcell );
    fprintf( '%i rings upon removal of central macrocyclic ring\n', NR );
    lm_ring = linkage_ring( ringcell );
end

nblist_ring = neighbors_ring( lm_ring );
sq = macrocycle_ring( nblist_ring ); % Macrocyclic sequence of rings
if sq == 0 % Wrong belt structure detected
    pathcode = 0;
    pathcode_enc = '0';
    return
end

% Update the order of ringcell{}:
ringcell0 = ringcell;
for j = 1 : NR
    ringcell{j} = ringcell0{ sq(j) };
end
% % Print rings:
% for j = 1 : NR
%     fprintf( '%2i: ', j )
%     fprintf( ' %3i', ringcell{j} )
%     fprintf( '\n' )
% end

% Get interring bonds:
bnd_conn = zeros( NR, 2 );
for j = 1 : NR
    rg1 = ringcell{ j };
    if j < NR
        rg2 = ringcell{ j+1 };
    else
        rg2 = ringcell{ 1 };
    end
    bnd_conn( j, : ) = intersect( rg1, rg2 );
end
%bnd_conn

% (I) Running rings in a fixed (randomly chosen) direction:
% Turning directions of segments determined in this given direction:
%    0: Straight non-turning point
%   +1: Right non-turning point
%   -1: Left non-turning point
rds1 = zeros( 1, NR );
for j = 1 : NR+1
    % j_ is effetive j:
    if j > NR
        j_ = j - NR;
    else
        j_ = j;
    end
    if j+1 > NR
        j1_ = j+1 - NR;
    else
        j1_ = j+1;
    end
    %%fprintf( '\nRing %2i:\n', j_ )
    %%fprintf( 'Bond between ring %i and ring %i: %i %i\n', j_,j1_,bnd_conn(j_,:) ) 
    % Adjacent bond between ring-j and ring-(j+1):
    if j == 1 % Starting ring-conn: from ring-1 to ring-2
        % RANDOMLY CHOOSE at1 as at_refR and at2 as at_refL:
        at_refR = bnd_conn(j,1);
        at_refL = bnd_conn(j,2);
        %%fprintf( 'at_refR = %i, at_refL = %i\n', at_refR, at_refL )
    else % ring-conn: from ring-j to ring-(j+2) with j >= 2        
        % First, using at_refR--at_refL to rectify the direction of
        % ring-j:
        if circularDistance(ringcell{j_}, at_refR, at_refL ) == -1
            ringcell{j_} = fliplr( ringcell{j_} );
        end
        assert( circularDistance(ringcell{j_}, at_refR, at_refL ) == 1 )
        %%fprintf( '=====  Reordered ring atoms in ring %i:  =====\n', j_ )
        %%fprintf( ' %3i', ringcell{j_} )
        %%fprintf( '\n===================================\n' )
        %%fprintf( 'at_refR = %i, at_refL = %i\n', at_refR, at_refL )
        if circularDistance(ringcell{j_}, bnd_conn(j_,1), bnd_conn(j_,2) ) == 1
            at_refR_next = bnd_conn(j_,2);
            at_refL_next = bnd_conn(j_,1);
        else
            at_refR_next = bnd_conn(j_,1);
            at_refL_next = bnd_conn(j_,2);
        end
        %%fprintf( 'at_refR_next = %i, at_refL_next = %i\n', at_refR_next, at_refL_next )
        dist_RR = circularDistance(ringcell{j_}, at_refR_next, at_refR );
        dist_LL = circularDistance(ringcell{j_}, at_refL_next, at_refL );
        % Case 1: "Right"-turn
        if abs(dist_RR) == 1 % ring-j is turning-point; j-(j+1)-right
            %%fprintf( 'Ring %i is a RIGHT turning-point.\n', j_ )
            rds1(j_) = 1;
        % Case 2: "Left"-turn
        elseif abs(dist_LL) == 1 % ring-j is turning-point; j-(j+1)-left
            %%fprintf( 'Ring %i is a LEFT turning-point.\n', j_ )
            rds1(j_) = -1;
        % Case 3: Straight, no-turn
        else % ring-j is non-turning-point; j-(j+1)-straight
            %%fprintf( 'Ring %i is a STRAIGHT non-turning-point.\n', j_ )
            rds1(j_) = 0;
        end

        at_refR = at_refR_next; % Update at_refR
        at_refL = at_refL_next; % Update at_refL
        %pause
    end
end
%rds1
%sum( rds1 )

% (II) Continuing to run rings a second time in the same direction: 
% Turning directions of segments determined in the same given direction:
%    0: Straight non-turning point
%   +1: Right non-turning point
%   -1: Left non-turning point
%%fprintf( '\nContinuing to run rings a second time ...\n' )
ifMobius = false;
rds2 = zeros( 1, NR );
for j = NR+2 : 2*NR+1
    % j_ is effetive j:
    if j > 2*NR
        j_ = j - 2*NR;
    else
        j_ = j - NR;
    end
    if j+1 > 2*NR
        j1_ = j+1 - 2*NR;
    else
        j1_ = j+1 - NR;
    end
    %%fprintf( '\nRing %2i:\n', j_ )
    %%fprintf( 'Bond between ring %i and ring %i: %i %i\n', j_,j1_,bnd_conn(j_,:) ) 
    % ring-conn: from ring-j to ring-(j+2) with j >= 2
    % First, using at_refR--at_refL to rectify the direction of
    % ring-j:
    if circularDistance(ringcell{j_}, at_refR, at_refL ) == -1
        if j>NR+2
            if ~ifMobius
                error( 'Impossible Mobius or Huckel topology' )
            end
        else
            ifMobius = true;
        end
        ringcell{j_} = fliplr( ringcell{j_} );
    end
    assert( circularDistance(ringcell{j_}, at_refR, at_refL ) == 1 )
    %%fprintf( '=====  Reordered ring atoms in ring %i:  =====\n', j_ )
    %%fprintf( ' %3i', ringcell{j_} )
    %%fprintf( '\n===================================\n' )
    %%fprintf( 'at_refR = %i, at_refL = %i\n', at_refR, at_refL )
    if circularDistance(ringcell{j_}, bnd_conn(j_,1), bnd_conn(j_,2) ) == 1
        at_refR_next = bnd_conn(j_,2);
        at_refL_next = bnd_conn(j_,1);
    else
        at_refR_next = bnd_conn(j_,1);
        at_refL_next = bnd_conn(j_,2);
    end
    %%fprintf( 'at_refR_next = %i, at_refL_next = %i\n', at_refR_next, at_refL_next )
    dist_RR = circularDistance(ringcell{j_}, at_refR_next, at_refR );
    dist_LL = circularDistance(ringcell{j_}, at_refL_next, at_refL );
    % Case 1: "Right"-turn
    if abs(dist_RR) == 1 % ring-j is turning-point; j-(j+1)-right
        %%fprintf( 'Ring %i is a RIGHT turning-point.\n', j_ )
        rds2(j_) = 1;
        % Case 2: "Left"-turn
    elseif abs(dist_LL) == 1 % ring-j is turning-point; j-(j+1)-left
        %%fprintf( 'Ring %i is a LEFT turning-point.\n', j_ )
        rds2(j_) = -1;
        % Case 3: Straight, no-turn
    else % ring-j is non-turning-point; j-(j+1)-straight
        %%fprintf( 'Ring %i is a STRAIGHT non-turning-point.\n', j_ )
        rds2(j_) = 0;
    end

    at_refR = at_refR_next; % Update at_refR
    at_refL = at_refL_next; % Update at_refL
    %pause
end
%rds2
%sum( rds2 )

% Check validity of rds1 & rds2:
if ~ifMobius
    assert( isequal( rds1, rds2 ) )
else
    assert( isequal( rds1, -rds2 ) )
end

% For Mobius belt, rds should be a combination of rds1 and
% rds2, due to the non-oritentable property:
if ifMobius
    rds = [ rds2(1), rds1(2:end), rds1(1), rds2(2:end) ];
else
    rds = rds1;
end


if ifMobius
    fprintf( '\nThis is a Mobius ' )
else
    fprintf( '\nThis is a Huckel ' )
end

if sum( rds ) == 0
    if isequal( rds1, zeros(1,NR) )
        fprintf( 'zigzag ' )
    elseif isequal( rds, 2*rem(1:NR,2) - 1 ) || ...
            isequal( rds, 1 - 2*rem(1:NR,2) )
        fprintf( 'armchair ' )
    else
        fprintf( 'chiral ' )
    end
    fprintf( 'CNB\n' )
elseif abs( sum( rds ) ) == 6
    if abs( sum( rds ) ) == sum( abs(rds) )
        fprintf( 'kekulene\n' )
    else
        fprintf( 'clarene\n' )
    end
else
    fprintf( 'nanobelt of other type\n' )
end


% From rds to path code:
ix_tp = find( rds ~= 0 ); % Indices of turning-point rings
Ntp = length( ix_tp( ix_tp <= NR ) );
fprintf( '%i turning-point rings\n', Ntp )
% Special case of zigzag type:
if Ntp == 0
    % if ~ifMobius
    %     pathcode = NR;
    % else
    %     pathcode = -NR;
    % end
    pathcode = -NR;

    pathcode_enc = encode_belt_code( pathcode, ifMobius );
    fprintf( '%i-fold topological symmetry\n', NR );
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

[ rep_code, N_rep ] = find_periodic_unit( pathcode );
if N_rep > 1
    fprintf( '%i-fold topological symmetry\n', N_rep );
else
    fprintf( 'No topological symmetry\n' );
end

%pathcode
pathcode_enc = encode_belt_code( pathcode, ifMobius );

%num2str(rds)
end