# In the 5 by 5 matrix below, the minimal path sum from the top left to the
# bottom right, by only moving to the right and down, is indicated in bold
# red and is equal to 2427.
#
# (131* 673  234  103   18 )
# (201*  96* 342* 965  150 )
# (630  803  746* 422* 111 )
# (537  699  497  121* 956 )
# (805  732  524   37* 331*)
#
# Find the minimal path sum, in matrix.txt, a 31K text file containing a
# 80 by 80 matrix, from the top left to the bottom right by only moving right
# and down.
#

class Coordinate is List {
}

enum Compass-Points (
    N   =>  Coordinate.new(-1,0),
    NE  =>  Coordinate.new(-1,1),
    E   =>  Coordinate.new(0, 1),
    SE  =>  Coordinate.new(1 ,1),
    S   =>  Coordinate.new(1 ,0),
    SW  =>  Coordinate.new(1 ,-1),
    W   =>  Coordinate.new(0 ,-1),
    NW  =>  Coordinate.new(-1,-1),
);

my \Origin := Coordinate.new(0,0);

multi sub postcircumfix:<[ ]>(Positional $ary, Coordinate *$i) {
    reduce { $^a[$^b] // Nil }, $ary, |$i;
}

multi sub infix:<+>( Coordinate \a, Coordinate \b ) {
    Coordinate.new(|(a.flat Z+ b.flat));
}

sub read-matrix(IO() $input) {
    eager gather {
        for $input.lines {
            take $/».Int.list if m:g/ (\d+) /;
        }
    }
}

sub path-sum-of(Positional $matrix, Coordinate $c) {
    state %sums;
    return ().Slip if not $matrix[$c].defined;
#   say "Computing $c: ", $matrix[$c];
#   say my $r = 
    %sums{$c} //=
    [+] $matrix[$c], [min] (
        path-sum-of($matrix, $c + W),
        path-sum-of($matrix, $c + N),
        Inf,
        0,
    )[0,1];
#   $r;
}

sub MAIN(:$input-file = 'p081_matrix.txt', :$limit=Inf) {
#   say read-matrix($input-file).perl;
    my $matrix = read-matrix($input-file);
    say path-sum-of $matrix, Coordinate($matrix.end min $limit, $matrix[0].end min $limit);
}
