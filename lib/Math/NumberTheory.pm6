unit module Math::NumberTheory;

class Types {
    subset Nat is export of Int where * > 0;
}

class Coordinate is export is List {
    multi sub infix:<+>( Coordinate \a, Coordinate \b ) is export {
        Coordinate.new( | (a.flat Z+ b.flat) );
    }

    multi sub infix:<->( Coordinate \a, Coordinate \b ) is export {
        Coordinate.new( | (a.flat Z- b.flat) );
    }
}
