extends Node

func _ready() -> void:
	$Deploy.create_unit = funcref($Battlefield, "create_unit")
	$Deploy.connect("finished", self, "_finished")

func _finished() -> void:
	print("Finished")