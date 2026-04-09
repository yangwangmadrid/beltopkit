%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% A purely topological method for generating MCNBs from an untwisted CNB

function pathcode_MCNB_all = genMCNBs_from_CNB_topo( inp )
% inp: coord. filename or coord matrix or pathcode

pathcode = [];
if ischar( inp )
    coord0 = loadcoord_carbon( inp );
elseif ismatrix( inp )
    if size(inp,1) == 1 && size(inp,2) == 3
        coord0 = inp;
    else
        pathcode = inp;
        NR = sum( abs(pathcode) );
    end
else
    error( 'Input argument must be a filename or an adjacency matrix' )
end

global pot_form
pot_form = 2;

if isempty( pathcode )
    lm = linkage( coord0 );
    CN = sum( lm );
    NAt = length( lm );

    ringcell = lm2rings( lm );
    NR = length( ringcell );
    fprintf( '%i rings\n', NR );
    %ringcell{:}

    %============================================================
    % Get the ORIGINAL bond list and angle list:
    %------------------------------------------------------------
    bondList0 = getBondList( coord0 );
    Nbond = size( bondList0, 1 );

    lm_ring = linkage_ring( ringcell );
    nblist_ring = neighbors_ring( lm_ring );
    sq = macrocycle_ring( nblist_ring ); % Macrocyclic sequence of rings

    % Update the order of ringcell{}:
    ringcell0 = ringcell;
    for j = 1 : NR
        ringcell{j} = ringcell0{ sq(j) };
    end
    % for j = 1 : NR
    %     fprintf( '%2i:', j );
    %     fprintf( ' %2i', ringcell{j} );
    %     fprintf( '\n' );
    % end
    % fprintf( '\n' );

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

    % Get rings being turning points or not:
    ring_tp = zeros( 1, NR );
    for j = 1 : NR
        bnd1 = bnd_conn( j, : );
        if j > 1
            bnd2 = bnd_conn( j-1, : );
        else
            bnd2 = bnd_conn( NR, : );
        end
        for at1 = bnd1
            for at2 = bnd2
                if lm( at1, at2 )
                    ring_tp(j) = 1;
                    break
                end
            end
            if ring_tp(j)
                break
            end
        end
    end
    %ring_tp

    % Get path segments:
    ix_ring_tp = find( ring_tp == 1 );
    if isempty( ix_ring_tp ) % Special case of zigzag CNB:
        pathcode = [ NR ];
    else
        ix_loop_ring_tp = [ ix_ring_tp, NR+ix_ring_tp(1) ];
        tau = length( ix_ring_tp );
        pathcode = zeros( 1, tau );
        for j = 1 : tau
            pathcode(j) = ix_loop_ring_tp(j+1) - ix_loop_ring_tp(j);
        end
    end
end


rds = pathcode2rds( pathcode );

% pathcode_can = pathcode_canon( pathcode );
% fprintf( 'Path code: [' );
% fprintf( ' %i', pathcode );
% fprintf( ' ]\n' );
% fprintf( 'Canonical path code: [' );
% fprintf( ' %i', pathcode_can );
% fprintf( ' ]\n' );
% fprintf( '\n' );
% fprintf( 'RDS:\n' );
% fprintf( ' %i', rds );
% fprintf( '\n' );
% fprintf( '-------------------------------------------------------\n' );

%========== Use nonequiv. rings ==========
% % Get nonequiv. rings:
% ix_noneq_ring = nonequi_pos( rds );
% NR_uniq = length( ix_noneq_ring );
% fprintf( 'All %i rings --> %i symm. nonequiv. rings\n', ...
%     NR, NR_uniq )
% % Run over all uniq. rings, each as a twisting position:
% pathcode_MCNB_all = [];
% for ir = 1 : NR_uniq    
%     ix_tw_rg = ix_noneq_ring( ir );
%     pathcode_MCNB_ir = makeHalfTwist_at_ring( rds, ix_tw_rg );
%     pathcode_MCNB_all = [ pathcode_MCNB_all; pathcode_MCNB_ir ];
% end


%========== Use ALL RINGS ==========
% Run over ALL rings, each as a twisting position:
pathcode_MCNB_all = [];
for ir = 1 : NR    
    pathcode_MCNB_ir = makeHalfTwist_at_ring( rds, ir );
    pathcode_MCNB_all = [ pathcode_MCNB_all; pathcode_MCNB_ir ];
    
    % if any( cellfun(@(a) isequal(a, [4 4 4]), pathcode_MCNB_ir))
    %     pathcode_MCNB_ir
    %     ir, 
    %     pcode = segdir2pathcode( rds ), 
    %     encode_belt_code( pcode )
    %     pause
    % end
end

pathcode_MCNB_all = uniq_cell_arrays( pathcode_MCNB_all );


end
