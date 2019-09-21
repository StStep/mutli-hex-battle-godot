extends Node2D
class_name HexUnit

var _re_unit = preload("res://battlefield/Unit.gd")

signal placed(unit)
signal picked(unit)

var state = _re_unit.State.NONE setget _set_state, _get_state
var legalloc: bool = true setget ,_get_legalloc
var fr_are_hexes_empty: FuncRef
var fr_draw_hex: FuncRef

var _grid_ref
var _drawnHexes: Array = []
var _a_valid_move_locs: Array = [hex_loc.new(Vector2(0, 0), 0), hex_loc.new(Vector2(0,-2), 0)]
var _b_valid_move_locs: Array = [hex_loc.new(Vector2(0, 0), 0), hex_loc.new(Vector2(1,-2), 0)]

class hex_loc:
	var axial_offset: Vector2
	var deg_offset: float

	func _init(ax_off: Vector2, deg: float):
		axial_offset = ax_off
		deg_offset = deg

func _ready() -> void:
	var _c
	_c = ($Dragable as Dragable).connect("drag_started", self, "_pickup")
	_c = ($Dragable as Dragable).connect("drag_ended", self, "_place")
	_c = ($Dragable as Dragable).connect("point_to", self, "set_front_to")
	_c = ($Dragable as Dragable).connect("drag_to", self, "set_pos_to")
	_c = ($FollowOnClickable as FollowOnClickable).connect("updated", self, "_filter_by_valid_move_locs")
	$Preview.hide()
	$Preview.set_hexcolor(HexShape.HexColor.GHOST)

func _set_state(value) -> void:
	if state == value:
		return

	# Prev State
	match(state):
		_re_unit.State.PLACING:
			$Dragable.can_drag = false
		_re_unit.State.MOVING:
			$Preview.hide()
			$FollowOnClickable.enabled = false
			for p in _drawnHexes:
				p.queue_free()
			_drawnHexes.clear()
		_:
			pass

	# Future State
	match(value):
		_re_unit.State.PLACING:
			$Dragable.can_drag = true
		_re_unit.State.MOVING:
			$Preview.show()
			$Preview.set_pos_to($HexShape.global_position)
			$Preview.set_front_to_deg($HexShape.front_dir_deg)
			$FollowOnClickable.global_position = $Dragable.global_position
			$FollowOnClickable.polygon = $Dragable.polygon
			$FollowOnClickable.rotation_degrees = $Dragable.rotation_degrees
			$FollowOnClickable.enabled = true
		_:
			assert(true)
	state = value

func _get_state():
	return state

func _get_legalloc() -> bool:
	return legalloc

func _pickup(_dragable: Dragable) -> void:
	if legalloc:
		$HexShape.set_hexcolor(HexShape.HexColor.HIGHLIGHTED)
		emit_signal("picked", self)

func _place(_dragable: Dragable) -> void:
	if legalloc:
		($HexShape as HexShape).set_hexcolor(HexShape.HexColor.NONE)
		emit_signal("placed", self)

func set_as_line(grid = null) -> void:
	if grid == null:
		grid = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		grid.hex_scale = Vector2(100, 100)
	_grid_ref = grid

	var ahexes = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	var bhexes = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	($HexShape as HexShape).set_as(ahexes, bhexes, 2, 0.5, Vector2(0,0), grid)
	($Preview as HexShape).set_as(ahexes, bhexes, 2, 0.5, Vector2(0,0), grid)

func set_as_troop(grid = null) -> void:
	if grid == null:
		grid = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		grid.hex_scale = Vector2(100, 100)
	_grid_ref = grid

	var ahexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1)]
	var bhexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
	var centercell = grid.get_hex_at(Vector2(0,0))
	var bcenter = (grid.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid.get_hex_center(centercell)).normalized() * grid.hex_size.y/2
	($HexShape as HexShape).set_as(ahexes, bhexes, 2, 1, bcenter, grid)
	($Preview as HexShape).set_as(ahexes, bhexes, 2, 1, bcenter, grid)

func set_as_regiment(grid = null) -> void:
	if grid == null:
		grid = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		grid.hex_scale = Vector2(100, 100)
	_grid_ref = grid

	var ahexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,2), Vector2(1,1), Vector2(0,2)]
	var bhexes = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(-1,2), Vector2(-2,2), Vector2(0,2)]
	var centercell = grid.get_hex_at(Vector2(0,0))
	var bcenter = (grid.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid.get_hex_center(centercell))/2
	($HexShape as HexShape).set_as(ahexes, bhexes, 2, 2, bcenter, grid)
	($Preview as HexShape).set_as(ahexes, bhexes, 2, 2, bcenter, grid)

func get_hexes() -> Array:
	return $HexShape.get_hexes()

func set_pos_to(glob_position: Vector2) -> void:
	$HexShape.set_pos_to(glob_position)
	_update_loc()

func set_front_to(x: float) -> void:
	$HexShape.set_front_to(x)
	_update_loc()

func _update_loc():
	if fr_are_hexes_empty != null and !fr_are_hexes_empty.call_func($HexShape.get_hexes()):
		($HexShape as HexShape).set_hexcolor(HexShape.HexColor.ERROR)
		legalloc = false
	else:
		($HexShape as HexShape).set_hexcolor(HexShape.HexColor.HIGHLIGHTED)
		legalloc = true
	$Dragable.global_position = $HexShape.global_position
	$Dragable.polygon = $HexShape.polygon
	$Dragable.rotation_degrees = $HexShape.rotation_degrees

func _set_prev_to(glob_position: Vector2, deg: float) -> void:
	for p in _drawnHexes:
		p.queue_free()
	_drawnHexes.clear()
	$Preview.set_pos_to(glob_position)
	$Preview.set_front_to_deg(deg)
	for hex in $HexShape.central_hex.line_to($Preview.central_hex):
		if fr_draw_hex != null:
			_drawnHexes.append(fr_draw_hex.call_func(hex, Color(.2,.2,.8,.8)))

func _filter_by_valid_move_locs(glob_position: Vector2) -> void:
	var tar_hex = _grid_ref.get_hex_at(glob_position)
	var closest: hex_loc = null
	var min_dist: float = -1
	for loc in _a_valid_move_locs if $HexShape.is_formA else _b_valid_move_locs:
		var loc_hex = $HexShape.get_relative_axial_hex(loc.axial_offset)
		var dist = loc_hex.distance_to(tar_hex)
		if min_dist < 0 or dist < min_dist:
			closest = loc
			min_dist = dist
	if closest != null:
		var close_pos = _grid_ref.get_hex_center($HexShape.get_relative_axial_hex(closest.axial_offset))
		var close_dir_deg = $HexShape.front_dir_deg + closest.deg_offset
		_set_prev_to(close_pos, close_dir_deg)
