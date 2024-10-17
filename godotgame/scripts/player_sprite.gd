extends Sprite2D
@export var angle = 0
var cos = cos(angle)

func _process(delta: float) -> void:
	angle = get_angle_to(get_global_mouse_position())
	var COS = cos(angle)
	
	if (COS < 0) != (cos < 0): #AAAAAAAH werkt niet, flip is niet inherited :(
		var VECTOR = Vector2.ZERO # en de transform is fucked goofy
		if (COS < 0):
			VECTOR.x = floor(cos(angle))
		else:
			VECTOR.x = ceil(cos(angle))
		transform.scaled(VECTOR)
		cos = COS
