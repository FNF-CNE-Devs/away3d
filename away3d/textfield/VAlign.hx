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

/** A class that provides constant values for vertical alignment of objects. */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract VAlign(Null<Int>) {
	/** Top alignment. */
	public var TOP = 0;

	/** Centered alignment. */
	public var CENTER = 1;

	/** Bottom alignment. */
	public var BOTTOM = 2;

	@:from public static function fromString(value:String):VAlign
	{
		return switch (value)
		{
			case "top": TOP;
			case "center": CENTER;
			case "bottom": BOTTOM;
			default: null;
		}
	}

	@:to public function toString():String
	{
		return switch (cast this : VAlign)
		{
			case TOP: "top";
			case CENTER: "center";
			case BOTTOM: "bottom";
			default: null;
		}
	}
}
