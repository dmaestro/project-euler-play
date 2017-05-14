# 145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
#
# Find the sum of all numbers which are equal to the sum of the factorial
# of their digits.
#
# Note: as 1! = 1 and 2! = 2 are not sums they are not included.

subset Nat of Int where * > 0;

# simple factorial
multi sub prefix:<f!>(0) { 1 }
multi sub prefix:<f!>(Nat $n) { [*] 1..$n }

my @digit-factorial = ^10 .map: { f! $_ };

sub W(Num() $z, :$w0 = 0) {
    # Newton-Raphson method computing the Lambert W function
    # Thomas Schurger, M.C.S - https://www.quora.com/How-is-the-Lambert-W-Function-computed
    ($z.log.isNaN
        ?? $w0
            ?? $z
            !! log(-$z)
        !! $z.log,
        { $^a - ($^a*(e**$^a) - $z)/( ($^a+1)*(e**$^a) ) } ... { $^a =~= $^b }
    )[*-1]
}

sub max_sum() {
    # Using the Lambert W function to solve: 10ⁿ = n(9!)
    # http://en.wikipedia.org/wiki/Lambert_W_function#Generalizations
    my $logsum = ( -1/log(10) * W( -log(10) / f!(9) ) );
    return ceiling(10 ** $logsum);
}

sub is-curious(Cool $n) {
#   @digit-factorial[ $n.substr(0,1) ] <= $n
#   &&
        $n == [+] $n.comb.map: { @digit-factorial[$_] }
}

sub MAIN() {
    say @digit-factorial;
    say max_sum;
    say [+] (10..max_sum).grep({
        .&is-curious && .say
    });
}
