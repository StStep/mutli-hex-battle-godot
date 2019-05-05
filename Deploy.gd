extends Node

onready var nd_unit = preload("res://units//Unit.tscn")

func _ready():
	pass

func _on_Finish_Deployment_pressed():
	get_tree().change_scene("res://TurnX.tscn")

func _on_BtMakeLine_pressed():
	var line = nd_unit.instance()
	line.set_as_line()
	line.dragging = true
	add_child(line)

func _on_BtMakeTroop_pressed():
	var troop = nd_unit.instance()
	troop.set_as_troop()
	troop.dragging = true
	add_child(troop)

func _on_BtMakeRegiment_pressed():
	var regiment = nd_unit.instance()
	regiment.set_as_regiment()
	regiment.dragging = true
	add_child(regiment)
