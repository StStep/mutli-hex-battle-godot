extends Node


onready var nd_grasslayer  = get_node("GrassLayer")
onready var nd_forestlayer  = get_node("ForestLayer")

var hexgrid = preload("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
var infogrid = []

export var hex_scale = Vector2(110, 110)

func _ready():
	hexgrid.hex_scale = hex_scale
	var szrect = nd_grasslayer.get_used_rect ()
	var offset = szrect.position
	infogrid = create_2d_array(szrect.size.x, szrect.size.y, 0)
	print("Making an array with offset %s and size %s" % [offset, szrect.size])
	for c in nd_forestlayer.get_used_cells():
		infogrid[c.x][c.y] = 1
		draw_hex_at(hexgrid.get_hex_center(oddq_to_cube(c)))

func create_2d_array(width:int, height:int, value):
    var a = []
    for x in range(width):
        a.append([])
        a[x].resize(height)
        for y in range(height):
            a[x][y] = value
    return a

func draw_hex_at(pos:Vector2):
		var poly = Polygon2D.new()
		poly.polygon = PoolVector2Array(get_hex_outline(hexgrid.hex_size, pos))
		poly.color = Color(1,0,0,.25)
		$Debug.add_child(poly)

func cube_to_oddq(cube:Vector3):
    var col = cube.x
    var row = cube.z + (cube.x - (cube.x as int & 1)) / 2
    return Vector2(col, row)

func oddq_to_cube(hex:Vector2):
    var x = hex.x
    var z = hex.y - (hex.x - (hex.x as int & 1)) / 2
    var y = -x-z
    return Vector3(x, y, z)

static func get_hex_outline(hex_size:Vector2, center := Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]
