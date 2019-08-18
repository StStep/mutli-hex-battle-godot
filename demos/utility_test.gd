extends Node2D

var util = preload("res://Utility.gd")

func _ready():
	var grid_ref = load("res://addons/romlok.GDHexGrid/HexGrid.gd").new()
	grid_ref.hex_scale = Vector2(100, 100)

	# Top Bottom
	print("X\n|\nX")
	print(util.get_neighbors([Vector2(0,0), Vector2(0,-1)]))

	# Quad
	print("   X\nX     X\n   X")
	print(util.get_neighbors([Vector2(0,0), Vector2(1,-1), Vector2(1,0), Vector2(2,-1)]))

	var center = Vector2(150,200)
	$Poly.polygon = PoolVector2Array(util.get_hex_outline(grid_ref.hex_size, center))
	center = center + util.axial_to_canvas(grid_ref.hex_size, Vector2(1,-1))
	$Poly2.polygon = PoolVector2Array(util.get_hex_outline(grid_ref.hex_size, center))

	var points3 = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(300,300), [Vector2(0,0), Vector2(1,-1), Vector2(1,0), Vector2(2,-1), Vector2(2,-2)])
	$Poly3.polygon = PoolVector2Array(points3)

	var points4 = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(700,500), [Vector2(0,0), Vector2(0,-1), Vector2(0,-2)])
	$Poly4.polygon = PoolVector2Array(points4)

	var points5 = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(500,500), [Vector2(0,0), Vector2(-1,0), Vector2(1,-1), Vector2(0,1)])
	$Poly5.polygon = PoolVector2Array(points5)

	var points6 = util.get_multi_hex_outline(grid_ref.hex_size, Vector2(500,80), [Vector2(-1,1), Vector2(0,0), Vector2(1,0), Vector2(2,-1), Vector2(3,-1)])
	$Poly6.polygon = PoolVector2Array(points6)
