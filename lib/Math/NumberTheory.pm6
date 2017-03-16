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

enum Dir is export (
    E   =>  Coordinate.new(0, 1),
    SE  =>  Coordinate.new(1 ,1),
);
