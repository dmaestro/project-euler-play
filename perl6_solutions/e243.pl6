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
#   ($numerator / $denominator).denominator == $denominator;
    $numerator gcd $denominator == 1;
}

sub resilience(Nat $denominator) {
#   return 1/1 if $denominator.is-prime;
    my &is-resilient = &resilient.assuming( $denominator );
    (1..^$denominator).grep( { .&is-resilient } ).elems / ($denominator - 1);
}

sub min_flimsiness(Nat $denominator, Nat $rank = 2) {
    my $flimsy = $denominator - 1;
    return $flimsy / $flimsy if $denominator.is-prime;
    my @factors = prime_factors($denominator).head($rank);
    my @cast_outs = gather {
        for @factors -> $factor {
            take [-]
                ( $factor X (
                        (),
                        |@factors.grep(* < $factor)
                    )
                ).map({ [*] .flat.eager }
                )».&{$flimsy div $_}.Slip,
                0;
        }
    };
    say "Cast outs: ", @cast_outs;
    return ([+] @cast_outs) / $flimsy;
}

sub MAIN(Nat $numerator = 15499, Str $slash = '/', Nat $denominator = 94744) {
    fail "Invalid arguments!" unless $numerator / $denominator < 1;
    my $smallest = ( 2 ... { .&resilience < ($numerator / $denominator) } ).tail;
    say "R($smallest) < ", ( $numerator / $denominator ) but Fraction;
    say "R($_): ",.&resilience but Fraction for $smallest, 30, 105, 210, 2310; #, 94744;
    say "F($_): ",.&min_flimsiness(4) but Fraction for $smallest, 30, 105, 210, 2310; #, 94744;
}
