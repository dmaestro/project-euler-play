use v6;

use Test;

use FindBin 't';
use lib $LIB;

use Math::NumberTheory;

subtest 'Method' => {
    for 1..4 -> $dimensions {
        my $coord = Coordinate(|^$dimensions);
        my @unit-vectors = $coord.unit-vectors;
        ok all(@unit-vectors).elems == $dimensions,
            "Unit vector of dimension $dimensions";
        ok all(@unit-vectors) ~~ Coordinate,
            'Unit vectors of Coordinate are type Coordinate';
        ok all( map -> $v { [+] map { $_ * $_ }, $v.flat }, @unit-vectors ) == 1,
            'All meet definition of unit vector';
    }
}

subtest 'Routine' => {
    for 1..4 -> $dimensions {
        my @coord = (^$dimensions).list;
        my @unit-vectors = unit-vectors(@coord);
        ok all(@unit-vectors).elems == $dimensions,
            "Unit vector of dimension $dimensions";
        ok all(@unit-vectors) ~~ List,
            'Unit vectors of list are type List';
        ok all( map -> $v { [+] map { $_ * $_ }, $v.flat }, @unit-vectors ) == 1,
            'All meet definition of unit vector';
    }
}

done-testing;
