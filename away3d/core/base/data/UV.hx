package away3d.core.base.data;

/**
 * Texture coordinates value object.
 */
class UV {
	public var v(get, set):Float;
	public var u(get, set):Float;

	private var _u:Float;
	private var _v:Float;

	/**
	 * Creates a new <code>UV</code> object.
	 *
	 * @param    u        [optional]    The horizontal coordinate of the texture value. Defaults to 0.
	 * @param    v        [optional]    The vertical coordinate of the texture value. Defaults to 0.
	 */
	public function new(u:Float = 0, v:Float = 0) {
		_u = u;
		_v = v;
	}

	/**
	 * Defines the vertical coordinate of the texture value.
	 */
	private inline function get_v():Float {
		return _v;
	}
	private inline function set_v(value:Float):Float {
		return _v = value;
	}

	/**
	 * Defines the horizontal coordinate of the texture value.
	 */
	private inline function get_u():Float {
		return _u;
	}
	private inline function set_u(value:Float):Float {
		return _u = value;
	}

	public inline function set(u:Float, v:Float):Void {
		_u = u;
		_v = v;
	}

	/**
	 * returns a new UV value Object
	 */
	public inline function clone():UV {
		return new UV(_u, _v);
	}

	/**
	 * returns the value object as a string for trace/debug purpose
	 */
	public function toString():String {
		return _u + "," + _v;
	}
}
