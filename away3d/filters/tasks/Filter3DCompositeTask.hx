package away3d.filters.tasks;

import away3d.cameras.Camera3D;
import away3d.core.managers.Stage3DProxy;
import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;

class Filter3DCompositeTask extends Filter3DTaskBase {
	public var overlayTexture(get, set):TextureBase;
	public var exposure(get, set):Float;

	private var _data:Vector<Float>;
	private var _overlayTexture:TextureBase;
	private var _blendMode:String;

	public function new(blendMode:String, exposure:Float = 1) {
		super();
		_data = Vector.ofArray([exposure, 0.0, 0.0, 0.0]);
		_blendMode = blendMode;
	}

	private function get_overlayTexture():TextureBase {
		return _overlayTexture;
	}

	private function set_overlayTexture(value:TextureBase):TextureBase {
		_overlayTexture = value;
		return value;
	}

	private function get_exposure():Float {
		return _data[0];
	}

	private function set_exposure(value:Float):Float {
		_data[0] = value;
		return value;
	}

	override private function getFragmentCode():String {
		var code:String = "tex ft0, v0, fs0 <2d,linear,clamp>	\n" + "tex ft1, v0, fs1 <2d,linear,clamp>	\n" + "mul ft0, ft0, fc0.x				\n";
		var op = switch (_blendMode) {
			case "multiply": "mul";
			case "add": "add";
			case "subtract": "sub";
			case "normal": "mov"; // for debugging purposes
			default: throw new Error("Unknown blend mode");
		}
		// (neo) Are these tabs necessary?
		if (op != "mov")
			code += op + " oc, ft0, ft1					\n";
		else
			code += "mov oc, ft0						\n";
		return code;
	}

	override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):Void {
		var context:Context3D = stage3DProxy._context3D;
		context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 1);
		context.setTextureAt(1, _overlayTexture);
	}

	override public function deactivate(stage3DProxy:Stage3DProxy):Void {
		stage3DProxy._context3D.setTextureAt(1, null);
	}
}
