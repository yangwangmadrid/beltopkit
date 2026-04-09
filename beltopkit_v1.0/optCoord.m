%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function coord_fin = optCoord( coord_ini, bondList, angleList )
% inp: xyz coordinates file

% Setting values:
d0 = 1.42; % Equilibrium distance of C--C bond in Angstrom
MAX_CC_BONDLEN = 1.75; % Angstrom
a0 = 120.; % Equilibrium angle of C--C--C in Degree
% Force constant of angle potential (relative to bond force constant)
k_ang = 0.4; % Originally 0.4, but failed for generating Mob_R10-6_4-C40H20_04-09-enant.gjf
             % and Mob_R10-6_4-C40H20_04-17-enant.gjf
             % By now, 0.2 seems the best value for k_ang
% Force constant of dihedral potential (relative to bond force constant)
k_dih = 0.2;


% Geom. opt. using quasi-Newton method:
options = optimoptions( @fminunc, 'Algorithm','quasi-newton', ...
    'MaxIterations', 200, ...
    'Display','none' ... %'Display','iter' ...
    );


[ coord_fin, ~, exitflag, output ] = ...
    fminunc( @(coord_ini) ...
    potentialEnergy( coord_ini, bondList, angleList, d0, a0, k_ang ), ...
    coord_ini, options );

niter = output.iterations - 1;

if exitflag < 0
    error( 'Geometry optimization not successful: exitflag = %i', exitflag )
end

fprintf( 'Geometry optimization done after %i iterations\n', niter );

end