// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package away3d.textfield;

/** A BitmapChar contains the information about one char of a bitmap font.
 *  <em>You don't have to use this class directly in most cases.
 *  The TextField class contains methods that handle bitmap fonts for you.</em>
 */
class BitmapChar {
	private var _charID:Int;
	private var _xOffset:Float;
	private var _yOffset:Float;
	private var _xAdvance:Float;
	private var _kernings:Map<Int, Float>;

	private var _x:Float;
	private var _y:Float;
	private var _width:Float;
	private var _height:Float;

	/** Creates a char with a texture and its properties. */
	public function new(id:Int, x:Float, y:Float, width:Float, height:Float, xOffset:Float, yOffset:Float, xAdvance:Float) {
		_charID = id;
		_xOffset = xOffset;
		_yOffset = yOffset;
		_xAdvance = xAdvance;
		_kernings = null;
		_x = x;
		_y = y;
		_width = width;
		_height = height;
	}

	/** Adds kerning information relative to a specific other character ID. */
	public function addKerning(charID:Int, amount:Float):Void {
		if (_kernings == null)
			_kernings = new Map<Int, Float>();

		_kernings[charID] = amount;
	}

	/** Retrieve kerning information relative to the given character ID. */
	public function getKerning(charID:Int):Float {
		if (_kernings == null || !_kernings.exists(charID))
			return 0.0;
		return _kernings[charID];
	}

	/** The unicode ID of the char. */
	public var charID(get, set):Int;

	private inline function get_charID():Int {
		return _charID;
	}

	private inline function set_charID(val:Int):Int {
		return _charID = val;
	}

	/** The number of points to move the char in x direction on character arrangement. */
	public var xOffset(get, set):Float;

	private inline function get_xOffset():Float {
		return _xOffset;
	}

	private inline function set_xOffset(val:Float):Float {
		return _xOffset = val;
	}

	/** The number of points to move the char in y direction on character arrangement. */
	public var yOffset(get, set):Float;

	private inline function get_yOffset():Float {
		return _yOffset;
	}

	private inline function set_yOffset(val:Float):Float {
		return _yOffset = val;
	}

	/** The number of points the cursor has to be moved to the right for the next char. */
	public var xAdvance(get, set):Float;

	private inline function get_xAdvance():Float {
		return _xAdvance;
	}

	private inline function set_xAdvance(val:Float):Float {
		return _xAdvance = val;
	}

	/** The width of the character in points. */
	public var width(get, set):Float;

	private inline function get_width():Float {
		return _width;
	}

	private inline function set_width(val:Float):Float {
		return _width = val;
	}

	/** The height of the character in points. */
	public var height(get, set):Float;

	private inline function get_height():Float {
		return _height;
	}

	private inline function set_height(val:Float):Float {
		return _height = val;
	}

	public var x(get, set):Float;

	private inline function get_x():Float {
		return _x;
	}

	private inline function set_x(val:Float):Float {
		return _x = val;
	}

	public var y(get, set):Float;

	private inline function get_y():Float {
		return _y;
	}

	private inline function set_y(val:Float):Float {
		return _y = val;
	}
}
