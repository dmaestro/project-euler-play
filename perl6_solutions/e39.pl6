# If p is the perimeter of a right angle triangle with integral length sides,
# {a,b,c}, there are exactly three solutions for p = 120.
#
# {20,48,52}, {24,45,51}, {30,40,50}
#
# For which value of p ≤ 1000, is the number of solutions maximised?
use experimental :cached;

subset Nat of Int where * > 0;

sub integer_triangles(Nat $hypotenuse) is cached {
    ( 3..floor($hypotenuse * sqrt(0.5)) )».&(
        -> $a { $a, sqrt($hypotenuse² - $a²), $hypotenuse }
    ).grep({ .all %% 1 }).cache
}

sub MAIN(Nat :$max_perimeter = 1000) {
#   .say for
    (12..$max_perimeter)».&( -> $perimeter {
        $perimeter =>
        (5..( $perimeter div 2 )).map({
            .&integer_triangles.Slip
        }).grep({ $perimeter == [+] $_ }).elems
    })\
    .max( *.value ).say
}
