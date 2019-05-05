extends Node2D

onready var troop = get_node("Troop")
onready var regiment = get_node("Regiment")
onready var line = get_node("Line")

# Called when the node enters the scene tree for the first time.
func _ready():
	troop.set_as_troop()
	troop.can_drag = false
	regiment.set_as_regiment()
	regiment.can_drag = false
	line.set_as_line()
	line.can_drag = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		troop.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - troop.global_position)))
		regiment.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - regiment.global_position)))
		line.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - line.global_position)))
		update()

func _draw():
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * troop.global_position, Color(1,0,0), 1)
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * regiment.global_position, Color(1,0,0), 1)
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * line.global_position, Color(1,0,0), 1)
