extends Camera2D
@export var zoom_factor :float = 1
var ZOOM_EXPONENT :float = log(zoom_factor)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_axis("zoom_in","zoom_out") != 0:
		ZOOM_EXPONENT += Input.get_axis("zoom_in","zoom_out")
		zoom.x = pow(10, ZOOM_EXPONENT)
		zoom.y = pow(10, ZOOM_EXPONENT)
