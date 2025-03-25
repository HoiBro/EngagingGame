extends Camera2D

@export var zoom_speed: float = 0.1

var ZOOM_START: float = 0.1501
var ZOOM_EXPONENT: float = log(ZOOM_START)/log(2)

func _ready() -> void:
	zoom = Vector2(ZOOM_START, ZOOM_START)

func _input(event) -> void:
	if event.is_action_pressed(&"zoom_in"):
		if zoom.x < 1:
			print_orphan_nodes()
			print("hiii")
			ZOOM_EXPONENT += Input.get_action_strength("zoom_in") * zoom_speed
			zoom = Vector2(pow(2, ZOOM_EXPONENT), pow(2, ZOOM_EXPONENT))
	if event.is_action_pressed(&"zoom_out"):
		if zoom.x > ZOOM_START:
			ZOOM_EXPONENT -= Input.get_action_strength("zoom_out") * zoom_speed
			zoom = Vector2(pow(2, ZOOM_EXPONENT), pow(2, ZOOM_EXPONENT))
