package away3d.animators.nodes;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ParticleNodeEnum(Int) {

	public var UNKNOWN = -1;

	/**
	 * Reference for acceleration node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the direction of acceleration on the particle.
	 */
	public var ACCELERATION_VECTOR3D = 0;

	/**
	 * Reference for bezier curve node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the control point position (0, 1, 2) of the curve.
	 */
	public var BEZIER_CONTROL_VECTOR3D = 1;

	/**
	 * Reference for bezier curve node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the end point position (0, 1, 2) of the curve.
	 */
	public var BEZIER_END_VECTOR3D = 2;

	/**
	 * Reference for color node properties on a single particle (when in local property mode).
	 * Expects a <code>ColorTransform</code> object representing the start color transform applied to the particle.
	 */
	public var COLOR_START_COLORTRANSFORM = 3;

	/**
	 * Reference for color node properties on a single particle (when in local property mode).
	 * Expects a <code>ColorTransform</code> object representing the end color transform applied to the particle.
	 */
	public var COLOR_END_COLORTRANSFORM = 4;

	/**
	 * Reference for color node properties on a single particle (when in local property mode).
	 * Expects a <code>ColorTransform</code> object representing the color transform applied to the particle.
	 */
	public var COLOR_INITIAL_COLORTRANSFORM = 5;

	/**
	 * Reference for orbit node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the radius (x), cycle speed (y) and cycle phase (z) of the motion on the particle.
	 */
	public var ORBIT_VECTOR3D = 6;

	/**
	 * Reference for ocsillator node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the axis (x,y,z) and cycle speed (w) of the motion on the particle.
	 */
	public var OSCILLATOR_VECTOR3D = 7;

	/**
	 * Reference for position node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing position of the particle.
	 */
	public var POSITION_VECTOR3D = 8;

	/**
	 * Reference for the position the particle will rotate to face for a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the position that the particle must face.
	 */
	public var ROTATE_TO_POSITION_VECTOR3D = 9;

	/**
	 * Reference for rotational velocity node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the rotational velocity around an axis of the particle.
	 */
	public var ROTATIONALVELOCITY_VECTOR3D = 10;

	/**
	 * Reference for scale node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> representing the min scale (x), max scale(y), optional cycle speed (z) and phase offset (w) applied to the particle.
	 */
	public var SCALE_VECTOR3D = 11;

	/**
	 * Reference for spritesheet node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> representing the cycleDuration (x), optional phaseTime (y).
	 */
	public var UV_VECTOR3D = 12;

	/**
	 * Reference for velocity node properties on a single particle (when in local property mode).
	 * Expects a <code>Vector3D</code> object representing the direction of movement on the particle.
	 */
	public var VELOCITY_VECTOR3D = 13;

	@:from public static function fromString(value:String):ParticleNodeEnum {
		return switch (value) {
			case "AccelerationVector3D": ACCELERATION_VECTOR3D;
			case "BezierControlVector3D": BEZIER_CONTROL_VECTOR3D;
			case "BezierEndVector3D": BEZIER_END_VECTOR3D;
			case "ColorStartColorTransform": COLOR_START_COLORTRANSFORM;
			case "ColorEndColorTransform": COLOR_END_COLORTRANSFORM;
			case "ColorInitialColorTransform": COLOR_INITIAL_COLORTRANSFORM;
			case "OrbitVector3D": ORBIT_VECTOR3D;
			case "OscillatorVector3D": OSCILLATOR_VECTOR3D;
			case "PositionVector3D": POSITION_VECTOR3D;
			case "RotateToPositionVector3D": ROTATE_TO_POSITION_VECTOR3D;
			case "RotationalVelocityVector3D": ROTATIONALVELOCITY_VECTOR3D;
			case "ScaleVector3D": SCALE_VECTOR3D;
			case "UVVector3D": UV_VECTOR3D;
			case "VelocityVector3D": VELOCITY_VECTOR3D;
			default: UNKNOWN;
		}
	}

	@:to public function toString():String {
		return switch (cast this : ParticleNodeEnum) {
			case ACCELERATION_VECTOR3D: "AccelerationVector3D";
			case BEZIER_CONTROL_VECTOR3D: "BezierControlVector3D";
			case BEZIER_END_VECTOR3D: "BezierEndVector3D";
			case COLOR_START_COLORTRANSFORM: "ColorStartColorTransform";
			case COLOR_END_COLORTRANSFORM: "ColorEndColorTransform";
			case COLOR_INITIAL_COLORTRANSFORM: "ColorInitialColorTransform";
			case ORBIT_VECTOR3D: "OrbitVector3D";
			case OSCILLATOR_VECTOR3D: "OscillatorVector3D";
			case POSITION_VECTOR3D: "PositionVector3D";
			case ROTATE_TO_POSITION_VECTOR3D: "RotateToPositionVector3D";
			case ROTATIONALVELOCITY_VECTOR3D: "RotationalVelocityVector3D";
			case SCALE_VECTOR3D: "ScaleVector3D";
			case UV_VECTOR3D: "UVVector3D";
			case VELOCITY_VECTOR3D: "VelocityVector3D";
			case UNKNOWN: "Unknown";
		}
	}
}
