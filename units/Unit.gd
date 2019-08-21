extends Node2D
class_name Unit

var util = preload("res://Utility.gd")

const NORMAL_COLOR = Color(1, 1, 1, .5)
const HL_COLOR = Color( .82, .82, .36, .5)
const ERR_COLOR = Color( .82, 0, 0, .5)

var battlefield
var grid_ref
var legalloc: bool = true

class unit_coords:
	var hexes: Array
	var center: Vector2
	var coords: PoolVector2Array
	var foot_coords: PoolVector2Array
	var pointer_coords: PoolVector2Array

var _isFormA: bool = true
var _a_coords = unit_coords.new()
var _b_coords = unit_coords.new()

func _ready() -> void:
	set_form_a()
	($Dragable as Dragable).connect("drag_started", self, "pickup")
	($Dragable as Dragable).connect("drag_ended", self, "place")
	($Dragable as Dragable).connect("point_to", self, "set_front_to")
	($Dragable as Dragable).connect("drag_to", self, "set_pos_to")

func set_as(wratio: float, hratio: float, ref = null) -> void:
	battlefield = ref
	if ref == null:
		grid_ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		grid_ref.hex_scale = Vector2(100, 100)
	else:
		grid_ref = ref.hexgrid

	var unitw: float = grid_ref.hex_size.y * wratio
	var unith: float = grid_ref.hex_size.y * hratio
	_a_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_b_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_a_coords.center = Vector2(0, unith/2)
	var c_coord = util.get_hex_outline(grid_ref.hex_size)
	_a_coords.pointer_coords = PoolVector2Array([(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2])
	_b_coords.pointer_coords = PoolVector2Array([c_coord[1], c_coord[2], c_coord[3]])

	_a_coords.foot_coords = PoolVector2Array(util.get_multi_hex_outline(grid_ref.hex_size, Vector2(0,0), _a_coords.hexes))
	_b_coords.foot_coords = PoolVector2Array(util.get_multi_hex_outline(grid_ref.hex_size, Vector2(0,0), _b_coords.hexes))

func set_as_line(ref = null) -> void:
	_a_coords.hexes = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	_b_coords.hexes = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	set_as(2, 0.5, ref)

	_b_coords.center = Vector2(0,0)

func set_as_troop(ref = null) -> void:
	_a_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1)]
	_b_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
	set_as(2, 1, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	_b_coords.center = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell)).normalized() * grid_ref.hex_size.y/2

func set_as_regiment(ref = null) -> void:
	_a_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,2), Vector2(1,1), Vector2(0,2)]
	_b_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(-1,2), Vector2(-2,2), Vector2(0,2)]
	set_as(2, 2, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	_b_coords.center = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell))/2

func get_hexes() -> Array:
	var hexes = _a_coords.hexes if _isFormA else _b_coords.hexes
	var ret = []
	for hex in hexes:
		ret.append(grid_ref.get_hex_at(global_position + util.axial_to_canvas(grid_ref.hex_size, hex).rotated(rotation)))
	return ret

func pickup(dragable: Dragable) -> void:
	if legalloc:
		$Footprint.color = HL_COLOR
		battlefield.remove_unit(get_hexes())

func place(dragable: Dragable) -> void:
	if legalloc:
		$Footprint.color = NORMAL_COLOR
		battlefield.place_unit(get_hexes())

func set_pos_to(glob_position: Vector2) -> void:
	var hex = grid_ref.get_hex_at(glob_position)
	set_global_position(grid_ref.get_hex_center(hex))

	if battlefield != null and !battlefield.is_free(get_hexes()):
		$Footprint.color = ERR_COLOR
		legalloc = false
	else:
		$Footprint.color = HL_COLOR
		legalloc = true

func set_front_to(x: float) -> void:
	var deg: float = ((x + PI) * 180 / PI)
	if deg < 15 or deg > 345:
		rotation_degrees = 0
		set_form_a()
	elif 15 <= deg and deg < 45:
		rotation_degrees = 0
		set_form_b()
	elif 45 <= deg and deg < 75:
		rotation_degrees = 60
		set_form_a()
	elif 75 <= deg and deg < 105:
		rotation_degrees = 60
		set_form_b()
	elif 105 <= deg and deg < 135:
		rotation_degrees = 120
		set_form_a()
	elif 135 <= deg and deg < 165:
		rotation_degrees = 120
		set_form_b()
	elif 165 <= deg and deg < 195:
		rotation_degrees = 180
		set_form_a()
	elif 195 <= deg and deg < 225:
		rotation_degrees = 180
		set_form_b()
	elif 225 <= deg and deg < 255:
		rotation_degrees = 240
		set_form_a()
	elif 255 <= deg and deg < 285:
		rotation_degrees = 240
		set_form_b()
	elif 285 <= deg and deg < 315:
		rotation_degrees = 300
		set_form_a()
	elif 315 <= deg and deg < 345:
		rotation_degrees = 300
		set_form_b()

	if battlefield != null and !battlefield.is_free(get_hexes()):
		$Footprint.color = ERR_COLOR
		legalloc = false
	else:
		legalloc = true
		$Footprint.color = HL_COLOR

func set_form_a() -> void:
	$Footprint.polygon = _a_coords.foot_coords
	$Dragable.polygon = _a_coords.foot_coords
	$Unit.polygon = _a_coords.coords
	$Unit.position = _a_coords.center
	$Unit.rotation_degrees = 0
	$Pointer.polygon = _a_coords.pointer_coords
	_isFormA = true

func set_form_b() -> void:
	$Footprint.polygon = _b_coords.foot_coords
	$Dragable.polygon = _b_coords.foot_coords
	$Unit.polygon = _b_coords.coords
	$Unit.position = _b_coords.center
	$Unit.rotation_degrees = 30
	$Pointer.polygon = _b_coords.pointer_coords
	_isFormA = false
