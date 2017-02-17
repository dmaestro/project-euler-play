# A perfect number is a number for which the sum of its proper divisors is
# exactly equal to the number. For example, the sum of the proper divisors
# of 28 would be 1 + 2 + 4 + 7 + 14 = 28, which means that 28 is a perfect
# number.
#
# A number n is called deficient if the sum of its proper divisors is less
# than n and it is called abundant if this sum exceeds n.
#
# As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest
# number that can be written as the sum of two abundant numbers is 24. By
# mathematical analysis, it can be shown that all integers greater than 28123
# can be written as the sum of two abundant numbers. However, this upper limit
# cannot be reduced any further by analysis even though it is known that the
# greatest number that cannot be expressed as the sum of two abundant numbers
# is less than this limit.
#
# Find the sum of all the positive integers which cannot be written as the sum
# of two abundant numbers.

subset Nat of Int where * > 0;

sub first_factor (Nat $n) {
    state Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    $primes.cache.first( $n %% * || * > sqrt($n) ).grep( $n %% * )[0]  // $n;
}

sub divisors(Nat $n) {
    state $factors = :{1 => 1.Set};  # Int => Set
    $factors{$n} //= Set.new(
        first_factor($n).&( { (1, $^f) X* divisors( $n div $^f ).keys } ).Slip
    );
    $factors{$n};
}

sub d(Nat $n) {
    [+] (divisors($n) (-) $n.Set).keys;
}

sub MAIN(Nat :$max = 28123) {
#   say "$_\t=> {d($_)}\t {is_abundant($_)}" for (1..$max);

    my $abundant = (12 ... $max).grep(*.&is_abundant);
    my $sum = 0;
    my $might_not_be_sums = SetHash.new;
    my $cursor = 0;
    my $max_considered = 0;
    SUM:
    for $abundant.cache -> $first_an {
        my $add_time = 0;
        my $sub_time = 0;
        for $abundant.cache.grep( * <= $first_an ) -> $second_an {
            FIRST {
                # we will not consider a sum this low again, so compute a partial sum
                my $new_cursor = ($first_an + $second_an) min $max_considered;
                if ( $new_cursor > $cursor ) {
                    my $newly_summed = $might_not_be_sums\
                        .grep( *.key < $new_cursor&($max+1) ).Set;
                    $might_not_be_sums (-)= $newly_summed (|) $new_cursor.Set;
                    $newly_summed.keys.sort.say;
                    $sum += [+] $newly_summed.keys;
                    $cursor = $new_cursor;
            #       "Cursor: $cursor".say;
            #       "Max Considered: $max_considered".say;
                }
            #   else {
            #       "No change!".say;
            #   }
                last SUM if $cursor >= $max;
            }
        #   "$first_an : $second_an".say;
            my $sum_an = $first_an + $second_an;
            next if $sum_an <= $cursor;
            last if $sum_an > $max;
            if ( $sum_an > $max_considered ) {
                # Add everything up to this sum to the "might" set
                my $adding_set = ($max_considered^..^$sum_an).Set;
                $might_not_be_sums.WHAT.say;
                $might_not_be_sums (|)= $adding_set;
                $max_considered = $sum_an;
                $add_time += now - ENTER { now };
            }
            else {
                # Remove this sum from the set
                $might_not_be_sums = $might_not_be_sums.SetHash;
                $might_not_be_sums{$sum_an}:delete;
                $sub_time += now - ENTER { now };
            }
        }
        say "Sub: $sub_time\nAdd: $add_time";
    }
    $sum.say;
}

sub is_abundant(Nat $n) {
    d($n) > $n;
}

