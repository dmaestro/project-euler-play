sub large_prime_factor (Int $n) {
    (flat(2, (3,5 ...^ * > sqrt($n) ), $n ).grep( { $n %% $_ && .is-prime } ))[ * - 1 ]
}

multi sub largest_prime_factor (Int $n where *.is-prime) { $n }

multi sub largest_prime_factor (Int $n) {
    my Int $large_prime = large_prime_factor ($n);
    my $conjugate_factor = $n div $large_prime;
    say "Conjugate factor: "~$conjugate_factor;
    return $conjugate_factor.is-prime
        ?? $conjugate_factor
        !! $large_prime;
}

say largest_prime_factor (600851475143);

