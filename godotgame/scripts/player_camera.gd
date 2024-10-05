extends Camera2D

@export var zoom_factor :float = 1
var ZOOM_EXPONENT :float = log(zoom_factor)

func _input(event):
	if event.is_action_pressed(&"zoom_in"):
		ZOOM_EXPONENT += Input.get_action_strength("zoom_in")
		zoom.x = pow(2, ZOOM_EXPONENT)
		zoom.y = pow(2, ZOOM_EXPONENT)
	elif event.is_action_pressed(&"zoom_out"):
		ZOOM_EXPONENT += -Input.get_action_strength("zoom_out")
		zoom.x = pow(2, ZOOM_EXPONENT)
		zoom.y = pow(2, ZOOM_EXPONENT)
