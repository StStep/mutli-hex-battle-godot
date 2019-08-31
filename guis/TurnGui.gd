extends CanvasLayer

signal finishedDeploying()
signal finishedTurn()

var turn = 0

func _ready() -> void:
	var _c
	_c = $FinishDeploy.connect("button_down", self, "_on_finish_deploy")
	_c = $FinishTurn.connect("button_down", self, "_on_finish_turn")
	$FinishTurn.visible = false

func _on_finish_deploy() -> void:
	turn = 1
	$TurnHeader.SetTurn(turn)
	emit_signal("finishedDeploying")
	$FinishDeploy.visible = false
	$FinishTurn.visible = true


func _on_finish_turn() -> void:
	if (turn < 6):
		turn = turn + 1
		$TurnHeader.SetTurn(turn)
		if turn == 6:
			$FinishTurn.text = "Complete"
	emit_signal("finishedTurn")