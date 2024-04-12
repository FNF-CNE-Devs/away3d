package away3d.materials.methods;

import away3d.errors.AbstractMethodError;
import away3d.library.assets.Asset3DType;
import away3d.library.assets.IAsset;
import away3d.materials.compilation.ShaderRegisterCache;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.methods.MethodVO;
import away3d.materials.methods.ShadingMethodBase;

/**
 * EffectMethodBase forms an abstract base class for shader methods that are not dependent on light sources,
 * and are in essence post-process effects on the materials.
 */
@:allow(away3d)
class EffectMethodBase extends ShadingMethodBase implements IAsset {
	public var assetType(get, never):Asset3DType;

	public function new() {
		super();
	}

	private function get_assetType():Asset3DType {
		return Asset3DType.EFFECTS_METHOD;
	}

	/**
	 * Get the fragment shader code that should be added after all per-light code. Usually composits everything to the target register.
	 * @param vo The MethodVO object containing the method data for the currently compiled material pass.
	 * @param regCache The register cache used during the compilation.
	 * @param targetReg The register that will be containing the method's output.
	 */
	private function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String {
		throw new AbstractMethodError();
		return "";
	}
}
