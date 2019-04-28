extends Node2D

onready var footprint = get_node("Footprint")
onready var unit = get_node("Unit")

var center
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
	center = ref.get_hex_center(centercell)
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
	if event is InputEventMouseButton and event.get_button_index() == 1:
		if event.is_pressed():
			if form_a:
				set_form_b()
				form_a = false
			else:
				set_form_a()
				form_a = true

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