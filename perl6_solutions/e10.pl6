subset Nat of Int where * > 0;

sub MAIN(Nat :$limit = 2_000_000) {
    say [+] (2, (3,5 ...^ * > $limit)).flat.grep: { .is-prime };
}
