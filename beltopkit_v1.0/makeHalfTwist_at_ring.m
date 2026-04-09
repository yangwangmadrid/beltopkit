%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Get all possible nonequivalent MCNBs by making a half-twist at a given
% ring of index ir

function pathcode_MCNB_all = makeHalfTwist_at_ring( RDS, ir )
% RDS: RDS of parent CNB
% ir: index of ring at which the half-twist takes place
NR = length( RDS );
% Circularlly shift ir to pos.2, so (ir-1)==>1, (ir-2)==>NR;(ir+1)==>3:
RDS = circshift( RDS, 1 - ir);


% 1. Construction mode 1:
RDS_MCNB_1 = [ 0, -RDS(2:NR), 0, RDS(2:NR) ];
% 2. Construction mode 2:
RDS_MCNB_2 = [ 1, -RDS(2:NR), -1, RDS(2:NR) ];
% 3. Construction mode 3:
RDS_MCNB_3 = [ -1, -RDS(2:NR), 1, RDS(2:NR) ];


RDS_MCNB_all = [ RDS_MCNB_1; RDS_MCNB_2; RDS_MCNB_3 ];


%============ OPTION 1 (slower): Eliminate duplicated results =========== 
% % Eliminate circular duplicates:
% RDS_MCNB_noneq = removeCircularDuplicates( RDS_MCNB_all );
% N_MCNB = size( RDS_MCNB_noneq, 1 );
% pathcode_MCNB_all = cell( N_MCNB, 1 );
% for j = 1 : N_MCNB
%     pathcode_MCNB_all{j,1} = rds2pathcode( RDS_MCNB_noneq(j,:) );
%     % For the special case of zigzag (n,0) MCNB:
%     if length(pathcode_MCNB_all{j,1}) == 1 && all(pathcode_MCNB_all{j,1}<0)
%         pathcode_MCNB_all{j,1} = pathcode_MCNB_all{j,1} / 2;
%     end
% end

%============ OPTION 2 (faster): include duplicated results ===========
pathcode_MCNB_all = cell( 3, 1 );
for j = 1 : 3
    pathcode_MCNB_all{j,1} = rds2pathcode( RDS_MCNB_all(j,:) );
    % For the special case of zigzag (n,0) MCNB:
    if length(pathcode_MCNB_all{j,1}) == 1 && all(pathcode_MCNB_all{j,1}<0)
        pathcode_MCNB_all{j,1} = pathcode_MCNB_all{j,1} / 2;
    end
end

end