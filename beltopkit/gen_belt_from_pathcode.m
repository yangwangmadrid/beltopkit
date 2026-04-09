%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%

function [ coord, elem ] = gen_belt_from_pathcode( code, type, twist_rgix, ...
    ifCheckParallelType, nTwist )
% type: 0 --> parellel type;  1 --> radial type

IF_WRITE_TMP_GJF = false;

if nargin == 2
    twist_rgix = 0;
    ifCheckParallelType = true;
    nTwist = 0;
end
if nargin == 3
    ifCheckParallelType = true;
    if twist_rgix == 0
        nTwist = 0;
    else
        nTwist = 1;
    end
end

Rscale = 1.0;
% For nonhexagonal Mobius parallel-type CNBs using Rscale:
if type < 0
    Rscale = -type;
    type = 0;
end

% Auto-determine whether code is encoded or not:
if isnumeric( code )
    pathcode = code;
elseif ischar( code )
    pathcode = decode_belt_code( code );
else
    error( 'Input argument <code> must be a numeric array or a string'  )
end


rds = pathcode2rds( pathcode );
NR = length( rds );
fprintf( 'A total of %i rings\n', NR )
N_tp = sum(rds~=0);
fprintf( '%i turning points\n', N_tp )

if nTwist == 0
    ifMobius = false;
    assert( twist_rgix == 0 )
else
    ifMobius = mod( nTwist, 2 );
end
if ifMobius
    fprintf( 'The belt has Mobius topology.\n' )
else
    fprintf( 'The belt has Huckel topology.\n' )
end


% if ~ifMobius
%     rds = rds( [twist_rgix:end, 1:(twist_rgix-1)] );
% else
%     rds = [ rds(twist_rgix:end), -rds(1:(twist_rgix-1)) ];
% end
% if ifMobius
%     rds = [ rds( [twist_rgix:end, 1:(twist_rgix-1)] ), ...
%         -rds( [twist_rgix:end, 1:(twist_rgix-1)] ) ];
% end
if ifMobius
    rds = [ rds(twist_rgix:end), -rds(1:(twist_rgix-1)) ];
end
%num2str( rds )

d0_eq = 1.42; % Equilibrium C-C bond length in benzene ring
d_eq = d0_eq*sqrt(3); % Equilibrium interring distance


if type == 0 % parallel type:
    N_tp_macro = sum(pathcode<0);
    if ~ifMobius && ifCheckParallelType
        assert( N_tp_macro == sum( rds ) )
    end
    fprintf( '%i macro turning points\n', N_tp_macro )

    % Initial framework of ring centers:
    xyz_rings = zeros( NR, 3 );
    bondList_rings = zeros( NR, 2 );
    bondList_rings(1,:) = [1, 2];
    angleList_rings = zeros( NR, 3 );
    angleList_rings(1,:) = [NR, 1, 2];
    angleTypeList_rings = zeros( 1, NR );
    angleTypeList_rings(1) = 1;
    if N_tp_macro <= 6 % Planar algorithm to build the framework of ring centers
        dv = d_eq*[ 1 0 0 ]; % Inital dv is horizontal along +x direction
        for j = 2 : NR
            xyz_rings(j,:) = xyz_rings(j-1,:) + dv;
            j1 = j + 1;
            if j1 > NR
                j1 = 1;
            end
            j_1 = j - 1;
            bondList_rings(j,:) = [ j, j1 ];
            angleList_rings(j,:) = [ j_1, j, j1 ];
            angleTypeList_rings(j) = abs( rds(j) );
            if rds(j) == 1
                dv = rotateCoord( dv, [0 0 1], 60 );
            elseif rds(j) == -1
                dv = rotateCoord( dv, [0 0 1], 360-60 );
            end
        end
    else % 3D algorithm to build the framework of ring centers
        R = Rscale*d_eq/2/sin(pi/NR); % Radius of macrocycle
        xyz_rings(:,1) = R*sin( (1:NR)*(2*pi/NR) );
        xyz_rings(:,2) = R*cos( (1:NR)*(2*pi/NR) );
        xyz_rings(:,3) = 0;

        %===== Optimize xyz_rings[]: =====
        bondList_rings = [];
        angleList_rings = [];
        angleTypeList_rings = [];
        for j = 1 : NR
            if j < NR
                j1 = j+1;
            else
                j1 = 1;
            end
            if j > 1
                j_1 = j-1;
            else
                j_1 = NR;
            end
            bondList_rings = [ bondList_rings; j, j1 ];
            angleList_rings = [ angleList_rings; j_1, j, j1 ];
            angleTypeList_rings = [ angleTypeList_rings, abs( rds(j) ) ];
        end
    end
else % Radial type:
    xyz_rings_plan = zeros( NR+1, 3 );
    % First, generate 2D linear path:
    dv = d_eq*[ 1 0 0 ]; % Inital dv is horizontal along +x direction
    for j = 2 : NR+1
        xyz_rings_plan(j,:) = xyz_rings_plan(j-1,:) + dv;
        j0 = j;
        if j0 > NR
            j0 = j0 - NR;
        end
        if rds(j0) == 1
            dv = rotateCoord( dv, [0 0 1], 60 );
        elseif rds(j0) == -1
            dv = rotateCoord( dv, [0 0 1], 360-60 );
        end
    end
    v_belt = xyz_rings_plan(end,:) - xyz_rings_plan(1,:);
    v_curl = cross( [0 0 1], v_belt );
    v_curl = v_curl / norm(v_curl);
    scaleFactor = 1.8 * pi/(NR*sin(pi/NR));
    R_belt = scaleFactor * norm( v_belt ) / (2*pi);
    % Rolling up the belt:
    xyz_rings = zeros( NR, 3 );
    d_theta = 2*pi/NR;
    for j = 1 : NR
        xyz_rings( j, 1 ) = R_belt * cos( (j-1)*d_theta );
        xyz_rings( j, 2 ) = R_belt * sin( (j-1)*d_theta );
        vj = xyz_rings_plan(j,:) - xyz_rings_plan(1,:);
        xyz_rings( j, 3 ) = dot( vj, v_curl );
    end
    xyz_rings = centerize( xyz_rings );
end

% Optimize the primitive framework of ring centers for parallel type:
if type == 0
    xyz_rings = optCoord_ring_centers( xyz_rings, bondList_rings, ...
        angleList_rings, angleTypeList_rings );
    xyz_rings = centerize( xyz_rings );
    % Check opt.:
    bondlen_rings = [];
    for j = 1 : length(bondList_rings)
        bndlen = norm( xyz_rings(bondList_rings(j,1),:) ...
            - xyz_rings(bondList_rings(j,2),:) );
        bondlen_rings = [ bondlen_rings, bndlen ];
    end
    %assert( max(abs(bondlen_rings - d_eq)) < 0.01 )
    angle_rings = [];
    for j = 1 : length(angleList_rings)
        v1 = xyz_rings(angleList_rings(j,1),:) - xyz_rings(angleList_rings(j,2),:);
        v2 = xyz_rings(angleList_rings(j,3),:) - xyz_rings(angleList_rings(j,2),:);
        ang = acos( dot(v1,v2)/norm(v1)/norm(v2) )*180/pi;
        angle_rings = [ angle_rings, ang ];
    end
    %angle_rings
    %assert( max(abs(angle_rings - (180-60*(angleTypeList_rings)))) < 0.1 )
end

% Check validity of carbon framework:
for j = 1 : NR
    for k = j+1 : NR
        if norm( xyz_rings(j,:) - xyz_rings(k,:) ) < 1e-6
            fprintf( 'WARNING: Failed to generate correct structure\n' )
            coord = [];
            elem = {};
            return
        end
    end
end

% Write the coord. at this step for debugging purpose:
if IF_WRITE_TMP_GJF
    write_gjf( 'framework_ring_centers.gjf', xyz_rings, 'C' )
end

% Generate isolated bezene rings around each of the ring centers:
[ V, ~ ] = eig( xyz_rings'*xyz_rings );
vn_macro = V(:,1); % normal of the macrocycle:
xyz_iso = zeros( NR*6, 3 );
iat = 1;
if type == 0 % parallel type:
    for j = 1 : NR
        if j < NR
            j1 = j+1;
        else
            j1 = 1;
        end
        if j > 1
            j_1 = j-1;
        else
            j_1 = NR;
        end
        v1 = xyz_rings(j1,:) - xyz_rings(j,:); % Vector j-->(j+1)
        v2 = xyz_rings(j_1,:) - xyz_rings(j,:); % Vector j-->(j-1)
        %assert( abs(acos( dot(v1,v2)/norm(v1)/norm(v2) )*180/pi - angle_rings(j)) < 0.1 )
        vn = cross(v1,v2) + eps*ones(1,3);
        %vn = cross(v1,xyz_rings(j,:));
        vn = vn/norm(vn);
        v1_scaled = v1*sqrt(3)/4;
        xyz_benzene = zeros(6,3); % 6 vertices with respect to ring center:
        for k = 1 : 6
            rotang = -30 + (k-1)*60;
            if rotang < 0
                rotang = rotang + 360;
            end
            xyz_benzene(k,:) = rotateCoord( v1_scaled, -vn_macro, rotang ) ...
                + xyz_rings(j,:);
        end
        % Orientate xyz_benzene[] to align with the reference axis:
        if nTwist == 0 % Untwisted 
            for k = 1 : 6
                xyz_iso(iat,:) = xyz_benzene(k,:);
                iat = iat + 1;
            end
        else % (Multiply-)twisted
            vr = v1 - v2; % rotation axis
            ang = (j-twist_rgix)*180/NR*nTwist;
            if ang < 0
                ang = ang + 360;
            end
            xyz_benzene_center = mean( xyz_benzene );
            xyz_benzene = rotateCoord( centerize(xyz_benzene), vr, ang );
            for k = 1 : 6
                xyz_iso(iat,:) = xyz_benzene(k,:) + xyz_benzene_center;
                iat = iat + 1;
            end
        end
    end
else % Radial type:
    for j = 1 : NR
        if j < NR
            j1 = j+1;
        else
            j1 = 1;
        end
        v1 = xyz_rings(j1,:) - xyz_rings(j,:); % Vector j-->(j+1)
        vn = cross(v1,xyz_rings(j,:));
        vn = vn/norm(vn);
        v1_scaled = v1*sqrt(3)/4;
        xyz_benzene = zeros(6,3); % 6 vertices with respect to ring center:
        for k = 1 : 6
            rotang = -30 + (k-1)*60;
            if rotang < 0
                rotang = rotang + 360;
            end
            xyz_benzene(k,:) = rotateCoord( v1_scaled, -vn, rotang ) ...
                + xyz_rings(j,:);
        end
        % Orientate xyz_benzene[] to align with the reference axis:
        v_ref = xyz_rings(j,:);
        vr = cross( vn, v_ref ); % rotation axis
        ang = acos( dot(vn, v_ref) )*180/pi;
        xyz_benzene_center = mean( xyz_benzene );
        xyz_benzene = rotateCoord( centerize(xyz_benzene), vr, ang );
        if ifMobius % Singly-twisted
            %vr = v1 - v2; % rotation axis
            vr = cross( xyz_rings(j,:), vn_macro );
            ang = (j-twist_rgix)*180/NR;
            if ang < 0
                ang = ang + 360;
            end
            xyz_benzene = rotateCoord( centerize(xyz_benzene), vr, ang );
        end
        for k = 1 : 6
            xyz_iso(iat,:) = xyz_benzene(k,:) + xyz_benzene_center;
            iat = iat + 1;
        end
    end
end

%Write the coord. at this step for debugging purpose:
if IF_WRITE_TMP_GJF
    write_gjf( 'xyz_iso.gjf', xyz_iso, 'C' )
end

% Average interring bonds and get connectivity:
xyz = zeros( NR*4, 3 );
bondList = zeros( NR*5, 2 );
for j = 1 : NR
    if j > 1
        j_1 = j-1;
    else
        j_1 = NR;
    end

    % Get bond between ring-j and ring-(j+1):
    if rds(j) == 0 % Straight ring
        at1_j = (j-1)*6 + 4;
        at2_j = (j-1)*6 + 5;
        at3_j = (j-1)*6 + 6;
        at4_j = (j-1)*6 + 3;
    elseif rds(j) == 1  % "Right" turning-point ring
        at1_j = (j-1)*6 + 5;
        at2_j = (j-1)*6 + 6;
        at3_j = (j-1)*6 + 3;
        at4_j = (j-1)*6 + 4;
    elseif rds(j) == -1 % "Left" turning-point ring
        at1_j = (j-1)*6 + 3;
        at2_j = (j-1)*6 + 4;
        at3_j = (j-1)*6 + 5;
        at4_j = (j-1)*6 + 6;
    else
        error( 'Wrong rds(%i): %i', j, rds(j) )
    end
    % From previous ring:
    at1_j_1 = (j_1-1)*6 + 2;
    at2_j_1 = (j_1-1)*6 + 1;

    xyz( (j-1)*4 + 1, : ) = mean([ xyz_iso(at1_j,:); xyz_iso(at1_j_1,:) ]);
    xyz( (j-1)*4 + 2, : ) = mean([ xyz_iso(at2_j,:); xyz_iso(at2_j_1,:) ]);
    xyz( (j-1)*4 + 3, : ) = xyz_iso(at3_j,:);
    xyz( (j-1)*4 + 4, : ) = xyz_iso(at4_j,:);

    % fprintf('=========\n')
    % j
    % rds(j)
    % at1_j, at1_j_1
    % at2_j, at2_j_1
    % at3_j, at4_j
    % fprintf('=========\n')
    % pause

    bondList( (j-1)*5 + 1, : ) = [ (j-1)*4 + 1, (j-1)*4 + 2 ];
    if j < NR
        next_at1 = (j-1)*4 + 5;
        next_at2 = (j-1)*4 + 6;
    else
        next_at1 = 1;
        next_at2 = 2;
    end
    if rds(j) == 0 % Straight ring
        bondList( (j-1)*5 + 2, : ) = [ (j-1)*4 + 2, (j-1)*4 + 3 ];
        bondList( (j-1)*5 + 3, : ) = [ (j-1)*4 + 3, next_at2 ];
        bondList( (j-1)*5 + 4, : ) = [ next_at1, (j-1)*4 + 4 ];
        bondList( (j-1)*5 + 5, : ) = [ (j-1)*4 + 4, (j-1)*4 + 1 ];
    elseif rds(j) == 1  % "Right" turning-point ring
        bondList( (j-1)*5 + 2, : ) = [ (j-1)*4 + 2, next_at2 ];
        bondList( (j-1)*5 + 3, : ) = [ next_at1, (j-1)*4 + 3 ];
        bondList( (j-1)*5 + 4, : ) = [ (j-1)*4 + 3, (j-1)*4 + 4 ];
        bondList( (j-1)*5 + 5, : ) = [ (j-1)*4 + 4, (j-1)*4 + 1 ];
    elseif rds(j) == -1 % "Left" turning-point ring
        bondList( (j-1)*5 + 2, : ) = [ (j-1)*4 + 2, (j-1)*4 + 3 ];
        bondList( (j-1)*5 + 3, : ) = [ (j-1)*4 + 3, (j-1)*4 + 4 ];
        bondList( (j-1)*5 + 4, : ) = [ (j-1)*4 + 4, next_at2 ];
        bondList( (j-1)*5 + 5, : ) = [ next_at1, (j-1)*4 + 1 ];
    end
end

% Update bondList[] for singly-twisted Mobius:
if ifMobius
    j1 = 0;
    j2 = 0;
    for j = size(bondList,1) : -1 : 1
        if ismember( 1, bondList(j,:) )
            nb1 = setdiff( bondList(j,:), 1 );
            j1 = j;
        elseif ismember( 2, bondList(j,:) )
            nb2 = setdiff( bondList(j,:), 2 );
            j2 = j;
        end
        if j1 > 0 && j2 > 0
            break
        end
    end
    bondList(j1,:) = [ 2 nb1 ];
    bondList(j2,:) = [ nb2 1 ];
end

% Write the coord. at this step for debugging purpose:
if IF_WRITE_TMP_GJF
    write_gjf( 'xyz.gjf', xyz, 'C' )
end

NAt = size(xyz,1);
angleList = getAngleList( NAt, bondList );
xyz_opt = optCoord( xyz, bondList, angleList );

% Add H atoms:
[ coord, elem ] = addH( xyz_opt, linkage(xyz_opt) );
NC = size( xyz, 1 );
NH = length( elem ) - NC;
assert( NC == NR*4 )
if NH ~= NR*2
    if type == 0 && Rscale == 1
        fprintf( 'Invalid structure obtained\n' )
        Rscale = 2.2;
        fprintf( 'Trying a scaled algorithm (Rscale = %f) ...\n', Rscale )
        coord = [];
        elem = {};
        [ coord, elem ] = gen_belt_from_pathcode( code, -Rscale, twist_rgix, ifCheckParallelType, nTwist );
    else
        fprintf( 'WARNING: Failed to generate correct structure with H atoms\n' )
        fprintf( '  ==> Adding H atoms directly to unoptimize C framework\n' )
    	[ coord, elem ] = addH( xyz, linkage(xyz) );
        if IF_WRITE_TMP_GJF
            title = sprintf( 'C%iH%i?? with framework unoptimized', NC, NH );
            write_gjf( 'xyz_opt.gjf', coord, elem, title )
        end
        
        %error( 'Failed to generate correct structure' )
        %fprintf( 'WARNING: Failed to generate correct structure\n' )
        %coord = [];
        %elem = {};
    end
    return
end

% Write the coord. at this step for debugging purpose:
if IF_WRITE_TMP_GJF
    title = sprintf( 'C%iH%i', NC, NH );
    write_gjf( 'xyz_opt.gjf', coord, elem, title )
end

end
