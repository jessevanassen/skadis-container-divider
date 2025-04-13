// The number of rows (the "widest" direction of the container)
rows = 3;
// The number of columns (the "smallest" direction of the container)
columns = 2;
// The height of the model
height = 60;

// Bump arc resolution, so every corner gets 32 segments
$fn = 128;

$outer_width = 75;
$outer_depth = 87.5;
$outer_radius = 18;
$wall_thickness = 0.4 * 3;
$bottom_thickness = 1;


translate([-$outer_width / 2, -$outer_depth / 2])
difference() {
	rounded_cube($outer_width, $outer_depth, height, $outer_radius);
	segments();
}
;

module segments() {
	$segment_width = ($outer_width - ($wall_thickness * (columns + 1))) / columns;
	$segment_depth = ($outer_depth - ($wall_thickness * (rows + 1))) / rows;

	intersection() {
		union() {
			for (y = [0:(rows-1)])
				for (x = [0:(columns - 1)])
					translate([
						$wall_thickness * (1 + x) + $segment_width * x,
						$wall_thickness * (1 + y) + $segment_depth * y,
						$bottom_thickness
					])
					cube([
						$segment_width,
						$segment_depth,
						height - $bottom_thickness
					])
					;
		}

		translate([$wall_thickness, $wall_thickness, $bottom_thickness])
		rounded_cube(
			$outer_width - $wall_thickness * 2,
			$outer_depth - $wall_thickness * 2,
			height - $bottom_thickness,
			$outer_radius - $wall_thickness
		)
		;
	}
}

module rounded_cube(width, depth, height, r) {
	translate([r, r])
	linear_extrude(height)
	offset(r = r)
	square([width - r * 2, depth - r * 2], false)
	;
}
