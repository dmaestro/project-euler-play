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

# role to make a rational type
# printable as "num/denom"
role Fraction {
    method gist(Rat:D $rat:) {
        $rat.nude.join('/');
    }
}

sub resilient(Nat $denominator, Nat $numerator where $numerator < $denominator) {
    ($numerator / $denominator).denominator == $denominator;
}

sub resilience(Nat $denominator) {
    my &is-resilient = &resilient.assuming( $denominator );
    (1..^$denominator).grep( { .&is-resilient } ).elems / ($denominator - 1);
}

sub MAIN(Nat $numerator, Str $slash where $slash eq '/', Nat $denominator) {
    fail "Invalid arguments!" unless $numerator / $denominator < 1;
    my $smallest = ( 2 ... { .&resilience < ($numerator / $denominator) } ).tail;
    say "R($smallest) < ", ( $numerator / $denominator ) but Fraction;
}
