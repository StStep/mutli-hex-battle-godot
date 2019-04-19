extends Node

var i = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Finish_pressed():
	if (i < 6):
		i = i + 1
		get_node("GameState").SetTurn(i)
		if i == 6:
			get_node("Finish").text = "Complete"
	else:
		get_tree().change_scene("res://Start.tscn")
