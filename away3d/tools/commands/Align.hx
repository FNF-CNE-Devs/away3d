package away3d.tools.commands;

import away3d.enums.Axis;
import away3d.entities.Mesh;
import away3d.tools.utils.Bounds;
import openfl.Vector;
import openfl.errors.Error;

/**
 * Class Aligns an arrays of Object3Ds, Vector3D's or Vertexes compaired to each other.<code>Align</code>
 */
class Align {
	private static var _axis:Axis;
	private static var _condition:AlignCondition;

	/**
	 * Aligns a series of meshes to their bounds along a given axis.
	 *
	 * @param     meshes        A Vector of Mesh objects
	 * @param     axis        Represent the axis to align on.
	 * @param     condition    Can be POSITIVE ('+') or NEGATIVE ('-'), Default is POSITIVE ('+')
	 */
	public static function alignMeshes(meshes:Vector<Mesh>, axis:Axis, condition:AlignCondition = POSITIVE):Void {
		var base:Float;
		var bounds:Vector<MeshBound> = getMeshesBounds(meshes);
		var i:Int = 0;
		var prop:String = getProp();
		var mb:MeshBound;
		var m:Mesh;
		var val:Float;

		switch (_condition) {
			case POSITIVE:
				base = getMaxBounds(bounds);

				for (i in 0...meshes.length) {
					m = meshes[i];
					mb = bounds[i];
					val = Reflect.field(m, _axis);
					val -= base - Reflect.field(mb, prop) + Reflect.field(m, _axis);
					Reflect.setField(m, _axis, -val);
					bounds[i] = null;
				}

			case NEGATIVE:
				base = getMinBounds(bounds);

				for (i in 0...meshes.length) {
					m = meshes[i];
					mb = bounds[i];
					val = Reflect.field(m, _axis);
					val -= base + Reflect.field(mb, prop) + Reflect.field(m, _axis);
					Reflect.setField(m, _axis, -val);
					bounds[i] = null;
				}
			default:
		}

		bounds = null;
	}

	/**
	 * Place one or more meshes at y 0 using their min bounds
	 */
	public static function alignToFloor(meshes:Vector<Mesh>):Void {
		if (meshes.length == 0)
			return;

		for (i in 0...meshes.length) {
			Bounds.getMeshBounds(meshes[i]);
			meshes[i].y = Bounds.minY + (Bounds.maxY - Bounds.minY);
		}
	}

	/**
	 * Applies to array elements the alignment according to axis, x, y or z and a condition.
	 * each element must have public x,y and z  properties. In case elements are meshes only their positions is affected. Method doesn't take in account their respective bounds
	 * String condition:
	 * "+" align to highest value on a given axis
	 * "-" align to lowest value on a given axis
	 * "" align to a given axis on 0; This is the default.
	 * "av" align to average of all values on a given axis
	 *
	 * @param     aObjs        Array. An array with elements with x,y and z public properties such as Mesh, Object3D, ObjectContainer3D,Vector3D or Vertex
	 * @param     axis            String. Represent the axis to align on.
	 * @param     condition    [optional]. String. Can be '+", "-", "av" or "", Default is "", aligns to given axis at 0.
	 */
	public static function align(aObjs:Array<Dynamic>, axis:Axis, condition:AlignCondition = NONE):Void {
		var base:Float = switch (_condition) {
			case POSITIVE: getMax(aObjs, _axis);
			case NEGATIVE: getMin(aObjs, _axis);
			case AVERAGE: getAverage(aObjs, _axis);
			default: 0;
		}

		for (i in 0...aObjs.length)
			Reflect.setField(aObjs[i], _axis, base);
	}

	/**
	 * Applies to array elements a distributed alignment according to axis, x,y or z. In case elements are meshes only their positions is affected. Method doesn't take in account their respective bounds
	 * each element must have public x,y and z  properties
	 * @param     aObjs        Array. An array with elements with x,y and z public properties such as Mesh, Object3D, ObjectContainer3D,Vector3D or Vertex
	 * @param     axis            String. Represent the axis to align on.
	 */
	public static function distribute(aObjs:Array<Dynamic>, axis:Axis):Void {
		var max:Float = getMax(aObjs, _axis);
		var min:Float = getMin(aObjs, _axis);
		var unit:Float = (max - min) / aObjs.length;
		aObjs.sort(function(a, b) return Std.int(Reflect.field(a, axis) - Reflect.field(b, axis)));

		var step:Float = 0;
		for (i in 0...aObjs.length) {
			Reflect.setField(aObjs[i], _axis, min + step);
			step += unit;
		}
	}

	private static function getMin(a:Array<Dynamic>, prop:String):Float {
		var min:Float = Math.POSITIVE_INFINITY;
		for (i in 0...a.length)
			min = Math.min(Reflect.field(a[i], prop), min);
		return min;
	}

	private static function getMax(a:Array<Dynamic>, prop:String):Float {
		var max:Float = Math.NEGATIVE_INFINITY;
		for (i in 0...a.length)
			max = Math.max(Reflect.field(a[i], prop), max);
		return max;
	}

	private static function getAverage(a:Array<Dynamic>, prop:String):Float {
		var av:Float = 0;
		var loop:Int = a.length;
		for (i in 0...loop)
			av += Reflect.field(a[i], prop);

		return av / loop;
	}

	private static function getMeshesBounds(meshes:Vector<Mesh>):Vector<MeshBound> {
		var mbs:Vector<MeshBound> = new Vector<MeshBound>();
		var mb:MeshBound;
		for (i in 0...meshes.length) {
			Bounds.getMeshBounds(meshes[i]);

			mb = new MeshBound();
			mb.mesh = meshes[i];
			mb.minX = Bounds.minX;
			mb.minY = Bounds.minY;
			mb.minZ = Bounds.minZ;
			mb.maxX = Bounds.maxX;
			mb.maxY = Bounds.maxY;
			mb.maxZ = Bounds.maxZ;
			mbs.push(mb);
		}

		return mbs;
	}

	private static function getProp():String {
		return switch (_axis) {
			case X: (_condition == POSITIVE) ? "maxX" : "minX";
			case Y: (_condition == POSITIVE) ? "maxY" : "minY";
			case Z: (_condition == POSITIVE) ? "maxZ" : "minZ";
		}
	}

	private static function getMinBounds(bounds:Vector<MeshBound>):Float {
		var min:Float = Math.POSITIVE_INFINITY;
		var mb:MeshBound;

		for (i in 0...bounds.length) {
			mb = bounds[i];
			min = switch (_axis) {
				case X: Math.min(mb.maxX + mb.mesh.x, min);
				case Y: Math.min(mb.maxY + mb.mesh.y, min);
				case Z: Math.min(mb.maxZ + mb.mesh.z, min);
			}
		}

		return min;
	}

	private static function getMaxBounds(bounds:Vector<MeshBound>):Float {
		var max:Float = Math.NEGATIVE_INFINITY;
		var mb:MeshBound;

		for (i in 0...bounds.length) {
			mb = bounds[i];
			max = switch (_axis) {
				case X: Math.max(mb.maxX + mb.mesh.x, max);
				case Y: Math.max(mb.maxY + mb.mesh.y, max);
				case Z: Math.max(mb.maxZ + mb.mesh.z, max);
			}
		}

		return max;
	}
}

class MeshBound {
	public var mesh:Mesh;
	public var minX:Float;
	public var minY:Float;
	public var minZ:Float;
	public var maxX:Float;
	public var maxY:Float;
	public var maxZ:Float;

	public function new() {}
}

#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AlignCondition(Null<Int>) {

	public var NONE = -1;
	public var POSITIVE = 0;
	public var NEGATIVE = 1;
	public var AVERAGE = 2;

	@:from public static function fromString(value:String):AlignCondition {
		return switch (value) {
			case "+": POSITIVE;
			case "-": NEGATIVE;
			case "av": AVERAGE;
			default: NONE;
		}
	}

	@:to public function toString():String {
		return switch (cast this : AlignCondition) {
			case POSITIVE: "+";
			case NEGATIVE: "-";
			case AVERAGE: "av";
			case NONE: "";
		}
	}
}
