package away3d.loaders.misc;

@:allow(away3d)
class AssetLoaderContext {
	public static inline var UNDEFINED:UInt = 0;
	public static inline var SINGLEPASS_MATERIALS:UInt = 1;
	public static inline var MULTIPASS_MATERIALS:UInt = 2;

	private var _includeDependencies:Bool;
	private var _dependencyBaseUrl:String;
	private var _embeddedDataByUrl:Map<String, Dynamic>;
	private var _remappedUrls:Map<String, String>;
	private var _materialMode:UInt;

	private var _overrideAbsPath:Bool;
	private var _overrideFullUrls:Bool;

	/**
	 * AssetLoaderContext provides configuration for the AssetLoader load() and parse() operations.
	 * Use it to configure how (and if) dependencies are loaded, or to map dependency URLs to
	 * embedded data.
	 *
	 * @see away3d.loading.AssetLoader
	 */
	public function new(includeDependencies:Bool = true, dependencyBaseUrl:String = null) {
		_overrideAbsPath = false;
		_overrideFullUrls = false;
		_includeDependencies = includeDependencies;
		_dependencyBaseUrl = dependencyBaseUrl != null ? dependencyBaseUrl : '';
		_embeddedDataByUrl = new Map<String, Dynamic>();
		_remappedUrls = new Map<String, String>();
		_materialMode = UNDEFINED;
	}

	/**
	 * Defines whether dependencies (all files except the one at the URL given to the load() or
	 * parseData() operations) should be automatically loaded. Defaults to true.
	 */
	public var includeDependencies(get, set):Bool;

	private inline function get_includeDependencies():Bool {
		return _includeDependencies;
	}

	private inline function set_includeDependencies(val:Bool):Bool {
		return _includeDependencies = val;
	}

	/**
	 * MaterialMode defines, if the Parser should create SinglePass or MultiPass Materials
	 * Options:
	 * 0 (Default / undefined) - All Parsers will create SinglePassMaterials, but the AWD2.1parser will create Materials as they are defined in the file
	 * 1 (Force SinglePass) - All Parsers create SinglePassMaterials
	 * 2 (Force MultiPass) - All Parsers will create MultiPassMaterials
	 */
	public var materialMode(get, set):UInt;

	private inline function get_materialMode():UInt {
		return _materialMode;
	}

	private inline function set_materialMode(val:UInt):UInt {
		return _materialMode = val;
	}

	/**
	 * A base URL that will be prepended to all relative dependency URLs found in a loaded resource.
	 * Absolute paths will not be affected by the value of this property.
	 */
	public var dependencyBaseUrl(get, set):String;

	private inline function get_dependencyBaseUrl():String {
		return _dependencyBaseUrl;
	}

	private inline function set_dependencyBaseUrl(val:String):String {
		return _dependencyBaseUrl = val;
	}

	/**
	 * Defines whether absolute paths (defined as paths that begin with a "/") should be overridden
	 * with the dependencyBaseUrl defined in this context. If this is true, and the base path is
	 * "base", /path/to/asset.jpg will be resolved as base/path/to/asset.jpg.
	 */
	public var overrideAbsolutePaths(get, set):Bool;

	private inline function get_overrideAbsolutePaths():Bool {
		return _overrideAbsPath;
	}

	private inline function set_overrideAbsolutePaths(val:Bool):Bool {
		return _overrideAbsPath = val;
	}

	/**
	 * Defines whether "full" URLs (defined as a URL that includes a scheme, e.g. http://) should be
	 * overridden with the dependencyBaseUrl defined in this context. If this is true, and the base
	 * path is "base", http://example.com/path/to/asset.jpg will be resolved as base/path/to/asset.jpg.
	 */
	public var overrideFullURLs(get, set):Bool;

	private inline function get_overrideFullURLs():Bool {
		return _overrideFullUrls;
	}

	private inline function set_overrideFullURLs(val:Bool):Bool {
		return _overrideFullUrls = val;
	}

	/**
	 * Map a URL to another URL, so that files that are referred to by the original URL will instead
	 * be loaded from the new URL. Use this when your file structure does not match the one that is
	 * expected by the loaded file.
	 *
	 * @param originalUrl The original URL which is referenced in the loaded resource.
	 * @param newUrl The URL from which Away3D should load the resource instead.
	 *
	 * @see mapUrlToData()
	 */
	public inline function mapUrl(originalUrl:String, newUrl:String):Void {
		_remappedUrls[originalUrl] = newUrl;
	}

	/**
	 * Map a URL to embedded data, so that instead of trying to load a dependency from the URL at
	 * which it's referenced, the dependency data will be retrieved straight from the memory instead.
	 *
	 * @param originalUrl The original URL which is referenced in the loaded resource.
	 * @param data The embedded data. Can be ByteArray or a class which can be used to create a bytearray.
	 */
	public inline function mapUrlToData(originalUrl:String, data:Dynamic):Void {
		_embeddedDataByUrl[originalUrl] = data;
	}

	/**
	 * Defines whether embedded data has been mapped to a particular URL.
	 */
	private inline function hasDataForUrl(url:String):Bool {
		return _embeddedDataByUrl.exists(url);
	}

	/**
	 * Returns embedded data for a particular URL.
	 */
	private inline function getDataForUrl(url:String):Dynamic {
		return _embeddedDataByUrl[url];
	}

	/**
	 * Defines whether a replacement URL has been mapped to a particular URL.
	 */
	private inline function hasMappingForUrl(url:String):Bool {
		return _remappedUrls.exists(url);
	}

	/**
	 * Returns new (replacement) URL for a particular original URL.
	 */
	private inline function getRemappedUrl(originalUrl:String):String {
		return _remappedUrls[originalUrl];
	}
}
