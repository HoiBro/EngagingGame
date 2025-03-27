extends Node2D

var ANGLE: float = 0

func _physics_process(_delta: float) -> void:
	ANGLE = get_angle_to(get_global_mouse_position())
	if cos(ANGLE) < 0:
		scale.x = floor(cos(ANGLE))
	else:
		scale.x = ceil(cos(ANGLE))
