unit module Math::NumberTheory;

class Types {
    subset Nat is export of Int where * > 0;
}

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
