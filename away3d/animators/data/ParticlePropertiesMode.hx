package away3d.animators.data;

/**
 * Options for setting the properties mode of a particle animation node.
 */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ParticlePropertiesMode(Int) {

	/**
	 * Mode that defines the particle node as acting on global properties (ie. the properties set in the node constructor or the corresponding animation state).
	 */
	public var GLOBAL = 0;

	/**
	 * Mode that defines the particle node as acting on local static properties (ie. the properties of particles set in the initialising function on the animation set).
	 */
	public var LOCAL_STATIC = 1;

	/**
	 * Mode that defines the particle node as acting on local dynamic properties (ie. the properties of the particles set in the corresponding animation state).
	 */
	public var LOCAL_DYNAMIC = 2;

	@:from public static function fromString(value:String):ParticlePropertiesMode {
		return switch (value) {
			case "Global": GLOBAL;
			case "LocalStatic": LOCAL_STATIC;
			case "LocalDynamic": LOCAL_DYNAMIC;
			default: throw "Unknown ParticlePropertiesMode value: " + value;
		}
	}

	@:to public function toString():String {
		return switch (cast this : ParticlePropertiesMode) {
			case GLOBAL: "Global";
			case LOCAL_STATIC: "LocalStatic";
			case LOCAL_DYNAMIC: "LocalDynamic";
			default: "Unknown";
		}
	}
}
