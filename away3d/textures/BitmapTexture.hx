package away3d.textures;

import away3d.materials.utils.MipmapGenerator;
import away3d.tools.utils.TextureUtils;
import lime.utils.UInt8Array;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;
import openfl.utils.ByteArray;

class BitmapTexture extends Texture2DBase {
	private static var _mipMaps:Array<Array<BitmapData>> = [];
	private static var _mipMapUses:Array<Array<Int>> = [];

	private var _bitmapData:BitmapData;
	private var _mipMapHolder:BitmapData;
	private var _generateMipmaps:Bool;

	public function new(bitmapData:BitmapData, generateMipmaps:Bool = true) {
		super();

		this.bitmapData = bitmapData;
		_generateMipmaps = _hasMipmaps = generateMipmaps;
	}

	public var bitmapData(get, set):BitmapData;

	private inline function get_bitmapData():BitmapData {
		return _bitmapData;
	}

	private function set_bitmapData(value:BitmapData):BitmapData {
		if (value == _bitmapData)
			return null;

		if (!TextureUtils.isBitmapDataValid(value))
			throw new Error('Invalid bitmapData: Width and height cannot exceed ${TextureUtils.MAX_SIZE}'); // must be power of 2 and

		invalidateContent();
		setSize(value.width, value.height);

		_bitmapData = value;

		if (_generateMipmaps)
			getMipMapHolder();
		return value;
	}

	override private function uploadContent(texture:TextureBase):Void {
		if (_generateMipmaps)
			MipmapGenerator.generateMipMaps(_bitmapData, texture, _mipMapHolder, true);
		else
			cast(texture, Texture).uploadFromBitmapData(_bitmapData, 0);
	}

	private function getMipMapHolder():Void {
		var newW:Int, newH:Int;

		newW = _bitmapData.width;
		newH = _bitmapData.height;

		if (_mipMapHolder != null) {
			if (_mipMapHolder.width == newW && _bitmapData.height == newH)
				return;

			freeMipMapHolder();
		}

		// (neo) TODO: rewrite this
		if (_mipMaps[newW] == null) {
			_mipMaps[newW] = [];
			_mipMapUses[newW] = [];
		}
		if (_mipMaps[newW][newH] == null) {
			_mipMapHolder = _mipMaps[newW][newH] = new BitmapData(newW, newH, true);
			_mipMapUses[newW][newH] = 1;
		} else {
			_mipMapUses[newW][newH] = _mipMapUses[newW][newH] + 1;
			_mipMapHolder = _mipMaps[newW][newH];
		}
	}

	private function freeMipMapHolder():Void {
		var holderWidth:Int = _mipMapHolder.width;
		var holderHeight:Int = _mipMapHolder.height;

		if (--_mipMapUses[holderWidth][holderHeight] == 0) {
			_mipMaps[holderWidth][holderHeight].dispose();
			_mipMaps[holderWidth][holderHeight] = null; // (neo) nullcheck here maybe?
		}
	}

	override public function dispose():Void {
		super.dispose();

		if (_mipMapHolder != null)
			freeMipMapHolder();
	}
}
