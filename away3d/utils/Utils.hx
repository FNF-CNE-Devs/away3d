package away3d.utils;

class Utils {
	public static function expect<T>(obj:Dynamic, type:Class<T>):Null<T> {
		return isOfType(obj, type) ? cast obj : null;
	}
}
