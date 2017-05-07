# Surprisingly there are only three numbers that can be written as the
# sum of fourth powers of their digits:
#
#     1634 = 1⁴ + 6⁴ + 3⁴ + 4⁴
#     8208 = 8⁴ + 2⁴ + 0⁴ + 8⁴
#     9474 = 9⁴ + 4⁴ + 7⁴ + 4⁴
#
# As 1 = 14 is not a sum it is not included.
#
# The sum of these numbers is 1634 + 8208 + 9474 = 19316.
#
# Find the sum of all the numbers that can be written as the sum of
# fifth powers of their digits.
#

sub W(Num() $z, :$w0 = 0) {
    # Newton-Raphson method computing the Lambert W function
    # Thomas Schurger, M.C.S - https://www.quora.com/How-is-the-Lambert-W-Function-computed
    ($z.log.isNaN
        ?? $w0
            ?? $z
            !! log(-$z)
        !! $z.log,
        { $^a - ($^a*(e**$^a) - $z)/( ($^a+1)*(e**$^a) ) } ... *
    )[5]
}

sub max_digits(Int $power) {
    # Using the Lambert W function to solve: 10ⁿ = n(9**$power)
    # http://en.wikipedia.org/wiki/Lambert_W_function#Generalizations
    return ceiling( -1/log(10) * W( -log(10) / 9**$power ) );
}

sub MAIN(:$power = 5) {
    my @power_digit = ^10 .map( * ** $power );
#   say @power_digit.kv.perl;
    my $d = max_digits($power);
    say "Max digits: $d";
    say [+] (10..(10**$d)).grep: { $_ == [+] $_.comb.map: { @power_digit[$_] } };
}
