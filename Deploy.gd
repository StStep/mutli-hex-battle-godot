extends Node

onready var nd_unit = preload("res://units//Unit.tscn")
onready var nd_linecount  = get_node("CanvasLayer/UnitPalette/LineCount")
onready var nd_troopcount  = get_node("CanvasLayer/UnitPalette/TroopCount")
onready var nd_regcount  = get_node("CanvasLayer/UnitPalette/RegimentCount")
onready var hexGrid = get_node("Battlefield").hexgrid

var busy = false
var linecnt = 6
var troopcnt = 4
var regcnt = 2

func _ready():
	nd_linecount.text = str(linecnt)
	nd_troopcount.text = str(troopcnt)
	nd_regcount.text = str(regcnt)

func _on_Finish_Deployment_pressed():
	get_tree().change_scene("res://TurnX.tscn")

func _on_BtMakeLine_pressed():
	if busy: return
	if linecnt <= 0: return
	var line = nd_unit.instance()
	line.set_as_line(hexGrid)
	line.dragging = true
	$Units.add_child(line)
	line.connect("drag_started", self, "_start_dragging")
	line.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(line)
	linecnt -= 1
	nd_linecount.text = str(linecnt)

func _on_BtMakeTroop_pressed():
	if busy: return
	if troopcnt <= 0: return
	var troop = nd_unit.instance()
	troop.set_as_troop(hexGrid)
	troop.dragging = true
	$Units.add_child(troop)
	troop.connect("drag_started", self, "_start_dragging")
	troop.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(troop)
	troopcnt -= 1
	nd_troopcount.text = str(troopcnt)

func _on_BtMakeRegiment_pressed():
	if busy: return
	if regcnt <= 0: return
	var regiment = nd_unit.instance()
	regiment.set_as_regiment(hexGrid)
	regiment.dragging = true
	$Units.add_child(regiment)
	regiment.connect("drag_started", self, "_start_dragging")
	regiment.connect("drag_ended", self, "_stop_dragging")
	_start_dragging(regiment)
	regcnt -= 1
	nd_regcount.text = str(regcnt)

func _start_dragging(unit):
	busy = true
	for n in $Units.get_children():
        n.can_drag = false
	unit.can_drag = true

func _stop_dragging(unit):
	busy = false
	for n in $Units.get_children():
        n.can_drag = true
