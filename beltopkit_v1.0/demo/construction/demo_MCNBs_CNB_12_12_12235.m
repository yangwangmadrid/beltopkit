%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function demo_MCNBs_CNB_12_12_12235()

addpath ../../

code = ones(1,12)*2;
code_MCNB_all = genMCNBs_from_CNB_topo( code );
Niso = length( code_MCNB_all );
fprintf( '%i nonequivalent Moebius topoisomers generated:\n', Niso );
for j = 1 : Niso
    fprintf( 'Isomer %2i: [', j );
    fprintf( ' %i', code_MCNB_all{j} );
    fprintf( ' ]\n' );
end

end