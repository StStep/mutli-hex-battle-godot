extends Area2D
class_name Dragable

signal drag_started(dragable)
signal drag_ended(dragable)
signal point_to(angle)
signal drag_to(position)

var polygon: PoolVector2Array setget _polygon_set, _polygon_get
var can_drag: bool = true
var dragging: bool = false

var _mouse_in: bool = false
var _pointing: bool = false


func _polygon_set(value: PoolVector2Array):
    ($CollisionPolygon2D as CollisionPolygon2D).polygon = value

func _polygon_get() -> PoolVector2Array:
    return ($CollisionPolygon2D as CollisionPolygon2D).polygon

func _ready() -> void:
	connect("mouse_entered",self, "_on_mouse_entered")
	connect("mouse_exited",self, "_on_mouse_exited")
	var col_area = CollisionPolygon2D.new()
	col_area.name = "CollisionPolygon2D"
	col_area.z_index = 1
	add_child(col_area)

func _on_mouse_entered() -> void:
	_mouse_in = true

func _on_mouse_exited() -> void:
	_mouse_in = false

func _unhandled_input(event) -> void:
	if not can_drag:
		return;

	if event is InputEventMouseMotion:
		if _pointing:
			if not _mouse_in:
				emit_signal("point_to", Vector2(0, 1).angle_to((get_global_mouse_position() - global_position)))
		elif dragging:
			emit_signal("drag_to", get_global_mouse_position())
		else:
			pass
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		# Start pointing
		if not _pointing and _mouse_in and event.pressed:
			if not _pointing and not dragging:
				emit_signal("drag_started", self)
			_pointing = true
		# Start dragging
		elif not dragging and _mouse_in and not event.pressed:
			if not _pointing and not dragging:
				emit_signal("drag_started", self)
			dragging = true
			_pointing = false
		# Stop everything
		elif (dragging or _pointing) and not event.pressed:
			_pointing = false
			dragging = false
			print("Stopping")
			emit_signal("drag_ended", self)
	else:
		pass
