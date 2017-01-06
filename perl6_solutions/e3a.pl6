my $n := 600851475143;
my $factors = flat(2, (3,5 ...^ * > sqrt($n) ), $n ).grep( { $n %% $_ && .is-prime } );
my $rem = $n;
my $iter = $factors.iterator;
while (my $factor := $iter.pull-one and $factor !=:= IterationEnd ) {
    while ( $rem %% $factor ) {
        $rem div= $factor;
        say "$factor : $rem";
    }
    if $rem == 1 {
        $factor.say;
        last
    }
}
