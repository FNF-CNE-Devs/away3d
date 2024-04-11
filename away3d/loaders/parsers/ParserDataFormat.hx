package away3d.loaders.parsers;

/**
 * An enumeration providing values to describe the data format of parsed data.
 */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ParserDataFormat(Bool) {

	/**
	 * Describes the format of a binary file.
	 */
	public var BINARY = true;

	/**
	 * Describes the format of a plain text file.
	 */
	public var PLAIN_TEXT = false;

	@:from public static function fromString(value:String):ParserDataFormat {
		return switch (value) {
			case "binary": BINARY;
			case "plainText": PLAIN_TEXT;
			default: BINARY;
		}
	}

	@:to public function toString():String {
		return switch (cast this : ParserDataFormat) {
			case BINARY: "binary";
			case PLAIN_TEXT: "plainText";
		}
	}
}
