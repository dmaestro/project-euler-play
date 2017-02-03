# If the numbers 1 to 5 are written out in words: one, two, three, four, five,
# then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
#
# If all the numbers from 1 to 1000 (one thousand) inclusive were written out
# in words, how many letters would be used?
#
# NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and
# forty-two) contains 23 letters and 115 (one hundred and fifteen) contains
# 20 letters. The use of "and" when writing out numbers is in compliance with
# British usage.
#

sub MAIN(Bool :$test) {
    if $test {
        speak($_ * $_).say for 0 .. 99;
        say [+] (1 .. 5)».&{ .&speak.comb(/<alpha>/).elems };
        say (342, 115)».&{ .&speak.comb(/<alpha>/).elems };
    }
    else {
        say [+] (1 .. 1000)».&{ .&speak.comb(/<alpha>/).elems };
    }
}

my \SPACE := ' ';
my \EMPTY-STRING := '';

my @ones = <
    zero
    one
    two
    three
    four
    five
    six
    seven
    eight
    nine
>;

my @teens = <
    ten
    eleven
    twelve
    thir-
    four-
    fif-
    six-
    seven-
    eigh-
    nine-
>;

my @tens = <
    -
    -teen
    twenty
    thirty
    forty
    fifty
    sixty
    seventy
    eighty
    ninety
>;

my @hundreds = (q<->, |(@ones[1..9] X "hundred"));
my @thousands = (q<->, |(@ones[1..9] X "thousand"));

multi sub speak (Int $n where * < 10000) {
    my ($ones, $tens, $hundreds, $thousands) = |$n.comb.reverse.map(* + 0), 0, 0, 0;

    my $has_hundreds     = so $hundreds > 0 || $thousands > 0;
    my $has_sub_hundreds = so $ones > 0 || $tens > 0;
    my @sub_hundreds;
    if $tens {
            @sub_hundreds.push: @tens[$tens];
    }
    if @sub_hundreds.elems && @sub_hundreds[0] ~~ / <[-]> / {
        if @teens[$ones] ~~ / <[-]> / {
            @sub_hundreds.unshift: @teens[$ones];
        }
        else {
            @sub_hundreds.shift;
            @sub_hundreds.push: @teens[$ones];
        }
    }
    elsif not ($tens && ! $ones) {
        @sub_hundreds.push: @ones[$ones];
    }
    my $sub_hundreds = @sub_hundreds.join('-').subst: '---', EMPTY-STRING;

    if $has_hundreds and $has_sub_hundreds {
        (
            |(@thousands[$thousands], @hundreds[$hundreds]).flat.grep( * ne '-' ),
            'and',
            $sub_hundreds
        ).join(SPACE);
    }
    elsif ! $has_hundreds {
        $sub_hundreds;
    }
    else {
        (@thousands[$thousands], @hundreds[$hundreds]).flat.grep( * ne '-' ).join(SPACE);
    }
}
