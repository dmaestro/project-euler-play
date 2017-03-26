use v6.c;

use FindBin 't';
use lib $LIB;

use Test;

use Math::NumberTheory;

ok ::("Nat")        !~~ Failure, 'Type  Nat is imported';
ok ::("Coordinate") !~~ Failure, 'Class Coordinate is imported';
ok ::("Dir")        !~~ Failure, 'enum  Dir is imported';

done-testing;
