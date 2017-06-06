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

### the next two functions are not used directly
sub resilient(Nat $denominator, Nat $numerator where $numerator < $denominator) {
    $numerator gcd $denominator == 1;
}

sub r-prime(Nat $denominator) {
    (1..^$denominator).grep( * gcd $denominator == 1 ).elems / ($denominator - 1);
}
###

sub F(Nat $n) {
    return 1 if $n.is-prime;
    my @factors = prime_factors($n);
    if @factors.elems == 2 {
        return -1 + [+] $n X[div] @factors;
    }
    my $m = @factors.max;
    my $p = [*] @factors;
    return ($m-1) * F($n div $m) + $p div $m;
}

sub resilience(Nat $denominator) {
#   return 1/1 if $denominator.is-prime;
    state %roots;
    my @factors = prime_factors( $denominator );
    my $base = [*] @factors;
    my $root = %roots{ $base } //=
        ($base - F($base)) / ($base - 1);
    if $base == $denominator {
        return $root;
    }
    my $factor = $denominator div $base;
    return ($root.numerator * $factor) / (($root.denominator + 1) * $factor - 1);
}

sub MAIN(Nat $numerator = 15499, Str $slash = '/', Nat $denominator = 94744) {
    fail "Invalid arguments!" unless $numerator / $denominator < 1;

    my Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );

    # compute limit, the highest prime factor that needs to be considered
    my $product = 1;
    my $limit;
    $primes.cache.first({ $product *= $_; $limit = ++$; $product.&resilience < $numerator / $denominator });
    $limit.say;

    # resilience is lowest for combinations of unique prime factors
    $primes[^$limit].combinations().grep(*.elems > 1).map({ [*] $_ }).grep({
        # multiples of these combinations approach a slightly smaller limit
        .&resilience.&{ .numerator / (.denominator+1) } < $numerator / $denominator
    }).map(-> $r {
        (
            # include multiples that share common prime factors
            1, |(2 ...^ { $_ gcd $r == 1 }) X* $r
        ).Slip
    }).sort.first({ .&resilience < $numerator / $denominator })\
    ».say;
}
