# Hex Utilities
# Line Segement Indexing: (+x,+y) is down-right
#   / NW - NE \     / 1 - 2 \
#  W           E   0         3
#   \ SW - SE /     \ 5 - 4 /
#
# Axial Hex Offset Coords: (+q,+r) is down-right
#         (+0,-1)
#    (-1,+0)    (+1,-1)
#    (-1,+1)    (+1,+0)
#         (+0,+1)

static func cube_to_oddq(cube_coor:Vector3):
    var col = cube_coor.x
    var row = cube_coor.z + (cube_coor.x - (cube_coor.x as int & 1)) / 2.0
    return Vector2(col, row)

static func oddq_to_cube(oddq_coor:Vector2):
    var x = oddq_coor.x
    var z = oddq_coor.y - (oddq_coor.x - (oddq_coor.x as int & 1)) / 2.0
    var y = -x-z
    return Vector3(x, y, z)

static func axial_to_canvas(hex_size:Vector2, hex:Vector2):
	var size = hex_size.x/2.0
	var x = size * (3.0/2.0 * hex.x)
	var y = size * (sqrt(3.0)/2.0 * hex.x  +  sqrt(3.0) * hex.y)
	return Vector2(x, y)

static func get_hex_outline(hex_size:Vector2, center := Vector2(0,0)):
	return [Vector2(-hex_size.x/2.0 + center.x, center.y), Vector2(-hex_size.x/4.0 + center.x, -hex_size.y/2.0 + center.y),
			Vector2(hex_size.x/4.0 + center.x, -hex_size.y/2.0 + center.y), Vector2(hex_size.x/2.0 + center.x, center.y),
			Vector2(hex_size.x/4.0 + center.x, hex_size.y/2.0 + center.y), Vector2(-hex_size.x/4.0 + center.x, hex_size.y/2.0 + center.y)]

# Return an array of Vector2 representing the outline of a group of contiguous and solid hexes in canvas coordinates
# Takes hexes in form of axial coordinates relative to center hex, which is (0,0)
static func get_multi_hex_outline(hex_size:Vector2, center:Vector2, axial_coords:Array):
	# Get neighbors for each hex, axial coordinate
	var hexes = get_neighbors(axial_coords)

	# Pick top left hex to start, most negative, with priority on r/y
	var start_hex = null
	for coor in axial_coords:
		if start_hex == null or (coor.x <= start_hex.x and coor.y <= start_hex.y) or coor.y < start_hex.y:
			start_hex = coor

	# Get current and previous hex, since at top, safe to ignore what's above
	# Previous hex is first neighbor CCW from top
	var cur_hex = start_hex
	var prev_hex_dir = next_ccw_axial_coor(Vector2(0,-1))
	while (not prev_hex_dir in hexes[cur_hex]) && prev_hex_dir != Vector2(0,-1) :
		prev_hex_dir = next_ccw_axial_coor(prev_hex_dir)

	# Define points based on neighbors
	var points = []
	while cur_hex != null:

		# Get direction to move to next clockwise hex
		var next_hex_dir = next_cw_axial_coor(prev_hex_dir)
		while (not next_hex_dir in hexes[cur_hex]) && next_hex_dir != prev_hex_dir:
			next_hex_dir = next_cw_axial_coor(next_hex_dir)

		# Fill in edges from prev to next direction, skipping point just after prev edge
		var cur_points = get_hex_outline(hex_size, center + axial_to_canvas(hex_size, cur_hex))
		var point_dir = next_cw_axial_coor(prev_hex_dir)
		while point_dir != next_hex_dir:
			points.append(cur_points[edges_by_axial_coor[point_dir].y])
			point_dir = next_cw_axial_coor(point_dir)

		# Use next_hex_dir to move to the next hex, breaking out if reaching start
		if start_hex == cur_hex + next_hex_dir:
			cur_hex = null
		else:
			cur_hex = cur_hex + next_hex_dir
		prev_hex_dir = -next_hex_dir
	return points


# Return a dictionary where the axial_coords entries are the key to the value
# of an array of offsets to it's neighbors. Everything is in axial coordinates
static func get_neighbors(axial_coords:Array):
	var hexes = {}
	for cur_offset in axial_coords:
		# Get offsets to neighbor hexes, within (+-1,0) or (0,+-1) or (-1,+1) or (+1,-1)
		var neighbors = []
		for coor in axial_coords:
			var diff = coor - cur_offset
			if diff == Vector2(-1,+1) || diff == Vector2(+1,-1) || diff.abs() == Vector2(1,0) || diff.abs() == Vector2(0,1):
				neighbors.append(diff)
		hexes[cur_offset] = neighbors
	return hexes

const axial_coor = [Vector2(+0,-1),  Vector2(+1,-1), Vector2(+1,+0), Vector2(+0,+1), Vector2(-1,+1), Vector2(-1,+0), Vector2(+0,-1)]
const edges_by_axial_coor = {
	Vector2(+0,-1): Vector2(1,2),
	Vector2(+1,-1): Vector2(2,3),
	Vector2(+1,+0): Vector2(3,4),
	Vector2(+0,+1): Vector2(4,5),
	Vector2(-1,+1): Vector2(5,0),
	Vector2(-1,+0): Vector2(0,1),
	}

static func next_cw_axial_coor(coord:Vector2):
	var ind = axial_coor.find(coord)
	if ind < 0:
		return null
	else:
		return axial_coor[ind + 1]

static func next_ccw_axial_coor(coord:Vector2):
	var ind = axial_coor.find_last(coord)
	if ind < 0:
		return null
	else:
		return axial_coor[ind - 1]
