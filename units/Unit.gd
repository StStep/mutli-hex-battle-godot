extends Node2D
class_name Unit

var util = preload("res://Utility.gd")

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")
onready var pointer = get_node("Pointer")

const NORMAL_COLOR = Color(1, 1, 1, .5)
const HL_COLOR = Color( .82, .82, .36, .5)
const ERR_COLOR = Color( .82, 0, 0, .5)

var battlefield
var grid_ref

var setup = false
var isFormA = true
var legalloc = true
var hexesA
var hexesB
var footcordsA
var footcordsB
var unitcoords
var unith
var unitw
var unitcentA
var unitcentB
var pointerCoordsA
var pointerCoordsB

func _ready() -> void:
	if setup:
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

	unitw = grid_ref.hex_size.y * wratio
	unith = grid_ref.hex_size.y * hratio
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]
	unitcentA = Vector2(0, unith/2)
	var c_coord = util.get_hex_outline(grid_ref.hex_size)
	pointerCoordsA = [(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2]
	pointerCoordsB = [c_coord[1], c_coord[2], c_coord[3]]

	footcordsA = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(0,0), hexesA)
	footcordsB = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(0,0), hexesB)

func set_as_line(ref = null) -> void:
	hexesA = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	hexesB = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	set_as(2, 0.5, ref)

	unitcentB = Vector2(0,0)
	setup = true

func set_as_troop(ref = null) -> void:
	hexesA = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1)]
	hexesB = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
	set_as(2, 1, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell)).normalized() * grid_ref.hex_size.y/2
	setup = true

func set_as_regiment(ref = null) -> void:
	hexesA = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,2), Vector2(1,1), Vector2(0,2)]
	hexesB = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(-1,2), Vector2(-2,2), Vector2(0,2)]
	set_as(2, 2, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell))/2
	setup = true

func get_hexes() -> Array:
	var hexes = hexesA if isFormA else hexesB
	var ret = []
	for hex in hexes:
		ret.append(grid_ref.get_hex_at(global_position + util.axial_to_canvas(grid_ref.hex_size, hex).rotated(rotation)))
	return ret

func pickup(dragable: Dragable) -> void:
	if legalloc:
		footprint.color = HL_COLOR
		battlefield.remove_unit(get_hexes())

func place(dragable: Dragable) -> void:
	if legalloc:
		footprint.color = NORMAL_COLOR
		battlefield.place_unit(get_hexes())

func set_pos_to(glob_position: Vector2) -> void:
	var hex = grid_ref.get_hex_at(glob_position)
	set_global_position(grid_ref.get_hex_center(hex))

	if battlefield != null and !battlefield.is_free(get_hexes()):
		footprint.color = ERR_COLOR
		legalloc = false
	else:
		footprint.color = HL_COLOR
		legalloc = true

func set_front_to(x: float) -> void:
	var deg = ((x + PI) * 180 / PI)
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
		footprint.color = ERR_COLOR
		legalloc = false
	else:
		legalloc = true
		footprint.color = HL_COLOR

func set_form_a() -> void:
	footprint.polygon = PoolVector2Array(footcordsA)
	$Dragable.polygon = PoolVector2Array(footcordsA)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentA
	unit.rotation_degrees = 0
	pointer.polygon = PoolVector2Array(pointerCoordsA)
	isFormA = true

func set_form_b() -> void:
	footprint.polygon = PoolVector2Array(footcordsB)
	$Dragable.polygon = PoolVector2Array(footcordsB)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentB
	unit.rotation_degrees = 30
	pointer.polygon = PoolVector2Array(pointerCoordsB)
	isFormA = false
