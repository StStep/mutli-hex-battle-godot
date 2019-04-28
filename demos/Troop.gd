extends Node2D

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")

var footcordsA
var footcordsB
var unitcoords
var unith
var unitw

static func get_outline(hex_size, center = Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]

func _init(ref = null).():
	if ref == null:
		ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		ref.hex_scale = Vector2(100, 100)
	var centercell = ref.get_hex_at(Vector2(0,0))
	var coord1 = get_outline(ref.hex_size)
	var coord2 = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S)))
	var coord3 = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW)))
	var coord4 = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SE)))
	var coord5 = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_NW)))

	footcordsA = Array()
	for i in range(0, 3): footcordsA.append(coord3[i])
	for i in range(1, 4): footcordsA.append(coord1[i])
	for i in range(2, 6): footcordsA.append(coord4[i])
	for i in range(4, 6): footcordsA.append(coord2[i])
	for i in range(4, 6): footcordsA.append(coord3[i])

	footcordsB = Array()
	for i in range(0, 4): footcordsB.append(coord5[i])
	for i in range(2, 4): footcordsB.append(coord1[i])
	for i in range(2, 6): footcordsB.append(coord4[i])
	for i in range(4, 6): footcordsB.append(coord2[i])
	for i in range(4, 6): footcordsB.append(coord3[i])
	for i in range(0, 2): footcordsB.append(coord3[i])

	unitw = ref.hex_size.x * 2 * .85
	unith = ref.hex_size.y
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]

func _ready():
	set_form_a()

var form_a = true
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - global_position)))
		update()

func _draw():
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * position, Color(1,0,0), 1)

func set_front_to(x):
	var deg = ((x + PI) * 180 / PI)
	print("Angle is " +  str(deg))
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
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = Vector2(0, unith/2)
	unit.rotation_degrees = 0

func set_form_b():
	footprint.polygon = PoolVector2Array(footcordsB)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.rotation_degrees = 30
	unit.position = Vector2(-unitw/13.5, unith/4)