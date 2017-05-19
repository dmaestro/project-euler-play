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
    (2..^$denominator).grep( { .&is-resilient } ).elems / ($denominator - 1);
}

sub cast-out(Nat $denominator, *@factors) {
    my $flimsy = $denominator - 1;
    my $rem = $denominator;
    for @factors -> $divisor {
        $rem div= $divisor while $rem %% $divisor;
        $rem.say;
    }
    return if $rem == 1;
    return $denominator div first_factor($rem) - 1;
}

sub MAIN(Nat $numerator = 15499, Str $slash = '/', Nat $denominator = 94744) {
    fail "Invalid arguments!" unless $numerator / $denominator < 1;
    my $smallest = ( 2 ... { .&resilience < ($numerator / $denominator) } ).tail;
    say "R($smallest) < ", ( $numerator / $denominator ) but Fraction;
    say "R($_): ",.&resilience but Fraction for $smallest, 30, 210, 2310; #, 94744;
#   say first_factor(210);
    ( 210, { .say; $_ div first_factor($_) } ... 1 ).eager;
    say cast-out( 210 );
    say cast-out( 210, first_factor(210) );
    say cast-out( 210, |(210, 105)».&first_factor );
    say cast-out( 210, |(210, 105, 35)».&first_factor );
}
