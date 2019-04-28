# Script to attach to a node which represents a hex grid
extends Node2D

var HexGrid = preload("res://addons/romlok.GDHexGrid/HexGrid.gd").new()

onready var hex_scene = preload("res://demos/Hex.tscn")


func _ready():
	HexGrid.hex_scale = Vector2(107.5, 107.5)

var prev_coord = null

func _unhandled_input(event):
	if event is InputEventMouseButton and event.get_button_index() == 1:
		if event.is_pressed():
			print("Mouse Click at: ", event.global_position)
			prev_coord = self.transform.affine_inverse() * get_global_mouse_position()
		else:
			print("Mouse Unclick at: ", event.global_position)
			print("New square", prev_coord, event.global_position)
			var cur_coord = self.transform.affine_inverse() * get_global_mouse_position()
			var r = Polygon2D.new()
			r.polygon = PoolVector2Array([prev_coord, Vector2(prev_coord.x, cur_coord.y), cur_coord, Vector2(cur_coord.x, prev_coord.y)])
			r.color = Color(randf(), randf(), randf())
			r.z_index = 3
			add_child(r)
			create_hex_at_pos(prev_coord)
			create_hex_at_pos(cur_coord)
			prev_coord = null

func create_hex_at_pos(relative_pos):
	var h = hex_scene.instance()
	h.position = HexGrid.get_hex_center(HexGrid.get_hex_at(relative_pos))
	add_child(h)
