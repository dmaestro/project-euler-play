# Starting with the number 1 and moving to the right in a clockwise direction a 5 by 5 spiral is formed as follows:
#
# 21 22 23 24 25
# 20  7  8  9 10
# 19  6  1  2 11
# 18  5  4  3 12
# 17 16 15 14 13
#
# It can be verified that the sum of the numbers on the diagonals is 101.
#
# What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral formed in the same way?

subset Nat of Int where * > 0;

multi sub diagonal_sum(1) { 1 => 1 }
multi sub diagonal_sum(Nat $n) {
    my Pair $ms = diagonal_sum($n - 2); # max => sum
    my @corners = $ms.key X+ (1..4).map: * * ($n - 1);
    @corners[ * - 1 ] =>
        [+] $ms.value, |@corners;
}

sub MAIN(Nat :$size where (* + 1) %% 2 = 1001) {
    say $size;
    say diagonal_sum($size);
}
