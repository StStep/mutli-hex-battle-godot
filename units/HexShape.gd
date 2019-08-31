extends Node2D
class_name HexShape

enum HexColor {NONE, HIGHLIGHTED, ERROR, GHOST}

var _re_util = preload("res://Utility.gd")

class unit_coords:
	var hexes: Array
	var center: Vector2
	var coords: PoolVector2Array
	var foot_coords: PoolVector2Array
	var pointer_coords: PoolVector2Array

var polygon setget ,_get_polygon

const _NORMAL_FT_COLOR = Color(1, 1, 1, .5)
const _HL_FT_COLOR = Color( .82, .82, .36, .5)
const _ERR_FT_COLOR = Color( .82, 0, 0, .5)
const _GHOST_FT_COLOR = Color(1, 1, 1, .2)

const _NORMAL_BLK_COLOR = Color(.74, .14, .14, 1)
const _GHOST_BLK_COLOR = Color(.74, .14, .14, .5)

var _grid_ref
var _isFormA: bool = true
var _a_coords = unit_coords.new()
var _b_coords = unit_coords.new()

func _ready() -> void:
	_set_form_a()

func _get_polygon() -> Array:
	return $Footprint.polygon

func set_as(ahexes: Array, bhexes: Array, wratio: float, hratio: float, bcenter:Vector2, grid = null) -> void:
	_grid_ref = grid

	var unitw: float = _grid_ref.hex_size.y * wratio
	var unith: float = _grid_ref.hex_size.y * hratio
	_a_coords.hexes = ahexes
	_b_coords.hexes = bhexes
	_a_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_b_coords.coords = PoolVector2Array([Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)])
	_a_coords.center = Vector2(0, unith/2)
	_b_coords.center = bcenter
	var c_coord = _re_util.get_hex_outline(_grid_ref.hex_size)
	_a_coords.pointer_coords = PoolVector2Array([(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2])
	_b_coords.pointer_coords = PoolVector2Array([c_coord[1], c_coord[2], c_coord[3]])

	_a_coords.foot_coords = PoolVector2Array(_re_util.get_multi_hex_outline(_grid_ref.hex_size, Vector2(0,0), _a_coords.hexes))
	_b_coords.foot_coords = PoolVector2Array(_re_util.get_multi_hex_outline(_grid_ref.hex_size, Vector2(0,0), _b_coords.hexes))

func get_hexes() -> Array:
	var hexes = _a_coords.hexes if _isFormA else _b_coords.hexes
	var ret = []
	for hex in hexes:
		ret.append(_grid_ref.get_hex_at(global_position + _re_util.axial_to_canvas(_grid_ref.hex_size, hex).rotated(rotation)))
	return ret

func set_pos_to(glob_position: Vector2) -> void:
	var hex = _grid_ref.get_hex_at(glob_position)
	set_global_position(_grid_ref.get_hex_center(hex))

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

func set_hexcolor(hexColor):
	match(hexColor):
		HexColor.HIGHLIGHTED:
			$Footprint.color = _HL_FT_COLOR
			$Block.color = _NORMAL_BLK_COLOR
		HexColor.ERROR:
			$Footprint.color = _ERR_FT_COLOR
			$Block.color = _NORMAL_BLK_COLOR
		HexColor.GHOST:
			$Footprint.color = _GHOST_FT_COLOR
			$Block.color = _GHOST_BLK_COLOR
		_:
			$Footprint.color = _NORMAL_FT_COLOR
			$Block.color = _NORMAL_BLK_COLOR


func _set_form_a() -> void:
	$Footprint.polygon = _a_coords.foot_coords
	$Block.polygon = _a_coords.coords
	$Block.position = _a_coords.center
	$Block.rotation_degrees = 0
	$Pointer.polygon = _a_coords.pointer_coords
	_isFormA = true

func _set_form_b() -> void:
	$Footprint.polygon = _b_coords.foot_coords
	$Block.polygon = _b_coords.coords
	$Block.position = _b_coords.center
	$Block.rotation_degrees = 30
	$Pointer.polygon = _b_coords.pointer_coords
	_isFormA = false
