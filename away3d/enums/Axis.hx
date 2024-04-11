package away3d.enums;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Axis(Int) {
    public var X = 0;
    public var Y = 1;
    public var Z = 2;

    public inline function toString():String {
        return switch (cast this) {
            case X: "x";
            case Y: "y";
            case Z: "z";
        }
    }

    public static inline function fromString(s:String):Axis {
        return switch (s) {
            case "x": X;
            case "y": Y;
            case "z": Z;
            default: throw "Invalid axis string: " + s;
        }
    }
}