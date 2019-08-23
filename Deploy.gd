extends Node

signal finished()
var create_unit: FuncRef

onready var _nd_linecount  = get_node("UnitPalette/LineCount")
onready var _nd_troopcount  = get_node("UnitPalette/TroopCount")
onready var _nd_regcount  = get_node("UnitPalette/RegimentCount")

var busy : bool = false
var _linecnt : int = 6
var _troopcnt : int = 4
var _regcnt: int = 2
var _units: Array

func _ready() -> void:
	$UnitPalette/BtMakeLine.connect("button_down", self, "_on_BtMakeLine_pressed")
	$UnitPalette/BtMakeTroop.connect("button_down", self, "_on_BtMakeTroop_pressed")
	$UnitPalette/BtMakeRegiment.connect("button_down", self, "_on_BtMakeRegiment_pressed")
	$"Finish Deployment".connect("button_down", self, "_on_Finish_Deployment_pressed")
	_nd_linecount.text = str(_linecnt)
	_nd_troopcount.text = str(_troopcnt)
	_nd_regcount.text = str(_regcnt)

func _on_Finish_Deployment_pressed() -> void:
	emit_signal("finished")

func _on_BtMakeLine_pressed() -> void:
	if busy: return
	if _linecnt <= 0: return

	var u: Unit = create_unit.call_func("line")
	_linecnt -= 1
	_nd_linecount.text = str(_linecnt)

func _on_BtMakeTroop_pressed() -> void:
	if busy: return
	if _troopcnt <= 0: return

	var u: Unit = create_unit.call_func("troop")
	_troopcnt -= 1
	_nd_troopcount.text = str(_troopcnt)

func _on_BtMakeRegiment_pressed() -> void:
	if busy: return
	if _regcnt <= 0: return

	var u: Unit = create_unit.call_func("regiment")
	_regcnt -= 1
	_nd_regcount.text = str(_regcnt)
