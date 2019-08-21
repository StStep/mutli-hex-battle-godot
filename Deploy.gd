extends Node

onready var nd_unit = preload("res://units//Unit.tscn")
onready var nd_linecount  = get_node("CanvasLayer/UnitPalette/LineCount")
onready var nd_troopcount  = get_node("CanvasLayer/UnitPalette/TroopCount")
onready var nd_regcount  = get_node("CanvasLayer/UnitPalette/RegimentCount")
onready var nd_battlefield = get_node("Battlefield")

var busy : bool = false
var linecnt : int = 6
var troopcnt : int = 4
var regcnt: int = 2

func _ready() -> void:
	nd_linecount.text = str(linecnt)
	nd_troopcount.text = str(troopcnt)
	nd_regcount.text = str(regcnt)

func _on_Finish_Deployment_pressed() -> void:
	get_tree().change_scene("res://TurnX.tscn")

func _on_BtMakeLine_pressed() -> void:
	if busy: return
	if linecnt <= 0: return

	var line = nd_unit.instance() as Unit
	line.set_as_line(nd_battlefield)
	var drag = line.get_node("Dragable") as Dragable
	drag.dragging = true
	$Units.add_child(line)
	drag.connect("drag_started", self, "_start_dragging")
	drag.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(drag)
	linecnt -= 1
	nd_linecount.text = str(linecnt)

func _on_BtMakeTroop_pressed() -> void:
	if busy: return
	if troopcnt <= 0: return

	var troop = nd_unit.instance() as Unit
	troop.set_as_troop(nd_battlefield)
	var drag = troop.get_node("Dragable") as Dragable
	drag.dragging = true
	$Units.add_child(troop)
	drag.connect("drag_started", self, "_start_dragging")
	drag.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(drag)
	troopcnt -= 1
	nd_troopcount.text = str(troopcnt)

func _on_BtMakeRegiment_pressed() -> void:
	if busy: return
	if regcnt <= 0: return

	var regiment = nd_unit.instance() as Unit
	regiment.set_as_regiment(nd_battlefield)
	var drag = regiment.get_node("Dragable") as Dragable
	drag.dragging = true
	$Units.add_child(regiment)
	drag.connect("drag_started", self, "_start_dragging")
	drag.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(drag)
	regcnt -= 1
	nd_regcount.text = str(regcnt)

func _start_dragging(dragable: Dragable) -> void:
	busy = true
	for n in $Units.get_children():
        n.get_node("Dragable").can_drag = false
	dragable.can_drag = true

func _stop_dragging(dragable: Dragable) -> void:
	busy = false
	for n in $Units.get_children():
        n.get_node("Dragable").can_drag = true
