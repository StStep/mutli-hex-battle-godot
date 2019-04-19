extends HBoxContainer

export var turn = 0

func _ready():
	SetTurn(turn)

func SetTurn(i):
	get_node("Deploying").uppercase = false
	get_node("Turn 1").uppercase = false
	get_node("Turn 2").uppercase = false
	get_node("Turn 3").uppercase = false
	get_node("Turn 4").uppercase = false
	get_node("Turn 5").uppercase = false
	get_node("Turn 6").uppercase = false
	if i == 0:
		get_node("Deploying").uppercase = true
	elif i == 1:
		get_node("Turn 1").uppercase = true
	elif i == 2:
		get_node("Turn 2").uppercase = true
	elif i == 3:
		get_node("Turn 3").uppercase = true
	elif i == 4:
		get_node("Turn 4").uppercase = true
	elif i == 5:
		get_node("Turn 5").uppercase = true
	elif i == 6:
		get_node("Turn 6").uppercase = true
	else:
		pass

