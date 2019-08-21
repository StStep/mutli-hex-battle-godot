extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Troop.set_as_troop()
	$Troop/Dragable.can_drag = false
	$Regiment.set_as_regiment()
	$Regiment/Dragable.can_drag = false
	$Line.set_as_line()
	$Line/Dragable.can_drag = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Troop.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - $Troop.global_position)))
		$Regiment.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - $Regiment.global_position)))
		$Line.set_front_to(Vector2(0, 1).angle_to((get_global_mouse_position() - $Line.global_position)))
		update()

func _draw():
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * $Troop.global_position, Color(1,0,0), 1)
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * $Regiment.global_position, Color(1,0,0), 1)
	draw_line(self.transform.affine_inverse() * get_global_mouse_position(), self.transform.affine_inverse() * $Line.global_position, Color(1,0,0), 1)
