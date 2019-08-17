extends Node2D

var util = preload("res://Utility.gd")

func _ready():
	# Top Bottom
	print("X\n|\nX")
	print(util.get_neighbors([Vector2(0,0), Vector2(0,-1)]))

	# Quad
	print("   X\nX     X\n   X")
	print(util.get_neighbors([Vector2(0,0), Vector2(1,-1), Vector2(1,0), Vector2(2,-1)]))