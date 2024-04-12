package away3d.animators.nodes;

import away3d.animators.IAnimator;
import away3d.animators.data.AnimationRegisterCache;
import away3d.animators.data.ParticleProperties;
import away3d.animators.data.ParticlePropertiesMode;
import away3d.animators.nodes.ParticleNodeBase;
import away3d.animators.states.ParticleVelocityState;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.passes.MaterialPassBase;
import openfl.errors.Error;
import openfl.geom.Vector3D;

/**
 * A particle animation node used to set the starting velocity of a particle.
 */
@:allow(away3d)
class ParticleVelocityNode extends ParticleNodeBase {
	private static inline var VELOCITY_INDEX:Int = 0;

	private var _velocity:Vector3D;

	/**
	 * Creates a new <code>ParticleVelocityNode</code>
	 *
	 * @param               mode            Defines whether the mode of operation acts on local properties of a particle or global properties of the node.
	 * @param    [optional] velocity        Defines the default velocity vector of the node, used when in global mode.
	 */
	public function new(mode:ParticlePropertiesMode, velocity:Vector3D = null) {
		super("ParticleVelocity", mode, 3);

		_stateConstructor = cast ParticleVelocityState.new;

		if (velocity == null)
			velocity = new Vector3D();
		_velocity = velocity;
	}

	/**
	 * @inheritDoc
	 */
	override public function getAGALVertexCode(pass:MaterialPassBase, animationRegisterCache:AnimationRegisterCache):String {
		var velocityValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL) ? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
		animationRegisterCache.setRegisterIndex(this, VELOCITY_INDEX, velocityValue.index);

		var distance:ShaderRegisterElement = animationRegisterCache.getFreeVertexVectorTemp();
		var code:String = "";
		code += "mul " + distance + "," + animationRegisterCache.vertexTime + "," + velocityValue + "\n";
		code += "add "
			+ animationRegisterCache.positionTarget
			+ ".xyz,"
			+ distance
			+ ","
			+ animationRegisterCache.positionTarget
			+ ".xyz\n";

		if (animationRegisterCache.needVelocity)
			code += "add "
				+ animationRegisterCache.velocityTarget
				+ ".xyz,"
				+ velocityValue
				+ ".xyz,"
				+ animationRegisterCache.velocityTarget
				+ ".xyz\n";

		return code;
	}

	/**
	 * @inheritDoc
	 */
	public function getAnimationState(animator:IAnimator):ParticleVelocityState {
		return cast(animator.getAnimationState(this), ParticleVelocityState);
	}

	/**
	 * @inheritDoc
	 */
	override public function generatePropertyOfOneParticle(param:ParticleProperties):Void {
		var _tempVelocity:Vector3D = param.nodes[ParticleNodeEnum.VELOCITY_VECTOR3D];
		if (_tempVelocity == null)
			throw new Error("there is no " + ParticleNodeEnum.VELOCITY_VECTOR3D + " in param!");

		_oneData[0] = _tempVelocity.x;
		_oneData[1] = _tempVelocity.y;
		_oneData[2] = _tempVelocity.z;
	}
}
