use v6;

use FindBin 't';
use lib $LIB;

use Test;

use Math::NumberTheory;

ok Nat ~~ Int,      'Subtype of Int';
ok ! (0 ~~ Nat),    'Zero is not a Nat';
ok 1 ~~ Nat,        'One is a Nat';
ok ! (-1 ~~ Nat),   'Negative Int is not Nat';

done-testing;
