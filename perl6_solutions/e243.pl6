# A positive fraction whose numerator is less than its denominator is called
# a proper fraction.
# For any denominator, d, there will be d−1 proper fractions; for example,
# with d = 12:
#   1/12 , 2/12 , 3/12 , 4/12 , 5/12 , 6/12 , 7/12 , 8/12 , 9/12 , 10/12 , 11/12
#
# We shall call a fraction that cannot be cancelled down a resilient fraction.
# Furthermore we shall define the resilience of a denominator, R(d), to be the
# ratio of its proper fractions that are resilient; for example, R(12) = 4/11 .
#
# In fact, d = 12 is the smallest denominator having a resilience R(d) < 4/10 .
#
# Find the smallest denominator d, having a resilience R(d) < 15499/94744 .

subset Nat of Int where * > 0;

sub first_factor (Nat $n) {
    fail if $n == 1;
    state Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    $primes.cache.first( $n %% * || * > sqrt($n) ).grep( $n %% * )[0]  // $n;
}

sub prime_factors(Nat $n --> Seq) {
    gather {
        my $rem = $n;
        while $rem > 1 {
            my $factor = first_factor($rem);
            take $factor;
            while $rem %% $factor {
                $rem div= $factor;
            }
        }
    }
}

# role to make a rational type
# printable as "num/denom"
role Fraction {
    method gist(Rat:D $rat:) {
        $rat.nude.join('/');
    }
}

sub resilient(Nat $denominator, Nat $numerator where $numerator < $denominator) {
    $numerator gcd $denominator == 1;
}

sub resilience(Nat $denominator) {
    return 1/1 if $denominator.is-prime;
    state %roots;
    my @factors = prime_factors( $denominator );
#   @factors.say;
    my $base = [*] @factors;
    my $root = %roots{ $base } //=
        (1..^$base).grep( * gcd $base == 1 ).elems / ($base - 1);
    if $base == $denominator {
        return $root;
    }
    my $factor = $denominator div $base;
    return ($root.numerator * $factor) / (($root.denominator + 1) * $factor - 1);
}

sub max_flimsiness(Nat $denominator) {
    my $flimsy = $denominator - 1;
    return $flimsy / $flimsy if $denominator.is-prime;
    my @factors = prime_factors($denominator);
    my @cast_outs = gather {
        for @factors -> $factor {
            take [-]
                $flimsy div $factor,
                $factor == @factors[0]
                ?? 0
                !! $flimsy div ( $factor * @factors[0] )
                ;
        }
    };
#   say "Cast outs: ", @cast_outs, " / ", $flimsy;
#   say [+] @cast_outs;
    return ([+] @cast_outs) / $flimsy;
}

sub MAIN(Nat $numerator = 15499, Str $slash = '/', Nat $denominator = 94744) {
    fail "Invalid arguments!" unless $numerator / $denominator < 1;
    my $smallest = ( 2 ... * ).grep({ .&max_flimsiness + $numerator / $denominator > 1 }) .first({
    #   say .&max_flimsiness but Fraction;
        .&resilience < ($numerator / $denominator)
    });

    say "R($smallest) < ", ( $numerator / $denominator ) but Fraction;
    say "R($_): ",.&resilience but Fraction for 30, 105, |(210 X* (1, 2, 3, 4, 5)), 2310, $smallest;
}
