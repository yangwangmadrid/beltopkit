%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% linkage.m
% Get linkage matrix from coordinates
function [ lm, iswarning ] = linkage( coord, MAX_BONDLEN )
% Parameters:
%   coord <N*3 matrix>: coordinates of molecule
%
% Return:
%   lm <N*N matrix>: linkage matrix

% =========== CONSTANTS ===========
if nargin == 1
    MAX_BONDLEN = 1.75;
end
% =================================

iswarning = false;

sz = size( coord );
N = sz(1);

% check number of atoms
if(  mod(N,2) == 1 )
    %error( 'Number of atoms is %i.\n It should be even.', N );    
    %  fprintf( 'Warning: Number of atoms is %i.\n It should be even.\n', N );    
end

for iat1 = 1 : N
    for iat2 = 1 : N        
        if( iat1 == iat2)
            lm(iat1, iat2) = 0;
        else
            lm(iat1, iat2) = ...
                norm( coord(iat1,:) - coord(iat2,:) ) <= MAX_BONDLEN;
        end
    end 
end

% check linkages
if(  ~all( sum(lm) == 3) )
    %error( 'Not all atoms have coordination number of 3.' );
    % fprintf( 'Warning: Not all atoms have coordination number of 3.\n' );
    iswarning = true;
    
    % fprintf(' %i\n', length(lm));
    slm = sum(lm);
    % ix = find( slm~= 3 )
    % fprintf('Atom %i with coordination number of %i.\n', ix, slm(ix));
end
