package away3d.loaders.parsers;

import away3d.loaders.misc.SingleFileLoader;
import openfl.Vector;

class Parsers {
	/**
	 * A list of all parsers that come bundled with Away3D. Use this to quickly
	 * enable support for all bundled parsers to the file format auto-detection
	 * feature, using any of the enableParsers() methods on loaders, e.g.:
	 *
	 * <code>Asset3DLibrary.enableParsers(Parsers.ALL_BUNDLED);</code>
	 *
	 * Beware however that this requires all parser classes to be included in the
	 * SWF file, which will add 50-100 kb to the file. When only a limited set of
	 * file formats are used, SWF file size can be saved by adding the parsers
	 * individually using Asset3DLibrary.enableParser()
	 *
	 * A third way is to specify a parser for each loaded file, thereby bypassing
	 * the auto-detection mechanisms altogether, while at the same time allowing
	 * any properties that are unique to that parser to be set for that load.
	 *
	 * The bundled parsers are:
	 *
	 * <ul>
	 * <li>AC3D (.ac)</li>
	 * <li>Away Data version 1 ASCII and version 2 binary (.awd). AWD1 BSP unsupported</li>
	 * <li>3DMax (.3ds)</li>
	 * <li>DXF (.dxf)</li>
	 * <li>Quake 2 MD2 models (.md2)</li>
	 * <li>Doom 3 MD5 animation clips (.md5anim)</li>
	 * <li>Doom 3 MD5 meshes (.md5mesh)</li>
	 * <li>Wavefront OBJ (.obj)</li>
	 * <li>Collada (.dae)</li>
	 * <li>Images (.jpg, .png)</li>
	 * </ul>
	 *
	 * @see away3d.loading.Asset3DLibrary.enableParser
	 */
	public static var ALL_BUNDLED:Array<Dynamic> = [
		AC3DParser, AWD1Parser, AWD2Parser, AWDParser, Max3DSParser, DXFParser, MD2Parser, MD5AnimParser, MD5MeshParser, OBJParser, DAEParser, Max3DSParser
	];

	/**
	 * Short-hand function to enable all bundled parsers for auto-detection. In practice,
	 * this is the same as invoking enableParsers(Parsers.ALL_BUNDLED) on any of the
	 * loader classes SingleFileLoader, AssetLoader, Asset3DLibrary or Loader3D.
	 *
	 * See notes about file size in the documentation for the ALL_BUNDLED constant.
	 *
	 * @see away3d.loaders.parsers.Parsers.ALL_BUNDLED
	 */
	public static function enableAllBundled():Void {
		SingleFileLoader.enableParsers(ALL_BUNDLED);
	}
}
