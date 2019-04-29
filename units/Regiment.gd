extends Node2D

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")
onready var pointer = get_node("Pointer")

var footcordsA
var footcordsB
var unitcoords
var unith
var unitw
var unitcentA
var unitcentB
var pointerCoordsA
var pointerCoordsB

static func get_outline(hex_size, center = Vector2(0,0)):
	return [Vector2(-hex_size.x/2 + center.x, center.y), Vector2(-hex_size.x/4 + center.x, -hex_size.y/2 + center.y),
			Vector2(hex_size.x/4 + center.x, -hex_size.y/2 + center.y), Vector2(hex_size.x/2 + center.x, center.y),
			Vector2(hex_size.x/4 + center.x, hex_size.y/2 + center.y), Vector2(-hex_size.x/4 + center.x, hex_size.y/2 + center.y)]

func _init(ref = null).():
	if ref == null:
		ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
		ref.hex_scale = Vector2(100, 100)
	var centercell = ref.get_hex_at(Vector2(0,0))
	var c_coord = get_outline(ref.hex_size)
	var nw_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_NW)))
	var sw_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW)))
	var se_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SE)))
	var sse_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SE)))
	var ssw_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)))
	var ss_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_S)))
	var swsw_coord = get_outline(ref.hex_size, ref.get_hex_center(centercell.get_adjacent(centercell.DIR_SW).get_adjacent(centercell.DIR_SW)))

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

	unitw = ref.hex_size.y * 2
	unith = ref.hex_size.y * 2
	unitcoords = [Vector2(-unitw/2, -unith/2), Vector2(unitw/2, -unith/2), Vector2(unitw/2, unith/2), Vector2(-unitw/2, unith/2)]
	unitcentA = Vector2(0, unith/2)
	unitcentB = (ref.get_hex_center(centercell.get_adjacent(centercell.DIR_S).get_adjacent(centercell.DIR_SW)) - ref.get_hex_center(centercell))/2

	pointerCoordsA = [(c_coord[0] + c_coord[1])/2, c_coord[1], c_coord[2] , (c_coord[2] + c_coord[3])/2]
	pointerCoordsB = [c_coord[1], c_coord[2], c_coord[3]]

func _ready():
	set_form_a()

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
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentA
	unit.rotation_degrees = 0
	pointer.polygon = PoolVector2Array(pointerCoordsA)

func set_form_b():
	footprint.polygon = PoolVector2Array(footcordsB)
	unit.polygon = PoolVector2Array(unitcoords)
	unit.position = unitcentB
	unit.rotation_degrees = 30
	pointer.polygon = PoolVector2Array(pointerCoordsB)
