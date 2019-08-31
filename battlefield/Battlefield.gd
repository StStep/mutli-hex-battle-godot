extends Node
class_name Battlefield

# Tilesets use odd-q orientation with 0,0 top-left and +,+ toward bottom-right
onready var _nd_grasslayer  = get_node("GrassLayer")
onready var _nd_forestlayer  = get_node("ForestLayer")

onready var _re_util = preload("res://Utility.gd")
onready var _is_unit = preload("res://units//Unit.tscn")
# offset_coords uses even-q with 0,0 top-left and +,- toward bottom-right, mostly use cube_coords for conv
var hexgrid = preload("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
var infogrid = [] # Follows tileset orientation
var unitgrid = [] # Follows tileset orientation
var width
var height

export var hex_scale = Vector2(110, 110)

func _ready() -> void:
	hexgrid.hex_scale = hex_scale
	var szrect = _nd_grasslayer.get_used_rect ()
	var offset = szrect.position
	width = szrect.size.x
	height = szrect.size.y
	infogrid = _create_2d_array(width, height, 0)
	unitgrid = _create_2d_array(width, height, 0)
	print("Making an array with offset %s and size %s" % [offset, szrect.size])
	for c in _nd_forestlayer.get_used_cells():
		infogrid[c.x][c.y] = 1
		_draw_hex_at(hexgrid.get_hex_center(_re_util.oddq_to_cube(c)))

static func _create_2d_array(w:int, h:int, value) -> Array:
    var a = []
    for x in range(w):
        a.append([])
        a[x].resize(h)
        for y in range(h):
            a[x][y] = value
    return a

func is_free(hexes:Array) -> bool:
	for hex in hexes:
		var pos = _re_util.cube_to_oddq(hex.cube_coords)
		if pos.x < 0 or pos.x >= width or pos.y < 0 or pos.y >= height \
			or infogrid[pos.x][pos.y] != 0 or unitgrid[pos.x][pos.y] != 0:
			return false
	return true

func get_units() -> Array:
	return $Units.get_children()

func create_unit(type: String) -> Unit:
	var u = _is_unit.instance() as Unit
	match type:
		"line":
			u.set_as_line(hexgrid)
		"troop":
			u.set_as_troop(hexgrid)
		"regiment":
			u.set_as_regiment(hexgrid)
	u.fr_are_hexes_empty = funcref(self, "is_free")
	u.connect("placed", self, "_place_unit")
	u.connect("picked", self, "_remove_unit")
	u.state = Unit.UnitState.PLACING
	var drag = u.get_node("Dragable") as Dragable
	drag.dragging = true
	drag.connect("drag_started", self, "_start_dragging")
	drag.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(drag)
	$Units.add_child(u)
	return u

func _draw_hex_at(pos:Vector2) -> void:
		var poly = Polygon2D.new()
		poly.polygon = PoolVector2Array(_re_util.get_hex_outline(hexgrid.hex_size, pos))
		poly.color = Color(1,0,0,.25)
		$Debug.add_child(poly)

func _place_unit(unit: Unit) -> void:
	for hex in unit.get_hexes():
		var pos = _re_util.cube_to_oddq(hex.cube_coords)
		if pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height:
			unitgrid[pos.x][pos.y] = 1;

func _remove_unit(unit: Unit) -> void:
	for hex in unit.get_hexes():
		var pos = _re_util.cube_to_oddq(hex.cube_coords)
		if pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height:
			unitgrid[pos.x][pos.y] = 0;

func _start_dragging(dragable: Dragable) -> void:
	for n in $Units.get_children():
        n.get_node("Dragable").can_drag = false
	dragable.can_drag = true

func _stop_dragging(_dragable: Dragable) -> void:
	for n in $Units.get_children():
        n.get_node("Dragable").can_drag = true
