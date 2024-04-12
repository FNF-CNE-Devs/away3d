package away3d.primitives;

import away3d.core.base.CompactSubGeometry;
import away3d.core.base.Geometry;
import away3d.core.base.ISubGeometry;
import away3d.errors.AbstractMethodError;
import openfl.Vector;
import openfl.geom.Matrix3D;

/**
 * PrimitiveBase is an abstract base class for mesh primitives, which are prebuilt simple meshes.
 */
class PrimitiveBase extends Geometry {
	private var _geomDirty:Bool = true;
	private var _uvDirty:Bool = true;

	private var _subGeometry:CompactSubGeometry;

	/**
	 * Creates a new PrimitiveBase object.
	 * @param material The material with which to render the object
	 */
	public function new() {
		super();
		_subGeometry = new CompactSubGeometry();
		_subGeometry.autoGenerateDummyUVs = false;
		addSubGeometry(_subGeometry);
	}

	override private function get_subGeometries():Vector<ISubGeometry> {
		if (_geomDirty)
			updateGeometry();
		if (_uvDirty)
			updateUVs();

		return super.get_subGeometries();
	}

	override public function clone():Geometry {
		if (_geomDirty)
			updateGeometry();
		if (_uvDirty)
			updateUVs();

		return super.clone();
	}

	override public function scale(scale:Float):Void {
		if (_geomDirty)
			updateGeometry();

		super.scale(scale);
	}

	override public function scaleUV(scaleU:Float = 1, scaleV:Float = 1):Void {
		if (_uvDirty)
			updateUVs();

		super.scaleUV(scaleU, scaleV);
	}

	override public function applyTransformation(transform:Matrix3D):Void {
		if (_geomDirty)
			updateGeometry();
		super.applyTransformation(transform);
	}

	/**
	 * Builds the primitive's geometry when invalid. This method should not be called directly. The calling should
	 * be triggered by the invalidateGeometry method (and in turn by updateGeometry).
	 */
	private function buildGeometry(target:CompactSubGeometry):Void {
		throw new AbstractMethodError();
	}

	/**
	 * Builds the primitive's uv coordinates when invalid. This method should not be called directly. The calling
	 * should be triggered by the invalidateUVs method (and in turn by updateUVs).
	 */
	private function buildUVs(target:CompactSubGeometry):Void {
		throw new AbstractMethodError();
	}

	/**
	 * Invalidates the primitive's geometry, causing it to be updated when requested.
	 */
	private function invalidateGeometry():Void {
		_geomDirty = true;
	}

	/**
	 * Invalidates the primitive's uv coordinates, causing them to be updated when requested.
	 */
	private function invalidateUVs():Void {
		_uvDirty = true;
	}

	/**
	 * Updates the geometry when invalid.
	 */
	private function updateGeometry():Void {
		buildGeometry(_subGeometry);
		_geomDirty = false;
	}

	/**
	 * Updates the uv coordinates when invalid.
	 */
	private function updateUVs():Void {
		buildUVs(_subGeometry);
		_uvDirty = false;
	}

	override private function validate():Void {
		if (_geomDirty)
			updateGeometry();
		if (_uvDirty)
			updateUVs();
	}
}
