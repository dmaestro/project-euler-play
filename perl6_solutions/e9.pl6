# A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
# a² + b² = c²
#
# For example, 3² + 4² = 9 + 16 = 25 = 5².
#
# There exists exactly one Pythagorean triplet for which a + b + c = 1000.
# Find the product abc.
#



# flat((1..31) xx 2).sort.combinations(2).unique(:with(&[eqv]))

sub MAIN(Int :$sum = 1000) {
    my @squares = (1 ...^ * ** 2 >= $sum)».&(* ** 2);
}

subset OrderedSet of List where { .unique eqv $_ };
subset Nat of Int where * > 0;

sub combinations_with_replacement( OrderedSet $items, Nat $picks --> List ) {
    return $items.List if $picks == 1;
    my @permutations = ($items.List X combinations_with_replacement( $items, $picks - 1 )).map: { .flat.cache };
    return @permutations.List;
}

say combinations_with_replacement(<a b c>, 2);
say combinations_with_replacement(<a b c>, 2).elems;
say combinations_with_replacement(<a b c>, 3);
say combinations_with_replacement(<a b c>, 3).elems;
