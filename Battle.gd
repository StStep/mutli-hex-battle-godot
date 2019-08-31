extends Node

enum BattleState {NONE, DEPLOYING, MOVEMENT}

var _state = BattleState.NONE

func _ready() -> void:
	$DeployGui.create_unit = funcref($Battlefield, "create_unit")
	var _c = $TurnGui.connect("finishedDeploying", self, "_end_deployment")

	_enter_deploy_state()

func _end_deployment() -> void:
	_enter_move_state()

func _enter_deploy_state() -> void:
	_state = BattleState.DEPLOYING
	$DeployGui.enable()
	for u in $Battlefield.get_units():
		u.state = Unit.UnitState.PLACING

func _enter_move_state() -> void:
	_state = BattleState.MOVEMENT
	$DeployGui.disable()
	for u in $Battlefield.get_units():
		u.state = Unit.UnitState.MOVING
