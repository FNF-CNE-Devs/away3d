package away3d.library.naming;

/**
 * Enumaration class for precedence when resolving naming conflicts in the library.
 *
 * @see away3d.library.Asset3DLibrary.conflictPrecedence
 * @see away3d.library.Asset3DLibrary.conflictStrategy
 * @see away3d.library.naming.ConflictStrategy
 */
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ConflictPrecedence(Bool) {
	/**
	 * Signals that in a conflict, the previous owner of the conflicting name
	 * should be favored (and keep it's name) and that the newly renamed asset
	 * is reverted to a non-conflicting name.
	 */
	public var FAVOR_OLD = false;

	/**
	 * Signales that in a conflict, the newly renamed asset is favored (and keeps
	 * it's newly defined name) and that the previous owner of that name gets
	 * renamed to a non-conflicting name.
	 */
	public var FAVOR_NEW = true;

	public static function fromString(value:String):ConflictPrecedence
	{
		return switch (value)
		{
			case "favorOld": FAVOR_OLD;
			case "favorNew": FAVOR_NEW;
			default: FAVOR_OLD;
		}
	}

	@:to public function toString():String
	{
		return switch (cast this : ConflictPrecedence)
		{
			case FAVOR_OLD: "favorOld";
			case FAVOR_NEW: "favorNew";
		}
	}
}
