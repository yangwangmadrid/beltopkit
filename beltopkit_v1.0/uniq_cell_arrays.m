%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Remove duplicate arrays from a cell array A where each cell contains an 
% array of integers (possibly varying lengths)
%   B - cell array of unique arrays
%   idx - indices of the first occurrences in the original array A

function [B, idx] = uniq_cell_arrays(A)

    M = containers.Map('KeyType','char','ValueType','logical');
    B = {};
    idx = [];

    for i = 1:numel(A)
        key = sprintf('%d,', A{i});
        if ~isKey(M, key)
            M(key) = true;
            B{end+1,1} = A{i};
            idx(end+1,1) = i;
        end
    end
end