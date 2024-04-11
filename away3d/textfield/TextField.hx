package away3d.textfield;

import away3d.core.base.CompactSubGeometry;
import away3d.core.base.Geometry;
import away3d.entities.Mesh;
import away3d.materials.SinglePassMaterialBase;
import away3d.materials.TextureMaterial;
import away3d.materials.methods.ColorTransformMethod;
import openfl.Vector;
import openfl.display.DisplayObjectContainer;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.text.TextFieldAutoSize;

class TextField extends Mesh {
	private var vertexData:Vector<Float> = new Vector<Float>();
	private var indexData:Vector<UInt> = new Vector<UInt>();
	private var _text:String = "";
	private var _bitmapFont:BitmapFont;
	private var _fontSize:Float;
	private var _color:UInt;
	private var _hAlign:HAlign;
	private var _vAlign:VAlign;
	private var _bold:Bool;
	private var _italic:Bool;
	private var _underline:Bool;
	private var _autoScale:Bool;
	private var _autoSize:TextFieldAutoSize;
	private var _kerning:Bool;
	private var _letterSpacing:Float = 0;
	private var _border:DisplayObjectContainer;

	public var _width:Float;
	public var _height:Float;

	public var disposeMaterial:Bool = true;

	private var _boundsRect:Rectangle = new Rectangle();

	private var _textHeight:Float;
	private var _textWidth:Float;

	private var _subGeometry:CompactSubGeometry;
	private var colorTransformMethod:ColorTransformMethod;
	private var textureMaterial:TextureMaterial;

	public function new(width:Float, height:Float, text:String, bitmapFont:BitmapFont, fontSize:Float = 12, color:UInt = 0x0, bold:Bool = false,
			hAlign:HAlign = LEFT) {
		super(new Geometry(), bitmapFont.fontMaterial);

		_text = text;
		_bitmapFont = bitmapFont;

		_width = width;
		_height = height;
		_fontSize = fontSize;
		_color = color;
		_hAlign = hAlign;
		_vAlign = VAlign.TOP;
		_border = null;
		_kerning = true;
		_bold = bold;
		_autoSize = TextFieldAutoSize.NONE;
		_subGeometry = new CompactSubGeometry();
		_subGeometry.autoDeriveVertexNormals = true;
		_subGeometry.autoDeriveVertexTangents = true;
		geometry.addSubGeometry(_subGeometry);

		textureMaterial = bitmapFont.fontMaterial;
		var rgb:Vector<UInt> = HexToRGB(color);
		if (textureMaterial.colorTransform == null)
			textureMaterial.colorTransform = new ColorTransform();
		textureMaterial.colorTransform.redMultiplier = rgb[0] / 255;
		textureMaterial.colorTransform.greenMultiplier = rgb[1] / 255;
		textureMaterial.colorTransform.blueMultiplier = rgb[2] / 255;
		textureMaterial.colorTransform.alphaMultiplier = textureMaterial.alpha;

		material = textureMaterial;

		material.alphaPremultiplied = true;
		var castMat:SinglePassMaterialBase = expect(material, SinglePassMaterialBase);
		if (castMat != null)
			castMat.alphaBlending = true;

		updateText();
	}

	public function HexToRGB(hex:UInt):Vector<UInt> {
		var rgb = new Vector<UInt>(3);
		var r:UInt = hex >> 16 & 0xFF;
		var g:UInt = hex >> 8 & 0xFF;
		var b:UInt = hex & 0xFF;
		rgb.push(r);
		rgb.push(g);
		rgb.push(b);
		return rgb;
	}

	override public function dispose():Void {
		if (disposeMaterial)
			material.dispose();
		super.dispose();
	}

	private function updateText():Void {
		_bitmapFont.fillBatched(vertexData, indexData, _width, _height, _text, _fontSize, _hAlign, _vAlign, _autoScale, _kerning, _letterSpacing);

		_subGeometry.updateData(vertexData);
		_subGeometry.updateIndexData(indexData);
	}

	/** Indicates whether the text is bold. @default false */
	public var bold(get, set):Bool;

	private inline function get_bold():Bool {
		return _bold;
	}

	private function set_bold(value:Bool):Bool {
		if (_bold != value) {
			_bold = value;
			updateText();
		}
		return value;
	}

	/** Indicates whether the text is italicized. @default false */
	public var italic(get, set):Bool;

	private inline function get_italic():Bool {
		return _italic;
	}

	private function set_italic(value:Bool):Bool {
		if (_italic != value) {
			_italic = value;
			updateText();
		}
		return value;
	}

	/** Indicates whether the text is underlined. @default false */
	public var underline(get, set):Bool;

	private inline function get_underline():Bool {
		return _underline;
	}

	private function set_underline(value:Bool):Bool {
		if (_underline != value) {
			_underline = value;
			updateText();
		}
		return value;
	}

	/** Indicates whether kerning is enabled. @default true */
	public var kerning(get, set):Bool;

	private inline function get_kerning():Bool {
		return _kerning;
	}

	private function set_kerning(value:Bool):Bool {
		if (_kerning != value) {
			_kerning = value;
			updateText();
		}
		return value;
	}

	/** A number representing the amount of space that is uniformly distributed between all characters.
	 * The value specifies the number of pixels that are added to the advance after each character.
	 * The default value is null, which means that 0 pixels of letter spacing is used.
	 * You can use decimal values such as 1.75. @default 0 */
	public var letterSpacing(get, set):Float;

	private inline function get_letterSpacing():Float {
		return _letterSpacing;
	}

	private function set_letterSpacing(value:Float):Float {
		if (_letterSpacing != value) {
			_letterSpacing = value;
			updateText();
		}
		return value;
	}

	/** Indicates whether the font size is scaled down so that the complete text fits
	 *  into the text field. @default false */
	public var autoScale(get, set):Bool;

	private inline function get_autoScale():Bool {
		return _autoScale;
	}

	private function set_autoScale(value:Bool):Bool {
		if (_autoScale != value) {
			_autoScale = value;
			updateText();
		}
		return value;
	}

	/** Specifies the type of auto-sizing the TextField will do.
	 *  Note that any auto-sizing will make auto-scaling useless. Furthermore, it has
	 *  implications on alignment: horizontally auto-sized text will always be left-,
	 *  vertically auto-sized text will always be top-aligned. @default "none" */
	public var autoSize(get, set):TextFieldAutoSize;

	private inline function get_autoSize():TextFieldAutoSize {
		return _autoSize;
	}

	private function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize {
		if (_autoSize != value) {
			_autoSize = value;
			updateText();
		}
		return value;
	}

	public var textHeight(get, never):Float;

	private inline function get_textHeight():Float {
		return _textHeight = Math.abs(bounds.min.z - bounds.max.z);
	}

	public var textWidth(get, never):Float;

	private inline function get_textWidth():Float {
		return _textWidth = Math.abs(bounds.min.x - bounds.max.x);
	}

	public var boundsRect(get, never):Rectangle;

	private function get_boundsRect():Rectangle {
		var minX:Float = bounds.min.x;
		var maxX:Float = bounds.max.x;

		var minY:Float = bounds.min.y;
		var maxY:Float = bounds.max.y;

		var minZ:Float = bounds.min.z;
		var maxZ:Float = bounds.max.z;

		_boundsRect.setTo(minX, minZ, maxX - minX, maxZ - minZ);
		return _boundsRect;
	}

	public var alpha(get, set):Float;

	private inline function get_alpha():Float {
		return textureMaterial.colorTransform.alphaMultiplier;
	}

	private inline function set_alpha(value:Float):Float {
		return textureMaterial.colorTransform.alphaMultiplier = value;
	}
}
