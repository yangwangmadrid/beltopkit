%==========================================================================
% Source codes:  beltopkit -- A topology-based toolkit for generalized nanobelts
% Author:        Yang Wang (yangwang@yzu.edu.cn)
% ORCID:         https://orcid.org/0000-0003-2540-2199
% Last Modified: March 18, 2026
% License:       For academic and non-commercial use only.
%                Copyright (c) 2026 Yang Wang. All rights reserved.
%==========================================================================

%
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

function n = decode_a_number( code )

code = upper( code ); % Ensure all capital letters

% Negative number:
if code(1) == '0'
    n = -decode_a_number( code(2:end) );
    return
end

nadd = 0;
if code(1) == 'Z'
    if length(code) < 2
        error( 'Invalid input code' )
    end
    if code(2) == 'X'
        if length(code) > 3
            error( 'Invalid input code' )
        end
        nadd = 64;
    elseif code(2) == 'Y'
        if length(code) > 3
            error( 'Invalid input code' )
        end
        nadd = 96;
    elseif code(2) == 'Z'
        if length(code) > 3
            error( 'Invalid input code' )
        end
        nadd = 128;
    elseif (code(2) >= '1' && code(2) <= '9') || ...
            (code(2) >= 'A' && code(2) <= 'W')
        if length(code) > 2
            error( 'Invalid input code' )
        end
        nadd = 32;
    else
        error( 'Invalid input code' )
    end
else
    if length(code) > 1
        error( 'Invalid input code' )
    end
end


if code(end) >= '1' && code(end) <= '9'
    n = str2num(code(end));
elseif code(end) >= 'A' && code(end) <= 'W'
    n = code(end) - 'A' + 10;
else
    error( 'Invalid input code' )
end


n = n + nadd;

end