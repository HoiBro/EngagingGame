extends Sprite2D
@export var angle = 0

func _process(_delta: float) -> void:
	angle = get_angle_to(get_global_mouse_position())
	var COS = cos(angle)
	
	if (COS < 0):
		scale.x = floor(cos(angle))
	else:
		scale.x = ceil(cos(angle))
