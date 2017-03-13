# Consider all integer combinations of ab for 2 ≤ a ≤ 5 and 2 ≤ b ≤ 5:
#
#     2²=4, 2³=8, 2⁴=16, 2⁵=32
#     3²=9, 3³=27, 3⁴=81, 3⁵=243
#     4²=16, 4³=64, 4⁴=256, 4⁵=1024
#     5²=25, 5³=125, 5⁴=625, 5⁵=3125
#
# If they are then placed in numerical order, with any repeats removed,
# we get the following sequence of 15 distinct terms:
#
# 4, 8, 9, 16, 25, 27, 32, 64, 81, 125, 243, 256, 625, 1024, 3125
#
# How many distinct terms are in the sequence generated by ab
# for 2 ≤ a ≤ 100 and 2 ≤ b ≤ 100?

subset Nat of Int where * > 0 ;

# Matrix lookup
# NOTE: this overrides array slices !!
multi postcircumfix:<[ ]>(Positional $ary, List $coord) {
#   say 'src, crsr: ', ( $ary.perl, $coord.perl );
    zip $ary, $coord.flat, :with( {
    #   say 'ary, index: ', ( $^a.perl, $^i.WHICH );
        $^a[$^i]
    } );
}

sub combine_sort(&f, **@sources where { $_.all ~~ List }) {
    return if 0 == any(@sources».elems);
    push my @boundaries, 0 xx @sources.elems;
    while (@boundaries) {
        say 'Boundaries: ', @boundaries;
        my @cursor = |@boundaries.min: {
            f( |@sources[ $_ ] )
        };
        say 'Sources: ', @sources;
        say 'Cursor: ', @cursor, ' => ', f( |@sources[@cursor] );
        take @sources[ @cursor ];
        last;
    }
}

my @test = [
    [ 1, 1, 1, 1, 2, 6 ],
    [ 1, 4, 6, 6, 6, 9 ],
    [ 4, 5, 6, 7, 8, 9 ],
    [ 6, 6, 6, 7, 9, 11 ],
    [ 9, 10, 11, 11, 11, 11 ],
];

sub MAIN(Nat :$limit where * > 1 = 100) {
    say gather combine_sort { say "f: ", ($^x, $^y); @test[ $^x][ $^y ] }, [^5], [^6] ;
}
