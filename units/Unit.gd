extends Node2D

var util = preload("res://Utility.gd")

signal drag_started(unit)
signal drag_ended(unit)

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")
onready var pointer = get_node("Pointer")
onready var collisionArea = get_node("CollisionArea")

const NORMAL_COLOR = Color(1, 1, 1, .5)
const HL_COLOR = Color( .82, .82, .36, .5)
const ERR_COLOR = Color( .82, 0, 0, .5)

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

func set_as(wratio, hratio, ref = null):
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

func set_as_line(ref = null):
	hexesA = [Vector2(-1,1), Vector2(0,0), Vector2(1,0)]
	hexesB = [Vector2(-1,0), Vector2(0,0), Vector2(1,0)]
	set_as(2, 0.5, ref)

	unitcentB = Vector2(0,0)
	setup = true

func set_as_troop(ref = null):
	hexesA = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1)]
	hexesB = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0)]
	set_as(2, 1, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell)).normalized() * grid_ref.hex_size.y/2
	setup = true

func set_as_regiment(ref = null):
	hexesA = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,2), Vector2(1,1), Vector2(0,2)]
	hexesB = [Vector2(0,0), Vector2(-1,1), Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(-1,2), Vector2(-2,2), Vector2(0,2)]
	set_as(2, 2, ref)

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell))/2
	setup = true

func get_hexes():
	var hexes = hexesA if isFormA else hexesB
	var ret = []
	for hex in hexes:
		ret.append(grid_ref.get_hex_at(global_position + util.axial_to_canvas(grid_ref.hex_size, hex).rotated(rotation)))
	return ret

func _ready():
	if setup:
		set_form_a()

func set_pos_to(glob_position):
	var hex = grid_ref.get_hex_at(glob_position)
	set_global_position(grid_ref.get_hex_center(hex))

	if battlefield != null and !battlefield.is_free(get_hexes()):
		footprint.color = ERR_COLOR
		legalloc = false
	else:
		footprint.color = HL_COLOR
		legalloc = true

func set_front_to(x):
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

func set_form_a():
	footprint.polygon = PoolVector2Array(footcordsA)
	collisionArea.polygon = PoolVector2Array(footcordsA)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentA
	unit.rotation_degrees = 0
	pointer.polygon = PoolVector2Array(pointerCoordsA)
	isFormA = true

func set_form_b():
	footprint.polygon = PoolVector2Array(footcordsB)
	collisionArea.polygon = PoolVector2Array(footcordsB)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentB
	unit.rotation_degrees = 30
	pointer.polygon = PoolVector2Array(pointerCoordsB)
	isFormA = false

var grid_ref
var can_drag = true
var mouse_in = false
var dragging = false
var pointing = false
var battlefield

func _on_Unit_mouse_entered():
	mouse_in = true

func _on_Unit_mouse_exited():
	mouse_in = false

func _unhandled_input(event):
	if not can_drag or not setup:
		return;

	if event is InputEventMouseMotion:
		if pointing:
			if not mouse_in:
				set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - global_position)))
		elif dragging:
			set_pos_to(get_global_mouse_position())
		else:
			pass
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		# Start pointing
		if not pointing and mouse_in and event.pressed:
			if not pointing and not dragging: emit_signal("drag_started", self)
			pointing = true
			footprint.color = HL_COLOR
			print("Start pointing")
			if legalloc:
				battlefield.remove_unit(get_hexes())
		# Start dragging
		elif not dragging and mouse_in and not event.pressed:
			if not pointing and not dragging: emit_signal("drag_started", self)
			dragging = true
			pointing = false
			footprint.color = HL_COLOR
			print("Start dragging")
			if legalloc:
				battlefield.remove_unit(get_hexes())
		# Stop everything
		elif (dragging or pointing) and not event.pressed:
			pointing = false
			dragging = false
			footprint.color = NORMAL_COLOR if legalloc else ERR_COLOR
			print("Stopping")
			emit_signal("drag_ended", self)
			if legalloc:
				battlefield.place_unit(get_hexes())
	else:
		pass
