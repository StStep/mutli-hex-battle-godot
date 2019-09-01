extends Node2D
class_name Unit

enum UnitState {NONE, PLACING, MOVING}

signal placed(unit)
signal picked(unit)

var state = UnitState.NONE setget _set_state, _get_state
var legalloc: bool = true setget ,_get_legalloc
var fr_are_hexes_empty: FuncRef
var fr_draw_hex: FuncRef

var _drawnHexes: Array = []

func _ready() -> void:
	var _c
	_c = ($Dragable as Dragable).connect("drag_started", self, "_pickup")
	_c = ($Dragable as Dragable).connect("drag_ended", self, "_place")
	_c = ($Dragable as Dragable).connect("point_to", self, "set_front_to")
	_c = ($Dragable as Dragable).connect("drag_to", self, "set_pos_to")
	_c = ($FollowOnClickable as FollowOnClickable).connect("updated", self, "_set_prev_to")
	$Preview.hide()
	$Preview.set_hexcolor(HexShape.HexColor.GHOST)

func _set_state(value) -> void:
	if state == value:
		return

	# Prev State
	match(state):
		UnitState.PLACING:
			$Dragable.can_drag = false
		UnitState.MOVING:
			$Preview.hide()
			$FollowOnClickable.enabled = false
		_:
			pass

	# Future State
	match(value):
		UnitState.PLACING:
			$Dragable.can_drag = true
		UnitState.MOVING:
			$Preview.show()
			$Preview.set_front_to($HexShape.front_dir)
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

	var ahexes = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	var bhexes = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	($HexShape as HexShape).set_as(ahexes, bhexes, 2, 0.5, Vector2(0,0), grid)
	($Preview as HexShape).set_as(ahexes, bhexes, 2, 0.5, Vector2(0,0), grid)

func set_as_troop(grid = null) -> void:
	if grid == null:
		grid = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		grid.hex_scale = Vector2(100, 100)

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

func _set_prev_to(glob_position: Vector2) -> void:
	for p in _drawnHexes:
		p.queue_free()
	_drawnHexes.clear()
	$Preview.set_pos_to(glob_position)
	for hex in $HexShape.central_hex.line_to($Preview.central_hex):
		if fr_draw_hex != null:
			_drawnHexes.append(fr_draw_hex.call_func(hex, Color(.2,.2,.8,.8)))
