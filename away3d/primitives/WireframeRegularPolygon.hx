package away3d.primitives;

import away3d.enums.Plane;
import openfl.geom.Vector3D;

/**
 * A WireframeRegularPolygon primitive mesh.
 */
class WireframeRegularPolygon extends WireframePrimitiveBase {
	public var orientation(get, set):Plane;
	public var radius(get, set):Float;
	public var sides(get, set):Int;

	private var _radius:Float;
	private var _sides:Int;
	private var _orientation:Plane;

	/**
	 * Creates a new WireframeRegularPolygon object.
	 * @param radius The radius of the polygon.
	 * @param sides The number of sides on the polygon.
	 * @param color The colour of the wireframe lines
	 * @param thickness The thickness of the wireframe lines
	 * @param orientation The orientaion in which the plane lies.
	 */
	public function new(radius:Float, sides:Int, color:Int = 0xFFFFFF, thickness:Float = 1, orientation:Plane = ZY) {
		super(color, thickness);

		_radius = radius;
		_sides = sides;
		_orientation = orientation;
	}

	/**
	 * The orientaion in which the polygon lies.
	 */
	private inline function get_orientation():Plane {
		return _orientation;
	}

	private function set_orientation(value:Plane):Plane {
		_orientation = value;
		invalidateGeometry();
		return value;
	}

	/**
	 * The radius of the regular polygon.
	 */
	private inline function get_radius():Float {
		return _radius;
	}

	private function set_radius(value:Float):Float {
		_radius = value;
		invalidateGeometry();
		return value;
	}

	/**
	 * The number of sides to the regular polygon.
	 */
	private inline function get_sides():Int {
		return _sides;
	}

	private function set_sides(value:Int):Int {
		_sides = value;
		removeAllSegments();
		invalidateGeometry();
		return value;
	}

	/**
	 * @inheritDoc
	 */
	override private function buildGeometry():Void {
		var v0:Vector3D = new Vector3D();
		var v1:Vector3D = new Vector3D();
		var index:Int = 0;
		var s:Int = 0;

		switch (_orientation) {
			case XY:
				v0.z = 0;
				v1.z = 0;

				for (s in 0..._sides) {
					v0.x = _radius * Math.cos(2 * Math.PI * s / _sides);
					v0.y = _radius * Math.sin(2 * Math.PI * s / _sides);
					v1.x = _radius * Math.cos(2 * Math.PI * (s + 1) / _sides);
					v1.y = _radius * Math.sin(2 * Math.PI * (s + 1) / _sides);
					updateOrAddSegment(index++, v0, v1);
				}
			case XZ:
				v0.y = 0;
				v1.y = 0;

				for (s in 0..._sides) {
					v0.x = _radius * Math.cos(2 * Math.PI * s / _sides);
					v0.z = _radius * Math.sin(2 * Math.PI * s / _sides);
					v1.x = _radius * Math.cos(2 * Math.PI * (s + 1) / _sides);
					v1.z = _radius * Math.sin(2 * Math.PI * (s + 1) / _sides);
					updateOrAddSegment(index++, v0, v1);
				}
			case ZY:
				v0.x = 0;
				v1.x = 0;

				for (s in 0..._sides) {
					v0.z = _radius * Math.cos(2 * Math.PI * s / _sides);
					v0.y = _radius * Math.sin(2 * Math.PI * s / _sides);
					v1.z = _radius * Math.cos(2 * Math.PI * (s + 1) / _sides);
					v1.y = _radius * Math.sin(2 * Math.PI * (s + 1) / _sides);
					updateOrAddSegment(index++, v0, v1);
				}
		}
	}
}
