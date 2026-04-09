%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================


function demo_gen_geom3d_from_pathcode()

addpath ../../

fprintf('==========================================\n');
fprintf('   CNB/MCNB 3D Geometry Generation Menu  \n');
fprintf('==========================================\n');
fprintf('[1] octulene.xyz\n');
fprintf('[2] exp_25_25_MCNB.xyz\n');
fprintf('[3] exp_24_TMCNB.xyz\n');
fprintf('[4] exp_inf12.xyz\n');
fprintf('[5] exp_inf16.xyz\n');
fprintf('[6] exp_inf20.xyz\n');
fprintf('------------------------------------------\n');
choice = input('Select an example to execute: ');

% Checker to detect if choice is not a number from 1 to 6
if isempty(choice) || ~isnumeric(choice) || ~any(choice == 1:6)
    error('Invalid selection! You must enter a number between 1 and 6. Terminating script.');
end

if choice == 1
% Octulene:
pathcode = ones(1,8)*-2; % 'YXX82'
outp = 'octulene.xyz';
type = 0; % parellel type
twist_rgix = 0;
nTwist = 0;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end

if choice == 2
% Exp. (25,25) [50]MCNB:
pathcode = ones(1,25)*2; % '1-XXP2'
outp = 'exp_25_25_MCNB.xyz';
type = 1; % radial type
twist_rgix = 1;
nTwist = 1;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end

if choice == 3
% Exp. triply twisted [24]MCNB:
pathcode = repmat( [2 -2 -2 -2], 1, 3 ); % '3-YXX302X32'
outp = 'exp_24_TMCNB.xyz';
type = 0; % parellel type
twist_rgix = 2;
nTwist = 3;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end

if choice == 4
% Exp. [12]Infinitene:
pathcode = decode_belt_code( 'YXX201X51' ); % '2-YXX201X51'
outp = 'exp_inf12.xyz';
type = 0; % parellel type
twist_rgix = 1;
nTwist = 2;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end


if choice == 5
% Exp. [16]Infinitene:
pathcode = decode_belt_code( 'YXX2022X212' ); % '2-YXX2022X212'
outp = 'exp_inf16.xyz';
type = 0; % parellel type
twist_rgix = 1;
nTwist = 2;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end


if choice == 6
% Exp. [20]Infinitene:
pathcode = decode_belt_code( 'YXX2011X42' ); % '2-YXX2011X42'
outp = 'exp_inf20.xyz';
type = 0; % parellel type
twist_rgix = 1;
nTwist = 2;
gen_geom3d_from_pathcode( pathcode, outp, type, twist_rgix, nTwist )
end

end


function gen_geom3d_from_pathcode( code, outp, type, twist_rgix, nTwist )

fprintf('Target path code: [%s]\n', num2str(code));
fprintf('Output filename:  %s\n\n', outp);
% Generate geometry
fprintf('Generating 3D coordinates ...\n');
[ coord, elem ] = gen_belt_from_pathcode( code, type, twist_rgix, false, nTwist );
fprintf('Done.\n\n');
% Write XYZ file
write_xyz( outp, coord, elem, outp );
% Verify path code:
fprintf('\nRe-calculating path code from file for verification ...\n');
code_read = belt_code( outp );
fprintf('Read path code:   [%s]\n', num2str(code_read));
assert(isequal(code_read, code), 'Error: Path code mismatch detected!');
fprintf('--- Verification passed: Path codes are identical ---\n\n');

end