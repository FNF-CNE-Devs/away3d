package away3d.animators.nodes;

import away3d.animators.IAnimator;
import away3d.animators.data.AnimationRegisterCache;
import away3d.animators.data.ParticleProperties;
import away3d.animators.data.ParticlePropertiesMode;
import away3d.animators.nodes.ParticleNodeBase;
import away3d.animators.states.ParticlePositionState;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.passes.MaterialPassBase;
import openfl.errors.Error;
import openfl.geom.Vector3D;

/**
 * A particle animation node used to set the starting position of a particle.
 */
@:allow(away3d)
class ParticlePositionNode extends ParticleNodeBase {
	private static inline var POSITION_INDEX:Int = 0;

	private var _position:Vector3D;

	/**
	 * Creates a new <code>ParticlePositionNode</code>
	 *
	 * @param               mode            Defines whether the mode of operation acts on local properties of a particle or global properties of the node.
	 * @param    [optional] position        Defines the default position of the particle when in global mode. Defaults to 0,0,0.
	 */
	public function new(mode:ParticlePropertiesMode, position:Vector3D = null) {
		super("ParticlePosition", mode, 3);

		_stateConstructor = cast ParticlePositionState.new;

		if (position == null)
			position = new Vector3D();
		_position = position;
	}

	override public function getAGALVertexCode(pass:MaterialPassBase, animationRegisterCache:AnimationRegisterCache):String {
		var positionAttribute:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL) ? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
		animationRegisterCache.setRegisterIndex(this, POSITION_INDEX, positionAttribute.index);

		return "add "
			+ animationRegisterCache.positionTarget
			+ ".xyz,"
			+ positionAttribute
			+ ".xyz,"
			+ animationRegisterCache.positionTarget
			+ ".xyz\n";
	}

	public function getAnimationState(animator:IAnimator):ParticlePositionState {
		return cast(animator.getAnimationState(this), ParticlePositionState);
	}

	override public function generatePropertyOfOneParticle(param:ParticleProperties):Void {
		var offset:Vector3D = param.nodes[ParticleNodeEnum.POSITION_VECTOR3D];
		if (offset == null)
			throw new Error("there is no " + ParticleNodeEnum.POSITION_VECTOR3D + " in param!");

		_oneData[0] = offset.x;
		_oneData[1] = offset.y;
		_oneData[2] = offset.z;
	}
}
