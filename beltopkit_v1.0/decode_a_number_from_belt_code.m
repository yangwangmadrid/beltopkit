%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

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
% 5. If some segments of path code contain a SINGLE repeating number (not a
%    patterning containing more than one number) and the num. of units >= 2, 
%    then apply rules 4 within each of the segments but using only a 
%    SINGLE leading 'X' instead of 'XX'.

function [ n, code_remain ] = decode_a_number_from_belt_code( code )

if isempty(code)
    error( 'Invalid input code' )
end

% Rule 5 (Repeating a single number):
if code(1) == 'X'
    if length(code) < 3
        error( 'Invalid input code' )
    end
    [ Nrep, code_remain ] = decode_a_number_from_belt_code( code(2:end) );
    [ n1, code_remain ] = decode_a_number_from_belt_code( code_remain );
    n = [];
    for j = 1 : Nrep
        n = [ n, n1 ];
    end
    return
end

ifNeg = false;
ifBig = false;
nadd = 0;
k = 0;
for j = 1 : length(code)
    % Rule 2 (Negative number):
    if j == 1 && code(j) == '0'
        ifNeg = true;
        continue
    end

    % Rule 1 (Big number):
    if ~ifBig && code(j) == 'Z'
        ifBig = true;
        nadd = 32;
        continue
    end

    % Continued -- Rule 1 (Big number):
    if ifBig
        ifBig = false;
        if code(j) == 'X'
            nadd = 64;
            continue
        elseif code(j) == 'Y'
            nadd = 96;
            continue
        elseif code(j) == 'Z'
            nadd = 128;
            continue
        end
    end

    % Rule 1 (Big number):
    n = decode_a_number( code(j) ) + nadd;
    
    % Rule 2 (Negative number):
    if ifNeg
        n = -n;
    end
    
    k = j+1;
    break
end

if k == 0
    error( 'Invalid input code' )
end

code_remain = code(k:end);

end