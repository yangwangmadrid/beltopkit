%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Encode a given CANONICAL path code for a nanobelt
%
% Rules (Valid for numbers up to 160):
% 1. Use 1-9, A-W to represent a positive integer n (n<=32);
%    If 33 <= n <= 64, then add 'Z' as a leading character followed by the
%    character representing the number (n-32);
%    If 65 <= n <= 96, then add 'ZX' as leading characters followed by the
%    character representing the number (n-64);
%    If 97 <= n <= 128, then add 'ZY' as leading characters followed by the
%    character representing the number (n-96);
%    If 129 <= n <= 160, then add 'ZZ' as leading characters followed by the
%    character representing the number (n-128).
%
% 2. For a negative integer n, add a leading '0' followed by the character
%    representing the positive number abs(n) as given by rule 1.
%
% 3. If there are more negative numbers than postive numbers in the path
%    code, put a leading 'Y' in the whole encoded string, followed by the
%    string that encodes the opposite numbers of all numbers in original
%    path code. This rule does NOT apply to path code segments.
%
% 4. If there are repeating units in the path code, write a compact form as
%    follows:
%      Put a leading 'XX' in the whole encoded string. The next encoded
%      number represents the number of repeating units, followed by the 
%      ENCODED repeating unit.
%
% 5. If some segments of path code contain a SINGLE repeating number (not a
%    patterning containing more than one number) and the num. of units >= 2, 
%    then apply rules 4 within each of the segments but using only a 
%    SINGLE leading 'X' instead of 'XX'.
%
% 6. 'Y' is used only ONCE and 'Y' ALWAYS precedes any 'X'.
%
% 7. For a Mobius belt, add a leading '0' to the entire encoding 'Y'; this 
%    prefix '0' is used only ONCE and ALWAYS precedes 'Y' (if any).
%
% NOTE: (As corollaries)
%      (1) 'X' can be used repeatedly whenever applicable, while 'Y' can be
%       usded only ONCE for the ENTIRE path code. 
%      (2) 'X' can never be followed by '0' or 'Y'.
%


function code = encode_belt_code( pathcode, ifMobius, ifSeg, ifX, ifY )

if nargin == 1
    ifMobius = false;
    ifSeg = true;
    ifX = true;
    ifY = true;
elseif nargin == 2
    ifSeg = true;
    ifX = true;
    ifY = true;
elseif nargin == 3
    ifX = true;
    ifY = true;
elseif nargin == 4
    ifY = true;
end

%Rule 7: Prefix '1-' for singly-twisted Mobius belt and ALWAYS preceding 'Y'
if ifMobius
    code = strcat( '1-', encode_belt_code( pathcode, false, ifSeg, ifX, ifY ) );
    return
end

% Rule 3: more negative numbers than positive numbers
% Rule 6: 'Y' ALWAYS precedes 'X'
if ifY
    %if length(pathcode) > 1 && sum( pathcode < 0) > sum( pathcode > 0)
    if sum( pathcode < 0) > sum( pathcode > 0)
        code = strcat( 'Y', encode_belt_code( -pathcode, ifMobius, ifSeg, ifX, ifY ) );
        return
    end
end

% Rule 4: repeating units
if ifX
    [ rep_code, N_rep ] = find_periodic_unit( pathcode );
    if N_rep > 1
        if ifSeg
            code = strcat( 'XX', encode_a_number( N_rep ) );
        else
            code = strcat( 'X', encode_a_number( N_rep ) );
        end
        code_unit = encode_belt_code( rep_code, ifMobius, ifSeg, ifX, ifY );
        code = strcat( code, code_unit );
        return
    end
end

% Rule 5: find segments containg >=2 repeating number:
if ifSeg
    code = [];
    x_1 = pathcode(1); % Previous element
    count = 1;
    for j = 2 : length(pathcode)+1
        if j <= length(pathcode) && pathcode(j) == x_1
            count = count + 1;
        else
            if count >= 2
                code = ...
                    strcat(code, encode_belt_code(ones(1,count)*x_1,ifMobius,false,true,false));
            else
                code = ...
                    strcat(code, encode_belt_code(ones(1,count)*x_1,ifMobius,false,false,false));
            end
            count = 1;
        end
        if j <= length(pathcode)
            x_1 = pathcode(j);
        end
    end
    return
end


% All other cases:
code = [];
for j = 1 : length(pathcode)
    code = [ code, encode_a_number( pathcode(j) ) ];
end


end