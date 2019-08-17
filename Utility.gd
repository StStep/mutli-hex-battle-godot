# Hex Utilities
#  Line Segement Indexing:        Axial Hex Offset Coords: (q,r)
#   / NW - NE \     0 NW 1 NE 2           (+0,-1)
#  W           E   W           E     (-1,+0)    (+1,-1)
#   \ SW - SE /     5 SW 4 SE 3      (-1,+1)    (+1,+0)
#                                         (+0,+1)

static func cube_to_oddq(cube_coor:Vector3):
    var col = cube_coor.x
    var row = cube_coor.z + (cube_coor.x - (cube_coor.x as int & 1)) / 2
    return Vector2(col, row)

static func oddq_to_cube(oddq_coor:Vector2):
    var x = oddq_coor.x
    var z = oddq_coor.y - (oddq_coor.x - (oddq_coor.x as int & 1)) / 2
    var y = -x-z
    return Vector3(x, y, z)

static func get_hex_outline(hex_size:Vector2, center := Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]

# Return an array of Vector2 representing the outline of a group of contiguous hexes in canvas coordinates
# Takes hexes in form of axial coordinates relative to center hex, which is (0,0)
static func get_multi_hex_outline(hex_size:Vector2, center:Vector2, axial_coords:Array):
	# Get neighbors for each hex, axial coordinate
	var hexes = get_neighbors(axial_coords)

	# Pick top left hex
	pass

	# Define points based on neighbors, one pass if edges <=2 else 2 or 3 passes
	pass

	# Move to next clockwise hex
	pass

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
