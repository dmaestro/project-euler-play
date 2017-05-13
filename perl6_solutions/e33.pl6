# The fraction 49/98 is a curious fraction, as an inexperienced mathematician
# in attempting to simplify it may incorrectly believe that 49/98 = 4/8, which
# is correct, is obtained by cancelling the 9s.

# We shall consider fractions like, 30/50 = 3/5, to be trivial examples.

# There are exactly four non-trivial examples of this type of fraction, less
# than one in value, and containing two digits in the numerator and denominator.

# If the product of these four fractions is given in its lowest common terms,
# find the value of the denominator.

# Using this was a mis-interpretation of the problem:
sub cast-out-nines(Int $number where * >= 0) {
    my $s = $number.Str;
    while ($s.chars > 1) {
        $s = ([+] $s.comb).Str;
    }
    return 0 if $s eq '9';
    return $s.Int;
}

sub cancel-like-digits(Int $num, Int $den) {
    return 0 unless any($num.comb) eq any($den.comb);
    return flat
        $num.comb.grep( * ne any ($den.comb) ),
        $den.comb.grep( * ne any ($num.comb) );
}

# role to make a rational type
# printable as "num/denom"
role Fraction {
    method gist(Rat:D $rat:) {
        $rat.nude.join('/');
    }
}

sub MAIN(:$digits = 2) {
    my $min = 10 ** ($digits-1);
    my $max = 10 ** $digits -1;
    say ( [*] gather {
        for ($min+1)..$max -> $denom {
            for $min..($denom-1) -> $num {
                if $num.substr(1) eq $denom.substr(1) eq '0' {
                    say "Trivial!";
                    next;
                }
                my $frac = ($num / $denom) but Fraction;
                my $cancel-frac = (
                    [/] cancel-like-digits($num, $denom)
                        or 0    # handle failure
                ) but Fraction;
                next
                    if (not $cancel-frac);
                if $frac eqv $cancel-frac {
                    say "Cancelled!";
                    say "$num:\t", $cancel-frac.numerator;
                    say "$denom:\t", $cancel-frac.denominator;
                    say $frac;
                }
                take $frac if $frac eqv $cancel-frac;
            }
        }
    } ) but Fraction;
}
