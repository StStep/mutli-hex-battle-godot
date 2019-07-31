extends Node


onready var nd_grasslayer  = get_node("GrassLayer")
onready var nd_forestlayer  = get_node("ForestLayer")

var util = preload("res://Utility.gd")
var hexgrid = preload("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
var infogrid = []

export var hex_scale = Vector2(110, 110)

func _ready():
	hexgrid.hex_scale = hex_scale
	var szrect = nd_grasslayer.get_used_rect ()
	var offset = szrect.position
	infogrid = _create_2d_array(szrect.size.x, szrect.size.y, 0)
	print("Making an array with offset %s and size %s" % [offset, szrect.size])
	for c in nd_forestlayer.get_used_cells():
		infogrid[c.x][c.y] = 1
		_draw_hex_at(hexgrid.get_hex_center(util.oddq_to_cube(c)))

func _create_2d_array(width:int, height:int, value):
    var a = []
    for x in range(width):
        a.append([])
        a[x].resize(height)
        for y in range(height):
            a[x][y] = value
    return a

func _draw_hex_at(pos:Vector2):
		var poly = Polygon2D.new()
		poly.polygon = PoolVector2Array(util.get_hex_outline(hexgrid.hex_size, pos))
		poly.color = Color(1,0,0,.25)
		$Debug.add_child(poly)
