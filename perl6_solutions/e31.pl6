#   In England the currency is made up of pound, £, and pence, p, and there
#   are eight coins in general circulation:
#
#       1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).
#
#   It is possible to make £2 in the following way:
#
#       1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p
#
#   How many different ways can £2 be made using any number of coins?

my @coins = [1, 2, 5, 10, 20, 50, 100, 200];

multi sub ways (0, *@) { 1 }
multi sub ways ($, 1) { 1 }
multi sub ways (Int $n, $max = $n) {
#   say "N: $n, MAX: $max";
    [+] @coins.grep( * <= $max ).map(-> $c {
        [+] (1..($n div $c)).map({ ways($n - $c*$_, $c-1) });
    });
}

sub MAIN (Int :$change = 200) {
    say ways($change);
}
