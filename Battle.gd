extends Node

enum BatttleState {NONE, DEPLOYING, MOVEMENT}

var state = BatttleState.NONE

func _ready() -> void:
	$DeployGui.create_unit = funcref($Battlefield, "create_unit")
	$TurnGui.connect("finishedDeploying", self, "_end_deployment")

	_enter_deploy_State()

func _end_deployment() -> void:
	_enter_move_state()

func _enter_deploy_State() -> void:
	state = BatttleState.DEPLOYING
	$DeployGui.enable()

func _enter_move_state() -> void:
	state = BatttleState.MOVEMENT
	$DeployGui.disable()
