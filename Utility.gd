# Hex Utilities

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
