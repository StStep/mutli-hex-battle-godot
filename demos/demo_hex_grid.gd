# Script to attach to a node which represents a hex grid
extends Node2D

var HexGrid = preload("res://addons/romlok.GDHexGrid/HexGrid.gd").new()

onready var highlight = get_node("Highlight")
onready var area_coords = get_node("Highlight/AreaCoords")
onready var hex_coords = get_node("Highlight/HexCoords")


func _ready():
	HexGrid.hex_scale = Vector2(108.55, 108.55)

func _unhandled_input(event):
	if 'position' in event:
		var relative_pos = self.transform.affine_inverse() * get_global_mouse_position()

		# Display the coords used
		if area_coords != null:
			area_coords.text = str(relative_pos)
		if hex_coords != null:
			hex_coords.text = str(HexGrid.get_hex_at(relative_pos).axial_coords)

		# Snap the highlight to the nearest grid cell
		if highlight != null:
			highlight.position = HexGrid.get_hex_center(HexGrid.get_hex_at(relative_pos))
