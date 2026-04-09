%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%
function write_gjf( outp, coord, elem, title )

if nargin == 3
    title = outp;
end
if nargin == 2
    title = outp;
    elem = {};
    for j = 1 : size(coord,1)
        elem{j} = 'C';
    end
end

if ~iscell( elem )
    elem_val = elem;
    elem = cell( size( coord, 1 ) );
    for j = 1 : size( coord, 1 )
        elem{j} = elem_val;
    end
end

fid = fopen( outp, 'w' );
fprintf( fid, '#P wB97XD/cc-pVDZ OPT NOSYMM' );
fprintf( fid, '\n\n%s\n\n0 1\n', title );
for j = 1 : size(coord,1)
    fprintf( fid, '%3s  %12.6f %12.6f %12.6f\n', elem{j}, coord(j,:) );
end
fprintf( fid, '\n' );

fclose( fid );
if ~strcmpi( title, 'MUTE-MODE' )
    fprintf( 'Coordinates written to file %s\n', outp );
end

end