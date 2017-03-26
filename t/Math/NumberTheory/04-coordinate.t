use v6.c;

use FindBin 't';
use lib $LIB;

use Test;

use Math::NumberTheory;

my $matrix  = [ <a b c>,
                <c d e>,
                <f g h>,
              ];
my $last    = Coordinate(2,2);

# Indexing
is $matrix[Origin], 'a', 'Lookup origin of matrix';
is $matrix[SE],     'd', 'Lookup middle of matrix';
is $matrix[S + SE], 'g', 'Add coordinates and lookup';
is $matrix[ $last ],'h', 'Lookup most SE element';

# Negative bounds
ok ! $matrix[ W ].defined, 'Index out of bounds [W] returns Any';
ok ! $matrix[ N ].defined, 'Index out of bounds [N] returns Any';

# Coordinate construction
is Coordinate(|^$_).elems, $_, "Construct $_ dimensional coordinate"
    for 1 .. 4;

done-testing;
