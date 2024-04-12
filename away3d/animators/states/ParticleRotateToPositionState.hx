package away3d.animators.states;

import away3d.animators.ParticleAnimator;
import away3d.animators.data.AnimationRegisterCache;
import away3d.animators.data.AnimationSubGeometry;
import away3d.animators.data.ParticlePropertiesMode;
import away3d.animators.nodes.ParticleRotateToPositionNode;
import away3d.animators.states.ParticleStateBase;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;

class ParticleRotateToPositionState extends ParticleStateBase {
	public var position(get, set):Vector3D;

	private var _particleRotateToPositionNode:ParticleRotateToPositionNode;
	private var _position:Vector3D;
	private var _matrix:Matrix3D = new Matrix3D();
	private var _offset:Vector3D;

	/**
	 * Defines the position of the point the particle will rotate to face when in global mode. Defaults to 0,0,0.
	 */
	private inline function get_position():Vector3D {
		return _position;
	}

	private inline function set_position(value:Vector3D):Vector3D {
		return _position = value;
	}

	public function new(animator:ParticleAnimator, particleRotateToPositionNode:ParticleRotateToPositionNode) {
		super(animator, particleRotateToPositionNode);

		_particleRotateToPositionNode = particleRotateToPositionNode;
		_position = _particleRotateToPositionNode._position;
	}

	override public function setRenderState(stage3DProxy:Stage3DProxy, renderable:IRenderable, animationSubGeometry:AnimationSubGeometry,
			animationRegisterCache:AnimationRegisterCache, camera:Camera3D):Void {
		var index:Int = animationRegisterCache.getRegisterIndex(_animationNode, ParticleRotateToPositionNode.POSITION_INDEX);

		if (animationRegisterCache.hasBillboard) {
			_matrix.copyFrom(renderable.getRenderSceneTransform(camera));
			_matrix.append(camera.inverseSceneTransform);
			animationRegisterCache.setVertexConstFromMatrix(animationRegisterCache.getRegisterIndex(_animationNode,
				ParticleRotateToPositionNode.MATRIX_INDEX), _matrix);
		}

		if (_particleRotateToPositionNode.mode == ParticlePropertiesMode.GLOBAL) {
			_offset = renderable.inverseSceneTransform.transformVector(_position);
			animationRegisterCache.setVertexConst(index, _offset.x, _offset.y, _offset.z);
		} else
			animationSubGeometry.activateVertexBuffer(index, _particleRotateToPositionNode.dataOffset, stage3DProxy, Context3DVertexBufferFormat.FLOAT_3);
	}
}
