%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Copyright 2023 Yang Wang
% All rights reserved
% 
% Author:
% Yang Wang (yangwang@yzu.edu.cn)
% 
% -------------------------------------------------------------------------
% 
% This file is part of GenCNB.
% 
% GenCNB is free software: you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free 
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
% 
% GenCNB is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more 
% details.
% 
% You should have received a copy of the GNU General Public License along 
% with GenCNB. If not, see <https://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

%
function write_xyz( outp, coord, elem, title )

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

N = size(coord,1); % Number of atoms

fid = fopen( outp, 'w' );
fprintf( fid, '%i\n', N );
fprintf( fid, '%s\n', title );
for j = 1 : N
    fprintf( fid, '%3s  %12.6f %12.6f %12.6f\n', elem{j}, coord(j,:) );
end

fclose( fid );
if ~strcmpi( title, 'MUTE-MODE' )
    fprintf( 'Coordinates written to file %s\n', outp );
end

end