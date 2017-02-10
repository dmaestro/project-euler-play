# Using names.txt (right click and 'Save Link/Target As...'), a 46K text file
# containing over five-thousand first names, begin by sorting it into alpha-
# betical order. Then working out the alphabetical value for each name, multiply
# this value by its alphabetical position in the list to obtain a name score.
#
# For example, when the list is sorted into alphabetical order, COLIN, which is
# worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN
# would obtain a score of 938 × 53 = 49714.
#
# What is the total of all the name scores in the file?
my @letters = ('A'..'Z');
my %letter_value := :{ Nil => 0, @letters.clone.unshift(Nil).antipairs.flat };
%letter_value{'Z'}.say;

my $base_path = $*PROGRAM.resolve.parent.parent;
sub MAIN(*@file) {
    if ( ! @file ) {
        push @file, $base_path.child(<p022_names.txt>);
    }
    for @file -> $filename {
        $filename.IO.open(:nl-in(",")).lines.map( {
            S:g/\"//;
        } ).elems;
    }
}
