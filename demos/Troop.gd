extends Node2D

onready var footprint = get_node("Footprint")
var center
var footcoords

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
	footcoords = Array()
	for i in range(0, 3): footcoords.append(coord3[i])
	for i in range(1, 4): footcoords.append(coord1[i])
	for i in range(2, 6): footcoords.append(coord4[i])
	for i in range(4, 6): footcoords.append(coord2[i])
	for i in range(4, 6): footcoords.append(coord3[i])

func _ready():
	footprint.polygon = PoolVector2Array(footcoords)
