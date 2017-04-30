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
    eager zip $ary, $coord.flat, :with( {
        $^a[$^i]
    } );
}

sub infix:<outside>(List $coord, List $boundary) {
    fail if $coord.elems != $boundary.elems;
    so any( $coord.flat Z< $boundary.flat );
}

sub unit_vectors(+@coordinate) {
    gather {
        for @coordinate.keys -> $i {
            take eager map { +($_ == $i) }, @coordinate.keys;
        }
    }
}

sub new_boundary(&v, @cursor is copy) {
    my $current_value = v(@cursor);
    my @uv = unit_vectors(@cursor);
    my $ce = @cursor.elems;
    my @boundaries = gather {
      while $current_value eqv v(@cursor) {
        for @uv -> $vector {
            my @new_cursor = @cursor;
            repeat while my $new_value eqv $current_value {
                @new_cursor = @new_cursor Z+ $vector.flat;
                $new_value = v( @new_cursor);
            }
            take @new_cursor if $new_value.defined;
        }
        @cursor = @cursor.flat Z+ (1 xx $ce);
      }
      take @cursor if v( @cursor ).defined;
    }
    return eager @boundaries.grep: -> $test {
        $test outside all( @boundaries.grep: * !eqv $test )
    }
}

sub combine_sort(&f, **@sources where { $_.all ~~ List }) {
    return if 0 == any(@sources».elems);
    my &v = sub (@where) {
        return if Any ~~ any(@sources[@where]);
        f( @sources[@where] );
    };
    push my @boundaries, 0 xx @sources.elems;
    squish :as({ &f($_) }), gather {
        while (@boundaries) {
        #   say "\n", 'Boundaries: ', @boundaries;
            my @cursor = |@boundaries.min: &v;
            @boundaries = @boundaries.grep: { $_.List !eqv @cursor.List };
        #   say "Taking: ", @cursor.&{ $_ => &v($_) };
            take @sources[ @cursor ];
            my @new = new_boundary(&v, @cursor).grep: * outside all(@boundaries);
            push @boundaries, |@new;
        #   last if ++$ > 6;
        }
        say "Exiting gather";
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
#   say combine_sort -> [$x, $y] { @test[$x][$y] }, [^5], [^6] ;
    say combine_sort( { $_[0] ** $_[1] }, [2..$limit], [2..$limit] ).elems;
}
