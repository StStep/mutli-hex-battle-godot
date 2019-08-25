extends Node2D
class_name Unit

enum UnitState {NONE, PLACING, MOVING}

signal placed(unit)
signal picked(unit)

var state = UnitState.NONE setget _set_state, _get_state
var legalloc: bool = true setget ,_get_legalloc
var fr_are_hexes_empty: FuncRef

class unit_coords:
	var hexes: Array
	var center: Vector2
	var coords: PoolVector2Array
	var foot_coords: PoolVector2Array
	var pointer_coords: PoolVector2Array

var _re_util = preload("res://Utility.gd")

const _NORMAL_COLOR = Color(1, 1, 1, .5)
const _HL_COLOR = Color( .82, .82, .36, .5)
const _ERR_COLOR = Color( .82, 0, 0, .5)

var _grid_ref
var _isFormA: bool = true
var _a_coords = unit_coords.new()
var _b_coords = unit_coords.new()

func _ready() -> void:
	_set_form_a()
	($Dragable as Dragable).connect("drag_started", self, "_pickup")
	($Dragable as Dragable).connect("drag_ended", self, "_place")
	($Dragable as Dragable).connect("point_to", self, "set_front_to")
	($Dragable as Dragable).connect("drag_to", self, "set_pos_to")

func _set_state(value):
	state = value

func _get_state():
	return state

func _get_legalloc() -> bool:
	return legalloc

func _set_as(wratio: float, hratio: float, grid = null) -> void:
	if grid == null:
		_grid_ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		_grid_ref.hex_scale = Vector2(100, 100)
	else:
		_grid_ref = grid

	var unitw: float = _grid_ref.hex_size.y * wratio
	var unith: float = _grid_ref.hex_size.y * hratio
	_a_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_b_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_a_coords.center = Vector2(0, unith/2)
	var c_coord = _re_util.get_hex_outline(_grid_ref.hex_size)
	_a_coords.pointer_coords = PoolVector2Array([(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2])
	_b_coords.pointer_coords = PoolVector2Array([c_coord[1], c_coord[2], c_coord[3]])

	_a_coords.foot_coords = PoolVector2Array(_re_util.get_multi_hex_outline(_grid_ref.hex_size, Vector2(0,0), _a_coords.hexes))
	_b_coords.foot_coords = PoolVector2Array(_re_util.get_multi_hex_outline(_grid_ref.hex_size, Vector2(0,0), _b_coords.hexes))

	_set_state(UnitState.PLACING)

func set_as_line(grid = null) -> void:
	_a_coords.hexes = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	_b_coords.hexes = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	_set_as(2, 0.5, grid)

	_b_coords.center = Vector2(0,0)

func set_as_troop(grid = null) -> void:
	_a_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1)]
	_b_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
	_set_as(2, 1, grid)

	var centercell = _grid_ref.get_hex_at(Vector2(0,0))
	_b_coords.center = (_grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - _grid_ref.get_hex_center(centercell)).normalized() * _grid_ref.hex_size.y/2

func set_as_regiment(grid = null) -> void:
	_a_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,2), Vector2(1,1), Vector2(0,2)]
	_b_coords.hexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(-1,2), Vector2(-2,2), Vector2(0,2)]
	_set_as(2, 2, grid)

	var centercell = _grid_ref.get_hex_at(Vector2(0,0))
	_b_coords.center = (_grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - _grid_ref.get_hex_center(centercell))/2

func get_hexes() -> Array:
	var hexes = _a_coords.hexes if _isFormA else _b_coords.hexes
	var ret = []
	for hex in hexes:
		ret.append(_grid_ref.get_hex_at(global_position + _re_util.axial_to_canvas(_grid_ref.hex_size, hex).rotated(rotation)))
	return ret

func set_pos_to(glob_position: Vector2) -> void:
	var hex = _grid_ref.get_hex_at(glob_position)
	set_global_position(_grid_ref.get_hex_center(hex))

	if fr_are_hexes_empty != null and !fr_are_hexes_empty.call_func(get_hexes()):
		$Footprint.color = _ERR_COLOR
		legalloc = false
	else:
		$Footprint.color = _HL_COLOR
		legalloc = true

func set_front_to(x: float) -> void:
	var deg: float = ((x + PI) * 180 / PI)
	if deg < 15 or deg > 345:
		rotation_degrees = 0
		_set_form_a()
	elif 15 <= deg and deg < 45:
		rotation_degrees = 0
		_set_form_b()
	elif 45 <= deg and deg < 75:
		rotation_degrees = 60
		_set_form_a()
	elif 75 <= deg and deg < 105:
		rotation_degrees = 60
		_set_form_b()
	elif 105 <= deg and deg < 135:
		rotation_degrees = 120
		_set_form_a()
	elif 135 <= deg and deg < 165:
		rotation_degrees = 120
		_set_form_b()
	elif 165 <= deg and deg < 195:
		rotation_degrees = 180
		_set_form_a()
	elif 195 <= deg and deg < 225:
		rotation_degrees = 180
		_set_form_b()
	elif 225 <= deg and deg < 255:
		rotation_degrees = 240
		_set_form_a()
	elif 255 <= deg and deg < 285:
		rotation_degrees = 240
		_set_form_b()
	elif 285 <= deg and deg < 315:
		rotation_degrees = 300
		_set_form_a()
	elif 315 <= deg and deg < 345:
		rotation_degrees = 300
		_set_form_b()

	if fr_are_hexes_empty != null and !fr_are_hexes_empty.call_func(get_hexes()):
		$Footprint.color = _ERR_COLOR
		legalloc = false
	else:
		legalloc = true
		$Footprint.color = _HL_COLOR

func _set_form_a() -> void:
	$Footprint.polygon = _a_coords.foot_coords
	$Dragable.polygon = _a_coords.foot_coords
	$Unit.polygon = _a_coords.coords
	$Unit.position = _a_coords.center
	$Unit.rotation_degrees = 0
	$Pointer.polygon = _a_coords.pointer_coords
	_isFormA = true

func _set_form_b() -> void:
	$Footprint.polygon = _b_coords.foot_coords
	$Dragable.polygon = _b_coords.foot_coords
	$Unit.polygon = _b_coords.coords
	$Unit.position = _b_coords.center
	$Unit.rotation_degrees = 30
	$Pointer.polygon = _b_coords.pointer_coords
	_isFormA = false

func _pickup(dragable: Dragable) -> void:
	if legalloc:
		$Footprint.color = _HL_COLOR
		emit_signal("picked", self)

func _place(dragable: Dragable) -> void:
	if legalloc:
		$Footprint.color = _NORMAL_COLOR
		emit_signal("placed", self)
