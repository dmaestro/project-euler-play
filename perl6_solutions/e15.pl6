# Starting in the top left corner of a 2×2 grid, and only being able to move
# to the right and down, there are exactly 6 routes to the bottom right corner.

# How many such routes are there through a 20×20 grid?

subset Nat of Int where * > 0;

sub MAIN(Nat :$dim = 20) {
    # efficiently compute (2n)! / n!n!
    say [*] ($dim...1)».&( -> $denominator { ($denominator + $dim) / $denominator } );
    # Perl uses Rats for exact precision
#   say .WHICH for ($dim...1)».&( -> $denominator { ($denominator + $dim) / $denominator } );
}
