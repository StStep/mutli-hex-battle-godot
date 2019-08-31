extends Area2D
class_name FollowOnClickable

signal started(followOnClickable)
signal ended(followOnClickable)
signal updated(position)

var polygon: PoolVector2Array setget _set_polygon, _get_polygon
var enabled: bool = false setget _set_enabled, _get_enabled

var _mouse_in: bool = false
var _following: bool = false

func _set_polygon(value: PoolVector2Array) -> void:
	($CollisionPolygon2D as CollisionPolygon2D).polygon = value

func _get_polygon() -> PoolVector2Array:
	return ($CollisionPolygon2D as CollisionPolygon2D).polygon

func _set_enabled(value: bool)-> void:
	if value == enabled:
		return

	set_process_unhandled_input(value)
	enabled = value
	if _following:
		_following = false
		emit_signal("ended", self)

func _get_enabled() -> bool:
	return enabled

func _ready() -> void:
	set_process_unhandled_input(false)
	var _c
	_c = connect("mouse_entered",self, "_on_mouse_entered")
	_c = connect("mouse_exited",self, "_on_mouse_exited")
	var col_area = CollisionPolygon2D.new()
	col_area.name = "CollisionPolygon2D"
	col_area.z_index = 1
	add_child(col_area)

func _on_mouse_entered() -> void:
	_mouse_in = true

func _on_mouse_exited() -> void:
	_mouse_in = false

func _unhandled_input(event) -> void:
	if not enabled:
		return;

	if event is InputEventMouseMotion:
		if _following:
			emit_signal("updated", get_global_mouse_position())
		else:
			pass
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		# Start following
		if not _following and _mouse_in and event.pressed:
			if not _following:
				emit_signal("started", self)
			_following = true
		# Stop everything
		elif _following and not _mouse_in and event.pressed:
			_following = false
			emit_signal("ended", self)
	else:
		pass
