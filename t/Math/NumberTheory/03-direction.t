use v6;

use FindBin 't';
use lib $LIB;

use Test;

use Math::NumberTheory;

ok Origin ~~ Coordinate,        'Origin is a Coordinate';
is-deeply NW + Origin, NW.value,'Origin is identity for Coordinate add';

ok N ~~ Coordinate,             'enum Dir symbols are also type Coordinate';
is-deeply N + E, NE.value,      '45 degree compass point NE OK';
is-deeply N + W, NW.value,      '45 degree compass point NW OK';
is-deeply S + E, SE.value,      '45 degree compass point SE OK';
is-deeply S + W, SW.value,      '45 degree compass point SW OK';

done-testing;
