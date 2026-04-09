%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% rotateCoord.m
% Rotation operation on a set of coordinates
function newcoord = rotateCoord(coord, tv, a_n)
% Parameters:
%   coord <n*3 matrix>: a set of coordinates
%                NOTE: The molecule should be centerized.
%                      You can use the 'centerize' function.
%   tv <vector>: directional vector of the rotation axis
%   a_n <number>: 
%                 >=0 :  rotation angle = a_n degree
%                 <0  :  order of the rotation axis = -a_n
% Return:
%   newcoord <structure>:  new set of coordinates

if(size(tv) == [1 3])
    tv = tv';
elseif(size(tv) ~= [3 1])
    error('tv should be a column vector (3*1 matrix).');
    return;
end

if( tv == [ 0 0 0 ]')
    newcoord = coord;
    return;
end

if(a_n >= 0)
    ha = a_n*pi/360; % half of rotation angle
else
    ha = -pi/a_n; % half of rotation angle
end

tv = tv / norm(tv);
R = coord(:, :);

% case for C_2 rotation
if( abs(a_n - 180) <= eps | a_n == -2)
    newcoord(:, :) = ...
        -R + 2*(R*tv)*tv';
    return;
end

Q = R - (R*tv)*tv';
sz = size(coord);
for k = 1 : sz(1)
    if( norm(Q(k,:)) == 0 )
        newcoord(k, :) = R(k,:);
        continue;
    end
    u = cross(Q(k,:)',tv)/(tan(ha)+eps);
    v = u'-Q(k,:);
    newcoord(k, :) = ...
        R(k,:) + 2*sin(ha)*norm(Q(k,:))* ( v / norm(v) );
end


