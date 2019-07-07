extends Node2D

signal drag_started(unit)
signal drag_ended(unit)

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")
onready var pointer = get_node("Pointer")
onready var collisionArea = get_node("CollisionArea")

const NORMAL_COLOR = Color(1, 1, 1, .5)
const HL_COLOR = Color( .82, .82, .36, .5)

var setup = false
var footcordsA
var footcordsB
var unitcoords
var unith
var unitw
var unitcentA
var unitcentB
var pointerCoordsA
var pointerCoordsB

static func get_hex_outline(hex_size, center = Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]

func set_as_line(ref = null):
	if ref == null:
		ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		ref.hex_scale = Vector2(100, 100)
	grid_ref = ref

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	var c_coord = get_hex_outline(grid_ref.hex_size)
	var sw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW)))
	var se_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SE)))
	var nw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_NW)))

	footcordsA = Array()
	for i in range(0, 3): footcordsA.append(sw_coord[i])
	for i in range(1, 4): footcordsA.append(c_coord[i])
	for i in range(2, 6): footcordsA.append(se_coord[i])
	for i in range(4, 5): footcordsA.append(c_coord[i])
	for i in range(3, 6): footcordsA.append(sw_coord[i])

	footcordsB = Array()
	for i in range(0, 4): footcordsB.append(nw_coord[i])
	for i in range(2, 4): footcordsB.append(c_coord[i])
	for i in range(2, 6): footcordsB.append(se_coord[i])
	for i in range(4, 6): footcordsB.append(c_coord[i])
	for i in range(4, 6): footcordsB.append(nw_coord[i])

	unitw = grid_ref.hex_size.y * 2
	unith = grid_ref.hex_size.y / 2
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]
	unitcentA = Vector2(0, unith/2)
	unitcentB = Vector2(0,0)

	pointerCoordsA = [(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2]
	pointerCoordsB = [c_coord[1], c_coord[2], c_coord[3]]
	setup = true

func set_as_troop(ref = null):
	if ref == null:
		ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		ref.hex_scale = Vector2(100, 100)
	grid_ref = ref

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	var c_coord = get_hex_outline(grid_ref.hex_size)
	var s_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S)))
	var sw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW)))
	var se_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SE)))
	var nw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_NW)))

	footcordsA = Array()
	for i in range(0, 3): footcordsA.append(sw_coord[i])
	for i in range(1, 4): footcordsA.append(c_coord[i])
	for i in range(2, 6): footcordsA.append(se_coord[i])
	for i in range(4, 6): footcordsA.append(s_coord[i])
	for i in range(4, 6): footcordsA.append(sw_coord[i])

	footcordsB = Array()
	for i in range(0, 4): footcordsB.append(nw_coord[i])
	for i in range(2, 4): footcordsB.append(c_coord[i])
	for i in range(2, 6): footcordsB.append(se_coord[i])
	for i in range(4, 6): footcordsB.append(s_coord[i])
	for i in range(4, 6): footcordsB.append(sw_coord[i])
	for i in range(0, 2): footcordsB.append(sw_coord[i])

	unitw = grid_ref.hex_size.y * 2
	unith = grid_ref.hex_size.y
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]
	unitcentA = Vector2(0, unith/2)
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell)).normalized() * grid_ref.hex_size.y/2

	pointerCoordsA = [(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2]
	pointerCoordsB = [c_coord[1], c_coord[2], c_coord[3]]
	setup = true

func set_as_regiment(ref = null):
	if ref == null:
		ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		ref.hex_scale = Vector2(100, 100)
	grid_ref = ref

	var centercell = grid_ref.get_hex_at(Vector2(0,0))
	var c_coord = get_hex_outline(grid_ref.hex_size)
	var nw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_NW)))
	var sw_coord  = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW)))
	var se_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SE)))
	var sse_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SE)))
	var ssw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)))
	var ss_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_S)))
	var swsw_coord = get_hex_outline(grid_ref.hex_size, grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW).get_adjacent(centercell.DIR_SW)))

	footcordsA = Array()
	for i in range(0, 3): footcordsA.append(sw_coord[i])
	for i in range(1, 4): footcordsA.append(c_coord[i])
	for i in range(2, 5): footcordsA.append(se_coord[i])
	for i in range(3, 6): footcordsA.append(sse_coord[i])
	for i in range(4, 6): footcordsA.append(ss_coord[i])
	for i in range(4, 6): footcordsA.append(ssw_coord[i])
	for i in range(0, 2): footcordsA.append(ssw_coord[i])

	footcordsB = Array()
	for i in range(0, 2): footcordsB.append(sw_coord[i])
	for i in range(0, 3): footcordsB.append(nw_coord[i])
	for i in range(1, 4): footcordsB.append(c_coord[i])
	for i in range(2, 6): footcordsB.append(se_coord[i])
	for i in range(2, 6): footcordsB.append(ss_coord[i])
	for i in range(4, 6): footcordsB.append(ssw_coord[i])
	for i in range(4, 6): footcordsB.append(swsw_coord[i])
	for i in range(0, 2): footcordsB.append(swsw_coord[i])

	unitw = grid_ref.hex_size.y * 2
	unith = grid_ref.hex_size.y * 2
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]
	unitcentA = Vector2(0, unith/2)
	unitcentB = (grid_ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - grid_ref.get_hex_center(centercell))/2

	pointerCoordsA = [(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2]
	pointerCoordsB = [c_coord[1], c_coord[2], c_coord[3]]
	setup = true

func _ready():
	if setup:
		set_form_a()

func set_pos_to(glob_position):
	set_global_position(grid_ref.get_hex_center(grid_ref.get_hex_at(glob_position)))

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

func set_form_a():
	footprint.polygon = PoolVector2Array(footcordsA)
	collisionArea.polygon = PoolVector2Array(footcordsA)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentA
	unit.rotation_degrees = 0
	pointer.polygon = PoolVector2Array(pointerCoordsA)

func set_form_b():
	footprint.polygon = PoolVector2Array(footcordsB)
	collisionArea.polygon = PoolVector2Array(footcordsB)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentB
	unit.rotation_degrees = 30
	pointer.polygon = PoolVector2Array(pointerCoordsB)

var grid_ref
var can_drag = true
var mouse_in = false
var dragging = false
var pointing = false

func _on_Unit_mouse_entered():
	print("boooooo")
	mouse_in = true

func _on_Unit_mouse_exited():
	print("oooooob")
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
		# Start dragging
		elif not dragging and mouse_in and not event.pressed:
			if not pointing and not dragging: emit_signal("drag_started", self)
			dragging = true
			pointing = false
			footprint.color = HL_COLOR
			print("Start dragging")
		# Stop everything
		elif (dragging or pointing) and not event.pressed:
			pointing = false
			dragging = false
			footprint.color = NORMAL_COLOR
			print("Stopping")
			emit_signal("drag_ended", self)
	else:
		pass
