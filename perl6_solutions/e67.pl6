# By starting at the top of the triangle below and moving to adjacent numbers
# on the row below, the maximum total from top to bottom is 23.
my @triangle_small = q:to<END_SMALL>.lines».comb(/\d+/);
  3
  7 4
  2 4 6
  8 5 9 3
END_SMALL
# That is, 3 + 7 + 4 + 9 = 23.
#
# Find the maximum total from top to bottom in triangle.txt (right click and
# 'Save Link/Target As...'), a 15K text file containing a triangle with
# one-hundred rows.
#
# NOTE: This is a much more difficult version of Problem 18. It is not possible
# to try every route to solve this problem, as there are 299 altogether! If you
# could check one trillion (1012) routes every second it would take over twenty
# billion years to check them all. There is an efficient algorithm to solve it. ;o)
my $base_path = $*PROGRAM.resolve.parent.parent;
my @triangle = $base_path.child(<p067_triangle.txt>).lines».comb(/\d+/);
say @triangle.elems;

sub MAIN(Int :$depth = 0, Bool :$test = False) {
    my @paths;
    if $test {
        @triangle = @triangle_small;
    }
    my $d = $depth <= 0
        ?? @triangle.elems
        !! $depth;

    for @triangle[^$d] -> $row {
        my @left = 0, |@paths;
        my @right = |@paths, 0;
        @paths = ($row.flat Z+ @left) Zmax ($row.flat Z+ @right);
    #   say @paths;
    }
    @paths.max.say;
}
