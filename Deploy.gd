extends Node

onready var nd_unit = preload("res://units//Unit.tscn")

var busy = false

func _ready():
	pass

func _on_Finish_Deployment_pressed():
	get_tree().change_scene("res://TurnX.tscn")

func _on_BtMakeLine_pressed():
	if busy: return
	var line = nd_unit.instance()
	line.set_as_line()
	line.dragging = true
	$Units.add_child(line)
	line.connect("drag_started", self, "_start_dragging")
	line.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(line)

func _on_BtMakeTroop_pressed():
	if busy: return
	var troop = nd_unit.instance()
	troop.set_as_troop()
	troop.dragging = true
	$Units.add_child(troop)
	troop.connect("drag_started", self, "_start_dragging")
	troop.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(troop)

func _on_BtMakeRegiment_pressed():
	if busy: return
	var regiment = nd_unit.instance()
	regiment.set_as_regiment()
	regiment.dragging = true
	$Units.add_child(regiment)
	regiment.connect("drag_started", self, "_start_dragging")
	regiment.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(regiment)

func _start_dragging(unit):
	busy = true
	for n in $Units.get_children():
        n.can_drag = false
	unit.can_drag = true

func _stop_dragging(unit):
	busy = false
	for n in $Units.get_children():
        n.can_drag = true
