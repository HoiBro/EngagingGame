extends Camera2D

@export var camera_height = -100
@export var zoom_speed = 0.1
@export var zoom_factor = 1
@export var smoothing_speed = 10

var zoom_start = 0.5

var ZOOM_EXPONENT: float = log(zoom_factor)/log(2) + log(zoom_start)/log(2)

func _ready() -> void:
	position.y = camera_height
	zoom = Vector2(zoom_start, zoom_start)
	position_smoothing_enabled = true
	position_smoothing_speed = smoothing_speed

func _input(event) -> void:
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
