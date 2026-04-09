%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function demo_path_codes()

addpath ../../

files = {
    'CNB_6_6-16.xyz';
    'CNB_8_8-108.xyz';
    'CNB_12_12-12235.xyz';
    'kekulene.xyz';
    'septulene.xyz';
    'octulene.xyz';
    'expKek_34.xyz';
    'expKek_35.xyz';
    'expKek_44.xyz';
    'expKek_45.xyz';
    'YX2011X3212.xyz';
    'YXX21X22.xyz';
    'MCNB_25_25.xyz';
    'infinitene_R12.xyz';
    'infinitene_R16.xyz';
    'infinitene_R20.xyz';
    'triple_MCNB_R24.xyz'
};

for j = 1 : length(files)
    f = files{j};
    fprintf( '\n==================================================\n' );
    fprintf( 'Generalized CNB %s:\n', f );
    [ pathcode, pathstring, rds, ringcell ] = belt_code( f );
    fprintf( '--------------------------------------------------\n')
    fprintf( 'Path code:\n  [')
    fprintf( ' %i', pathcode )
    fprintf( ' ]\n' )
    fprintf( 'Path string:\n  %s\n', pathstring)
    fprintf( 'RDS:\n  {')
    for k = 1 : length(rds)
        fprintf( ' %i', rds(k) );
        if mod(k,20) == 0
            fprintf( '\n   ' );
        end
    end
    fprintf( ' }\n' )
    fprintf( '--------------------------------------------------\n')
    fprintf( '==================================================\n' );
end

end