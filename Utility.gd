# Hex Utilities

static func cube_to_oddq(cube:Vector3):
    var col = cube.x
    var row = cube.z + (cube.x - (cube.x as int & 1)) / 2
    return Vector2(col, row)

static func oddq_to_cube(hex:Vector2):
    var x = hex.x
    var z = hex.y - (hex.x - (hex.x as int & 1)) / 2
    var y = -x-z
    return Vector3(x, y, z)

static func get_hex_outline(hex_size:Vector2, center := Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]
