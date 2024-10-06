extends Camera2D

@export var camera_height = -100
@export var zoom_speed: float = 0.1
@export var zoom_factor: float = 1

var ZOOM_EXPONENT: float = log(zoom_factor)/log(2)

func _input(event):
	if event.is_action_pressed(&"zoom_in"):
		ZOOM_EXPONENT += Input.get_action_strength("zoom_in") * zoom_speed
		zoom.x = pow(2, ZOOM_EXPONENT)
		zoom.y = pow(2, ZOOM_EXPONENT)
	elif event.is_action_pressed(&"zoom_out"):
		ZOOM_EXPONENT += -Input.get_action_strength("zoom_out") * zoom_speed
		zoom.x = pow(2, ZOOM_EXPONENT)
		zoom.y = pow(2, ZOOM_EXPONENT)
		
	else: return
	var HEIGHT_FACTOR = pow(2, log(zoom_factor)/log(2)) / pow(2, ZOOM_EXPONENT)
	position.y = camera_height * HEIGHT_FACTOR
