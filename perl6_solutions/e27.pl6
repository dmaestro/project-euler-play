# Euler discovered the remarkable quadratic formula:
#
# n²+n+41
#
# It turns out that the formula will produce 40 primes for the consecutive integer values 0≤n≤39
# . However, when n=40,40²+40+41=40(40+1)+41 is divisible by 41, and certainly when n=41,41²+41+41
#
# is clearly divisible by 41.
#
# The incredible formula n²−79n+1601
# was discovered, which produces 80 primes for the consecutive values 0≤n≤79
#
# . The product of the coefficients, −79 and 1601, is −126479.
#
# Considering quadratics of the form:
#
#     n²+an+b
#
#     , where |a|<1000 and |b|≤1000
#
#     where |n|
#     is the modulus/absolute value of n
#     e.g. |11|=11 and |−4|=4
#
#     Find the product of the coefficients, a
#     and b, for the quadratic expression that produces the maximum number
#    of primes for consecutive values of n, starting with n=0.

subset Nat of Int where * > 0;

sub MAIN( :$limit = 1000 ) {
    my Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    my @generators = gather {
        # for n = 0, b must be prime
        for $primes...^( * > $limit ) -> $b {
            # for a = 0 and n = 1, b + 1 cannot be prime,
            # unless b = 2
            # so skip a = 0
            for (1...^$limit) X* (1, -1) -> $a {
                # for n = 1, 1 + a + b must be prime
                next unless (1 + $a + $b).is-prime;
                # if the discriminant of a quadratic equation is the
                # square of a positive integer, it has integer factors
                next if ($a² - 4*$b).&{ $^d >= 0 && $d %% sqrt($d)  };
                take (1, $a, $b) =>
                  (0 ...^ { ! ($^n² + $a * $^n + $b).is-prime }).tail;
            }
        }
    };
    say @generators.max(*.value);
    say @generators.max(*.value).key.&{ [*] .flat };
}
