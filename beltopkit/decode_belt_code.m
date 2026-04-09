%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

% Decode a given encoded string into the path code for a nanobelt
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
% NOTE: (As corollaries)
%      (1) 'X' can be used repeatedly whenever applicable, while 'Y' can be
%       usded only ONCE for the ENTIRE path code. 
%      (2) 'X' can never be followed by '0' or 'Y'.
%


function pathcode = decode_belt_code( code )

% Rule 3 (Inverse of whole code):
if code(1) == 'Y'
    if length(code) < 2
        error( 'Invalid input code' )
    end
    pathcode = -decode_belt_code( code(2:end) );
    return
end

% Rule 4 (Repeating whole code):
if code(1) == 'X'
    if length(code) < 2
        error( 'Invalid input code' )
    end
    if code(2) == 'X'
        if length(code) < 3
            error( 'Invalid input code' )
        end
        [ NrepAll, code_rem ] = decode_a_number_from_belt_code( code(3:end) );
        % Rule 4 (Repeating whole code):
        pathcode_rep = decode_belt_code( code_rem );
        pathcode = [];
        for j = 1 : NrepAll
            pathcode = [ pathcode, pathcode_rep ];
        end
        return
    end
end

max_num_loop = length( code );
pathcode = [];
code_rem = code;
for j = 1 : max_num_loop
    [ n, code_rem ] = decode_a_number_from_belt_code( code_rem );
    pathcode = [ pathcode, n ];
    if isempty(code_rem)
        break
    end
end


end