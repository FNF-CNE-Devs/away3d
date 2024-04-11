package away3d.debug;

import away3d.entities.SegmentSet;
import away3d.enums.Plane;
import away3d.primitives.LineSegment;
import openfl.geom.Vector3D;

/**
 * Class WireframeAxesGrid generates a grid of lines on a given plane<code>WireframeAxesGrid</code>
 * @param    subDivision            [optional] uint . Default is 10;
 * @param    gridSize            [optional] uint . Default is 100;
 * @param    thickness            [optional] Number . Default is 1;
 * @param    colorXY                [optional] uint. Default is 0x0000FF.
 * @param    colorZY                [optional] uint. Default is 0xFF0000.
 * @param    colorXZ                [optional] uint. Default is 0x00FF00.
 */
class WireframeAxesGrid extends SegmentSet {
	public function new(subDivision:Int = 10, gridSize:Int = 100, thickness:Float = 1, colorXY:Int = 0x0000FF, colorZY:Int = 0xFF0000, colorXZ:Int = 0x00FF00) {
		super();

		if (subDivision == 0)
			subDivision = 1;
		if (thickness <= 0)
			thickness = 1;
		if (gridSize == 0)
			gridSize = 1;

		build(subDivision, gridSize, colorXY, thickness, XY);
		build(subDivision, gridSize, colorZY, thickness, ZY);
		build(subDivision, gridSize, colorXZ, thickness, XZ);
	}

	private function build(subDivision:Int, gridSize:Int, color:Int, thickness:Float, plane:Plane):Void {
		var bound:Float = gridSize * .5;
		var step:Float = gridSize / subDivision;
		var v0:Vector3D = new Vector3D(0, 0, 0);
		var v1:Vector3D = new Vector3D(0, 0, 0);
		var inc:Float = -bound;

		while (inc <= bound) {
			switch (plane) {
				case ZY:
					v0.setTo(0, inc, bound);
					v1.setTo(0, inc, -bound);
					addSegment(new LineSegment(v0, v1, color, color, thickness));

					v0.setTo(0, bound, inc);
					v0.setTo(0, -bound, inc);
					addSegment(new LineSegment(v0, v1, color, color, thickness));

				case XY:
					v0.setTo(bound, inc, 0);
					v1.setTo(-bound, inc, 0);
					addSegment(new LineSegment(v0, v1, color, color, thickness));

					v0.setTo(inc, bound, 0);
					v1.setTo(inc, -bound, 0);
					addSegment(new LineSegment(v0, v1, color, color, thickness));

				case XZ:
					v0.setTo(bound, 0, inc);
					v1.setTo(-bound, 0, inc);
					addSegment(new LineSegment(v0, v1, color, color, thickness));

					v0.setTo(inc, 0, bound);
					v1.setTo(inc, 0, -bound);
					addSegment(new LineSegment(v0, v1, color, color, thickness));
			}

			inc += step;
		}
	}
}
