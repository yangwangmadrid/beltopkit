%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function coord_fin = optCoord_ring_centers( coord_ini, bondList, ...
    angleList, angleTypeList )
% inp: xyz coordinates file

% Setting values:
d0 = 1.42*sqrt(3); % Equilibrium distance between adjacent rings in Angstrom
a0_0 = 180.; % Equilibrium angle of straight ring--ring--ring in Degree
a0_1 = 120.; % Equilibrium angle of armchair ring--ring--ring in Degree
% Force constant of angle potential (relative to bond force constant)
k_ang = 0.4;


% Geom. opt. using quasi-Newton method:
options = optimoptions( @fminunc, 'Algorithm','quasi-newton', ...
    'MaxIterations', 200, ...
    'Display','none' ... %'Display','iter' ...
    );


[ coord_fin, ~, exitflag, output ] = ...
    fminunc( @(coord_ini) ...
    potentialEnergy_ring_centers( coord_ini, bondList, angleList, angleTypeList, ...
    d0, a0_0, a0_1, k_ang ), ...
    coord_ini, options );

niter = output.iterations - 1;

if exitflag < 0
    error( 'Geometry optimization not successful: exitflag = %i', exitflag )
end

fprintf( 'Geometry optimization done after %i iterations\n', niter );

end