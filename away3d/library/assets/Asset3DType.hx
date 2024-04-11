package away3d.library.assets;

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Asset3DType(Null<Int>) {

	public var ENTITY = 0;
	public var SKYBOX = 1;
	public var CAMERA = 2;
	public var SEGMENT_SET = 3;
	public var MESH = 4;
	public var GEOMETRY = 5;
	public var SKELETON = 6;
	public var SKELETON_POSE = 7;
	public var CONTAINER = 8;
	public var TEXTURE = 9;
	public var TEXTURE_PROJECTOR = 10;
	public var MATERIAL = 11;
	public var ANIMATION_SET = 12;
	public var ANIMATION_STATE = 13;
	public var ANIMATION_NODE = 14;
	public var ANIMATOR = 15;
	public var STATE_TRANSITION = 16;
	public var LIGHT = 17;
	public var LIGHT_PICKER = 18;
	public var SHADOW_MAP_METHOD = 19;
	public var EFFECTS_METHOD = 20;

	@:from public static function fromString(value:String):Asset3DType {
		return switch (value) {
			case "entity": ENTITY;
			case "skybox": SKYBOX;
			case "camera": CAMERA;
			case "segmentSet": SEGMENT_SET;
			case "mesh": MESH;
			case "geometry": GEOMETRY;
			case "skeleton": SKELETON;
			case "skeletonPose": SKELETON_POSE;
			case "container": CONTAINER;
			case "texture": TEXTURE;
			case "textureProjector": TEXTURE_PROJECTOR;
			case "material": MATERIAL;
			case "animationSet": ANIMATION_SET;
			case "animationState": ANIMATION_STATE;
			case "animationNode": ANIMATION_NODE;
			case "animator": ANIMATOR;
			case "stateTransition": STATE_TRANSITION;
			case "light": LIGHT;
			case "lightPicker": LIGHT_PICKER;
			case "shadowMapMethod": SHADOW_MAP_METHOD;
			case "effectsMethod": EFFECTS_METHOD;
			default: null;
		}
	}

	@:to public function toString():String {
		return switch (cast this : Asset3DType) {
			case ENTITY: "entity";
			case SKYBOX: "skybox";
			case CAMERA: "camera";
			case SEGMENT_SET: "segmentSet";
			case MESH: "mesh";
			case GEOMETRY: "geometry";
			case SKELETON: "skeleton";
			case SKELETON_POSE: "skeletonPose";
			case CONTAINER: "container";
			case TEXTURE: "texture";
			case TEXTURE_PROJECTOR: "textureProjector";
			case MATERIAL: "material";
			case ANIMATION_SET: "animationSet";
			case ANIMATION_STATE: "animationState";
			case ANIMATION_NODE: "animationNode";
			case ANIMATOR: "animator";
			case STATE_TRANSITION: "stateTransition";
			case LIGHT: "light";
			case LIGHT_PICKER: "lightPicker";
			case SHADOW_MAP_METHOD: "shadowMapMethod";
			case EFFECTS_METHOD: "effectsMethod";
		}
	}
}
