unit module Math::NumberTheory;

### Types
class Types {
    subset Nat is export of Int where * > 0;
}

### Matrix lookup
class Coordinate is export is List {
    multi sub postcircumfix:<[ ]>(Positional $ary, Coordinate *$i) is export {
        reduce { $^a[$^b] // Nil }, $ary, |$i;
    }

    multi sub infix:<+>( Coordinate \a, Coordinate \b ) is export {
        Coordinate.new( | (a.flat Z+ b.flat) );
    }

    multi sub infix:<->( Coordinate \a, Coordinate \b ) is export {
        Coordinate.new( | (a.flat Z- b.flat) );
    }

    method unit-vectors {
        map { Coordinate(|$_) },
            unit-vectors(self)
    }
}

sub unit-vectors (+@coordinate) is export {
    gather {
        for @coordinate.keys -> $i {
            take eager map { +($_ == $i) }, @coordinate.keys
        }
    }
}

constant Origin is export := Coordinate(0, 0);

enum Dir is export (
    N   =>  Coordinate(-1, 0),
    NE  =>  Coordinate(-1, 1),
    E   =>  Coordinate( 0, 1),
    SE  =>  Coordinate( 1, 1),
    S   =>  Coordinate( 1, 0),
    SW  =>  Coordinate( 1,-1),
    W   =>  Coordinate( 0,-1),
    NW  =>  Coordinate(-1,-1),
);

### Primes and factoring

sub primes( --> List) is export {
    state Seq $primes = (2,3, (* + 2) ... *).grep( { .is-prime } );
    $primes.cache;
}

sub first_factor(Types::Nat $n) is export {
    fail if $n == 1;
    primes.first( $n %% * || * > sqrt($n) ).grep( $n %% * )[0]  // $n;
}

sub prime_factors(Types::Nat $n --> Seq) is export {
    gather {
        my $rem = $n;
        while $rem > 1 {
            my $factor = first_factor($rem);
            take $factor;
            while $rem %% $factor {
                $rem div= $factor;
            }
        }
    }
}

sub all_divisors(Types::Nat $n --> Set) is export {
    state $factors = :{1 => Set.new(1)};  # Int => Set
    $factors{$n} //= Set.new(
        first_factor($n).&( { (1, $^f) X* all_divisors( $n div $^f ).keys } ).Slip
    );
    $factors{$n};
}

