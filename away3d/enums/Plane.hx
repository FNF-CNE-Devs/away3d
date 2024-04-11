package away3d.enums;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Plane(Int) {

	public var XZ = 0;
	public var XY = 1;
	public var ZY = 2;

	@:to public inline function toString():String {
		return switch (cast this) {
			case XZ: "xz";
			case XY: "xy";
			case ZY: "zy";
		}
	}

	@:from public static inline function fromString(s:String):Plane {
		return switch (s) {
			case "xz" | "zx": XZ;
			case "xy" | "yx": XY;
			case "zy" | "yz": ZY;
			default: throw "Invalid plane string: " + s;
		}
	}
}
