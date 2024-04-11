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

import openfl.errors.Error;

/** A class that provides constant values for horizontal alignment of objects. */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract HAlign(Null<Int>) {

	/** Left alignment. */
	public var LEFT = 0;

	/** Centered alignement. */
	public var CENTER = 1;

	/** Right alignment. */
	public var RIGHT = 2;

	@:from public static function fromString(value:String):HAlign {
		return switch (value) {
			case "left": LEFT;
			case "center": CENTER;
			case "right": RIGHT;
			default: null;
		}
	}

	@:to public function toString():String {
		return switch (cast this : HAlign) {
			case LEFT: "left";
			case CENTER: "center";
			case RIGHT: "right";
			default: null;
		}
	}
}
