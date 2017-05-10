# We shall say that an n-digit number is pandigital if it makes use of all
# the digits 1 to n exactly once; for example, the 5-digit number, 15234,
# is 1 through 5 pandigital.
#
# The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing
# multiplicand, multiplier, and product is 1 through 9 pandigital.
#
# Find the sum of all products whose multiplicand/multiplier/product identity
# can be written as a 1 through 9 pandigital.
#
# HINT: Some products can be obtained in more than one way so be sure to only
# include it once in your sum.


subset Nat of Int where * > 0;

sub first_factor (Nat $n) {
    state Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    $primes.cache.first( $n %% * || * > sqrt($n) ).grep( $n %% * )[0]  // $n;
}

sub divisors(Nat $n) {
    state $factors = :{1 => Set.new(1)};  # Int => Set
    $factors{$n} //= Set.new(
        first_factor($n).&( { (1, $^f) X* divisors( $n div $^f ).keys } ).Slip
    );
    $factors{$n};
}

sub is-pandigital(Nat $pan, Nat $num) {
    state %pan;
    so $num.comb.cache.&{
        .all ~~ (%pan{$pan} //= 1..$pan) && .unique.elems == $pan
    };
}

sub all_products(Nat $prod) {
    say $prod.&divisors.keys.grep( 1 < * < 100 );
}

sub MAIN(Nat :$pan=9) {
    .&{ say is-pandigital($pan, $_) } for <12 123 1234 12345 123456>;
    say all_products(7254).perl;
}
