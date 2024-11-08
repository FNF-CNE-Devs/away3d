package away3d.loaders.parsers;

import away3d.containers.ObjectContainer3D;
import away3d.core.base.CompactSubGeometry;
import away3d.core.base.Geometry;
import away3d.entities.Mesh;
import away3d.loaders.misc.ResourceDependency;
import away3d.loaders.parsers.utils.ParserUtil;
import away3d.materials.TextureMaterial;
import away3d.materials.TextureMultiPassMaterial;
import away3d.materials.utils.DefaultMaterialManager;
import away3d.textures.Texture2DBase;
import openfl.Vector;
import openfl.errors.Error;
import openfl.geom.Matrix3D;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

/**
 * AWD1Parser provides a parser for the AWD data type. The version 1.0 in ascii. Usually generated by Prefab3D 1.x and Away3D engine exporters.
 */
class AWD1Parser extends ParserBase {
	private static inline var LIMIT:Int = 65535;

	private var _textData:String;
	private var _startedParsing:Bool;
	private var _objs:Array<Dynamic>;
	private var _geos:Array<Dynamic>;
	private var _oList:Array<Dynamic>;
	private var _aC:Array<Dynamic>;
	private var _dline:Array<String>;
	private var _container:ObjectContainer3D;
	private var _meshList:Vector<Mesh>;
	private var _inited:Bool;
	private var _uvs:Array<Dynamic>;
	private var _charIndex:Int;
	private var _oldIndex:Int;
	private var _stringLength:Int;
	private var _state:String = "";
	private var _buffer:Int = 0;
	private var _isMesh:Bool;
	private var _isMaterial:Bool;
	private var _id:Int;

	/**
	 * Creates a new AWD1Parser object.
	 * @param uri The url or id of the data or file to be parsed.
	 * @param extra The holder for extra contextual data that the parser might need.
	 */
	public function new() {
		super(ParserDataFormat.PLAIN_TEXT);
	}

	/**
	 * Indicates whether or not a given file extension is supported by the parser.
	 * @param extension The file extension of a potential file to be parsed.
	 * @return Whether or not the given file type is supported.
	 */
	public static function supportsType(extension:String):Bool {
		extension = extension.toLowerCase();
		return extension == "awd";
	}

	/**
	 * Tests whether a data block can be parsed by the parser.
	 * @param data The data block to potentially be parsed.
	 * @return Whether or not the given data is supported.
	 */
	public static function supportsData(data:Dynamic):Bool {
		var ba:ByteArray;
		var str1:String;
		var str2:String;
		var readLength:Int = 100;

		ba = ParserUtil.toByteArray(data);

		if (ba != null) {
			if (ba.length < 100)
				readLength = ba.length;

			ba.position = 0;
			str1 = ba.readUTFBytes(2);
			str2 = ba.readUTFBytes(readLength);
		} else {
			str1 = isOfType(data, String) ? cast(data, String).substr(0, 5) : null;
			str2 = isOfType(data, String) ? cast(data, String).substr(0, readLength) : null;
		}
		if ((str1 == '//') && (str2.indexOf("#v:") != -1))
			return true;

		return false;
	}

	/**
	 * @inheritDoc
	 */
	override private function resolveDependency(resourceDependency:ResourceDependency):Void {
		if (resourceDependency.assets.length != 1)
			return;

		var asset:Texture2DBase = Utils.expect(resourceDependency.assets[0], Texture2DBase);
		var m:Mesh = retrieveMeshFromID(resourceDependency.id);

		if (m != null && asset != null) {
			if (materialMode < 2)
				cast(m.material, TextureMaterial).texture = asset;
			else
				cast(m.material, TextureMultiPassMaterial).texture = asset;
		}
	}

	/**
	 * @inheritDoc
	 */
	override private function resolveDependencyFailure(resourceDependency:ResourceDependency):Void {
		// missing load for resourceDependency.id;
	}

	/**
	 * @inheritDoc
	 */
	override private function proceedParsing():Bool {
		var line:String;
		var creturn:String = String.fromCharCode(10);

		if (!_startedParsing) {
			_textData = getTextData();
			_startedParsing = true;
		}

		if (_textData.indexOf("#t:bsp") != -1)
			throw new Error("AWD1 holding BSP information is not supported");

		if (_textData.indexOf(creturn) == -1 || _textData.indexOf(creturn) > 200)
			creturn = String.fromCharCode(13);

		if (!_inited) {
			_inited = true;
			_meshList = new Vector<Mesh>();
			_stringLength = _textData.length;
			_charIndex = _textData.indexOf(creturn, 0);
			_oldIndex = _charIndex;
			_objs = [];
			_geos = [];
			_oList = [];
			_dline = [];
			_aC = [];

			_container = new ObjectContainer3D();
		}

		var cont:ObjectContainer3D = null;
		var i:Int;
		var oData:Dynamic;
		var m:Matrix3D = null;

		while (_charIndex < _stringLength && hasTime()) {
			_charIndex = _textData.indexOf(creturn, _oldIndex);

			if (_charIndex == -1)
				_charIndex = _stringLength;

			line = _textData.substring(_oldIndex, _charIndex);

			if (_charIndex != _stringLength)
				_oldIndex = _charIndex + 1;

			if (line.substring(0, 1) == "#" && _state != line.substring(0, 2)) {
				_state = line.substring(0, 2);
				_id = 0;
				_buffer = 0;
				// unused in f11
				if (_state == "#v")
					line.substring(3, line.length - 1);

				if (_state == "#f")
					_isMaterial = Std.parseInt(line.substring(3, 4)) == 2;

				if (_state == "#t")
					_isMesh = (line.substring(3, 7) == "mesh");

				continue;
			}

			_dline = line.split(",");

			if (_dline.length <= 1 && !(_state == "#m" || _state == "#d"))
				continue;

			if (_state == "#o") {
				if (_buffer == 0) {
					_id = Std.parseInt(_dline[0]);
					m = new Matrix3D(Vector.ofArray([
						Std.parseFloat(_dline[1]), Std.parseFloat(_dline[5]), Std.parseFloat(_dline[9]), 0, Std.parseFloat(_dline[2]),
						Std.parseFloat(_dline[6]), Std.parseFloat(_dline[10]), 0, Std.parseFloat(_dline[3]), Std.parseFloat(_dline[7]),
						Std.parseFloat(_dline[11]), 0, Std.parseFloat(_dline[4]), Std.parseFloat(_dline[8]), Std.parseFloat(_dline[12]), 1
					]));

					++_buffer;
				} else {
					// legacy properties left here in case of debug needs
					oData = {
						name: (_dline[0] == "") ? "m_" + _id : _dline[0],
						transform: m,
						// pivotPoint:new Vector3D(parseFloat(_dline[1]), parseFloat(_dline[2]), parseFloat(_dline[3])),
						container: Std.parseInt(_dline[4]),
						bothSides: (_dline[5] == "true") ? true : false,
						// ownCanvas:(_dline[6] == "true")? true : false,
						// pushfront:(_dline[7] == "true")? true : false,
						// pushback:(_dline[8] == "true")? true : false,
						x: Std.parseFloat(_dline[9]),
						y: Std.parseFloat(_dline[10]),
						z: Std.parseFloat(_dline[11]),

						material: (_isMaterial && _dline[12] != null && _dline[12] != "") ? _dline[12] : null
					};
					_objs.push(oData);
					_buffer = 0;
				}
			}

			if (_state == "#d") {
				switch (_buffer) {
					case 0:
						_id = _geos.length;
						_geos.push({});
						++_buffer;
						_geos[_id].aVstr = line.substring(2, line.length);

					case 1:
						_geos[_id].aUstr = line.substring(2, line.length);
						_geos[_id].aV = read(_geos[_id].aVstr).split(",");
						_geos[_id].aU = read(_geos[_id].aUstr).split(",");
						++_buffer;

					case 2:
						_geos[_id].f = line.substring(2, line.length);
						_objs[_id].geo = _geos[_id];
						_buffer = 0;
				}
			}

			if (_state == "#c" && !_isMesh) {
				_id = Std.parseInt(_dline[0]);
				cont = (_aC.length == 0) ? _container : new ObjectContainer3D();
				m = new Matrix3D(Vector.ofArray([
					Std.parseFloat(_dline[1]), Std.parseFloat(_dline[5]), Std.parseFloat(_dline[9]), 0, Std.parseFloat(_dline[2]), Std.parseFloat(_dline[6]),
					Std.parseFloat(_dline[10]), 0, Std.parseFloat(_dline[3]), Std.parseFloat(_dline[7]), Std.parseFloat(_dline[11]), 0,
					Std.parseFloat(_dline[4]), Std.parseFloat(_dline[8]), Std.parseFloat(_dline[12]), 1
				]));

				cont.transform = m;
				cont.name = (_dline[13] == "null" || _dline[13] == null) ? "cont_" + _id : _dline[13];

				_aC.push(cont);

				if (cont != _container)
					_aC[0].addChild(cont);
			}
		}

		if (_charIndex >= _stringLength) {
			var ref:Dynamic;
			var mesh:Mesh;

			for (i in 0..._objs.length) {
				ref = _objs[i];
				if (ref != null && ref.geo != null) {
					mesh = new Mesh(new Geometry(), null);
					mesh.name = ref.name;
					_meshList.push(mesh);

					if (ref.container != -1 && !_isMesh)
						_aC[ref.container].addChild(mesh);

					mesh.transform = ref.transform;
					if (materialMode < 2)
						mesh.material = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					else
						mesh.material = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());

					mesh.material.bothSides = ref.bothSides;

					if (ref.material != null && ref.material != "")
						addDependency(ref.name, new URLRequest(ref.material));

					mesh.material.name = ref.name;

					if (ref.material != null && ref.material != "")
						addDependency(ref.name, new URLRequest(ref.material));

					parseFacesToMesh(ref.geo, mesh);

					finalizeAsset(mesh);
				}
			}
			_objs = _geos = _oList = _aC = _uvs = null;

			// TODO: Don't just return the container. Return assets one by one
			finalizeAsset(_container);

			return ParserBase.PARSING_DONE;
		}

		return ParserBase.MORE_TO_PARSE;
	}

	private function parseFacesToMesh(geo:Dynamic, mesh:Mesh):Void {
		var j:Int;
		var av:Array<String>;
		var au:Array<String>;

		var aRef:Array<String>;
		var mRef:Array<String>;

		var vertices:Vector<Float> = new Vector<Float>();
		var indices:Vector<UInt> = new Vector<UInt>();
		var uvs:Vector<Float> = new Vector<Float>();
		var index:Int = 0;
		var vindex:Int = 0;
		var uindex:Int = 0;

		aRef = geo.f.split(",");
		if (geo.m != null)
			mRef = geo.m.split(",");

		var sub_geom:CompactSubGeometry;
		var geom:Geometry = mesh.geometry;

		j = 0;
		while (j < aRef.length) {
			if (indices.length + 3 > LIMIT) {
				sub_geom = new CompactSubGeometry();
				sub_geom.updateIndexData(indices);
				sub_geom.fromVectors(vertices, uvs, null, null);
				geom.addSubGeometry(sub_geom);

				vertices = new Vector<Float>();
				indices = new Vector<UInt>();
				uvs = new Vector<Float>();
				vindex = index = uindex = 0;
			}

			indices[vindex] = vindex;
			vindex++;
			indices[vindex] = vindex;
			vindex++;
			indices[vindex] = vindex;
			vindex++;

			// face is inverted compared to f10 awd generator
			av = geo.aV[Std.parseInt(aRef[j + 1])].split("/");
			vertices[index++] = Std.parseFloat(av[0]);
			vertices[index++] = Std.parseFloat(av[1]);
			vertices[index++] = Std.parseFloat(av[2]);

			av = geo.aV[Std.parseInt(aRef[j])].split("/");
			vertices[index++] = Std.parseFloat(av[0]);
			vertices[index++] = Std.parseFloat(av[1]);
			vertices[index++] = Std.parseFloat(av[2]);

			av = geo.aV[Std.parseInt(aRef[j + 2])].split("/");
			vertices[index++] = Std.parseFloat(av[0]);
			vertices[index++] = Std.parseFloat(av[1]);
			vertices[index++] = Std.parseFloat(av[2]);

			au = geo.aU[Std.parseInt(aRef[j + 4])].split("/");
			uvs[uindex++] = Std.parseFloat(au[0]);
			uvs[uindex++] = 1 - Std.parseFloat(au[1]);

			au = geo.aU[Std.parseInt(aRef[j + 3])].split("/");
			uvs[uindex++] = Std.parseFloat(au[0]);
			uvs[uindex++] = 1 - Std.parseFloat(au[1]);

			au = geo.aU[Std.parseInt(aRef[j + 5])].split("/");
			uvs[uindex++] = Std.parseFloat(au[0]);
			uvs[uindex++] = 1 - Std.parseFloat(au[1]);

			j += 6;
		}

		sub_geom = new CompactSubGeometry();
		sub_geom.updateIndexData(indices);
		sub_geom.fromVectors(vertices, uvs, null, null);
		geom.addSubGeometry(sub_geom);
	}

	private function retrieveMeshFromID(id:String):Mesh {
		for (i in 0..._meshList.length) {
			if (cast(_meshList[i], Mesh).name == id)
				return cast(_meshList[i], Mesh);
		}

		return null;
	}

	private function read(str:String):String {
		var start:Int = 0;
		var chunk:String;
		var dec:String = "";
		var charcount:Int = str.length;

		var i:Int = 0;
		while (i < charcount) {
			if (str.charCodeAt(i) >= 44 && str.charCodeAt(i) <= 48)
				dec += str.substring(i, i + 1);
			else {
				start = i;
				chunk = "";
				while (str.charCodeAt(i) != 44 && str.charCodeAt(i) != 45 && str.charCodeAt(i) != 46 && str.charCodeAt(i) != 47 && i <= charcount)
					i++;
				chunk = StringTools.hex(Std.parseInt(str.substring(start, i)));
				dec += chunk;
				i--;
			}
			i++;
		}
		return dec;
	}
}
