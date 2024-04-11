package away3d.animators.data;

/**
 * Options for setting the animation mode of a vertex animator object.
 *
 * @see away3d.animators.VertexAnimator
 */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract VertexAnimationMode(Null<Int>) {
	/**
	 * Animation mode that adds all outputs from active vertex animation state to form the current vertex animation pose.
	 */
	public var ADDITIVE = 0;

	/**
	 * Animation mode that picks the output from a single vertex animation state to form the current vertex animation pose.
	 */
	public var ABSOLUTE = 1;

	@:from public static function fromString(value:String):VertexAnimationMode
	{
		return switch (value)
		{
			case "additive": ADDITIVE;
			case "absolute": ABSOLUTE;
			default: null;
		}
	}

	@:to public function toString():String
	{
		return switch (cast this : VertexAnimationMode)
		{
			case ADDITIVE: "additive";
			case ABSOLUTE: "absolute";
			default: null;
		}
	}
}
