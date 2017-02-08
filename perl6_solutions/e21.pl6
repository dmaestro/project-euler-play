# Let d(n) be defined as the sum of proper divisors of n (numbers less than n
# which divide evenly into n).
# If d(a) = b and d(b) = a, where a ≠ b, then a and b are an amicable pair and
# each of a and b are called amicable numbers.
#
# For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44,
# 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4,
# 71 and 142; so d(284) = 220.
#
# Evaluate the sum of all the amicable numbers under 10000.
#

subset Nat of Int where * > 0;

sub first_factor (Nat $n) {
    state Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    $primes.cache.first( $n %% * || * > sqrt($n) ).grep( $n %% * )[0]  // $n;
}

sub divisors(Nat $n) {
    state $factors = :{1 => 1.Set};  # Int => Set
    $factors{$n} //= Set.new(
        first_factor($n).&( { (1, $^f) X* divisors( $n div $^f ).keys } ).Slip
    );
    $factors{$n};
}

sub d(Nat $n) {
    [+] (divisors($n) (-) $n.Set).keys;
}

sub MAIN(Nat :$limit = 10_000) {
    say [+] (2..^$limit).grep({ .&d.&d == $_ }).grep({ .&d != $_ });
}
