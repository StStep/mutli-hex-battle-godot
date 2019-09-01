extends Node

var u1

func _ready() -> void:
	u1 = $Battlefield.create_unit("line")

func _unhandled_input( event ):
	if u1 == null:
		return

	if event.is_action_pressed("ui_accept"):
		print("Toggle movement mode")
		if u1.state == Unit.UnitState.MOVING:
			u1.state = Unit.UnitState.PLACING
			$CanvasLayer/Text.text = "DEPLOYING"
		else:
			u1.state = Unit.UnitState.MOVING
			$CanvasLayer/Text.text = "MOVING"