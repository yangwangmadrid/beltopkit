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

function code = encode_a_number( n )

if n == 0
    error( 'n must be nonzero\n' )
elseif n > 160
    error( 'n must be no greater than 160\n' )
elseif n < 0
    code = strcat( '0', encode_a_number( -n ) );
    return
end

if n <= 9
    code = num2str(n);
    return
elseif n <= 32
    code = char( n-10+65 );
    return
end

if n >= 33 && n <= 64
    code = strcat( 'Z', encode_a_number( n-32 ) );
    return
end

if n >= 65 && n <= 96
    code = strcat( 'ZX', encode_a_number( n-64 ) );
    return
end

if n >= 97 && n <= 128
    code = strcat( 'ZY', encode_a_number( n-96 ) );
    return
end

if n >= 129 && n <= 160
    code = strcat( 'ZZ', encode_a_number( n-96 ) );
    return
end

end