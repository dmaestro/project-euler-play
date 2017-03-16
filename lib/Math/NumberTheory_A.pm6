unit module Math::NumberTheory_A;

class Coord is export is Array {
    multi sub postcircumfix:<[ ]>(Positional $ary, Coord *$i) is export {
        reduce { $^a[$^b] // Nil }, $ary, |$i;
    }

    multi sub infix:<+>( Coord \a, Coord \b ) is export {
        Coord.new(a.flat Z+ b.flat);
    }

    multi sub infix:<->( Coord \a, Coord \b ) is export {
        Coord.new(a.flat Z- b.flat);
    }
}

enum DirL is export (
    SW  =>  Coord.new(1 ,-1),
    W   =>  Coord.new(0 ,-1),
);
